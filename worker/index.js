const CORS = {
  'Access-Control-Allow-Origin': '*',
  'Access-Control-Allow-Methods': 'POST, OPTIONS',
  'Access-Control-Allow-Headers': 'Content-Type',
};

function json(data, status = 200) {
  return new Response(JSON.stringify(data), {
    status,
    headers: { 'Content-Type': 'application/json', ...CORS },
  });
}

export default {
  async fetch(request, env) {
    if (request.method === 'OPTIONS') return new Response(null, { headers: CORS });
    if (request.method !== 'POST') return json({ ok: false, error: 'POST only' }, 405);

    let body;
    try { body = await request.json(); }
    catch { return json({ ok: false, error: 'Invalid JSON' }, 400); }

    const { op } = body;

    try {
      switch (op) {
        case 'get_config':        return json(await getConfig(env));
        case 'get_responders':    return json(await getResponders(env));
        case 'get_org':           return json(await getOrg(env));
        case 'get_site_assign':   return json(await getSiteAssign(env));
        case 'get_pullout_rules': return json(await getPulloutRules(env));
        case 'load':              return json(await loadSchedule(env, body.name));
        case 'save':              return json(await saveSchedule(env, body.name, body.data));

        // Admin write ops — protected by ADMIN_TOKEN secret set in wrangler dashboard
        case 'admin_save_config':        return json(await adminSaveConfig(env, body));
        case 'admin_save_responders':    return json(await adminSaveResponders(env, body));
        case 'admin_save_org':           return json(await adminSaveOrg(env, body));
        case 'admin_save_site_assign':   return json(await adminSaveSiteAssign(env, body));
        case 'admin_save_pullout_rules': return json(await adminSavePulloutRules(env, body));

        default: return json({ ok: false, error: `Unknown op: ${op}` }, 400);
      }
    } catch (e) {
      console.error(op, e);
      return json({ ok: false, error: e.message }, 500);
    }
  },
};

/* ── reads ── */

async function getConfig(env) {
  const [cfgRows, holRows] = await Promise.all([
    env.DB.prepare('SELECT key, value FROM config').all(),
    env.DB.prepare('SELECT date FROM holidays').all(),
  ]);
  const cfg = Object.fromEntries(cfgRows.results.map(r => [r.key, r.value]));
  return {
    ok: true,
    data: {
      START_DATE:      cfg.start_date      || null,
      END_DATE:        cfg.end_date        || null,
      'DEADLINE DATE': cfg.deadline_date   || null,
      'DEADLINE TIME': cfg.deadline_time   || null,
      HOLIDAYS:        holRows.results.map(r => r.date),
    },
  };
}

async function getResponders(env) {
  const { results } = await env.DB.prepare(
    'SELECT name, position, team, division, department FROM responders ORDER BY name'
  ).all();
  return {
    ok: true,
    data: results.map(r => ({
      NAME:       r.name,
      POSITION:   r.position   || '',
      TEAM:       r.team       || '',
      DIVISION:   r.division   || '',
      DEPARTMENT: r.department || '',
    })),
  };
}

async function getOrg(env) {
  const row = await env.DB.prepare("SELECT value FROM config WHERE key = 'org_tree'").first();
  let data = [];
  if (row?.value) { try { data = JSON.parse(row.value); } catch {} }
  return { ok: true, data };
}

async function getSiteAssign(env) {
  const { results } = await env.DB.prepare(
    'SELECT site, name FROM site_assignments ORDER BY site, name'
  ).all();
  const out = {};
  for (const r of results) {
    if (!out[r.site]) out[r.site] = [];
    out[r.site].push(r.name);
  }
  return { ok: true, data: out };
}

async function getPulloutRules(env) {
  const { results } = await env.DB.prepare(
    'SELECT site, cycle, week, day, type FROM pullout_rules'
  ).all();
  return {
    ok: true,
    data: results.map(r => ({
      Site: r.site, CYCLE: r.cycle, WEEK: r.week, DAY: r.day, TYPE: r.type,
    })),
  };
}

async function loadSchedule(env, name) {
  if (!name) return { ok: false, error: 'name required' };
  const row = await env.DB.prepare(
    'SELECT data, team, position, last_saved FROM schedules WHERE name = ?'
  ).bind(name).first();
  if (!row) return { ok: true, data: {} };
  let data = {};
  try { data = JSON.parse(row.data); } catch {}
  data._meta = { team: row.team, position: row.position, name, lastSaved: row.last_saved };
  return { ok: true, data };
}

async function saveSchedule(env, name, payload) {
  if (!name || !payload) return { ok: false, error: 'name and data required' };
  const meta = payload._meta || {};
  const schedData = Object.fromEntries(
    Object.entries(payload).filter(([k]) => !k.startsWith('_'))
  );
  await env.DB.prepare(`
    INSERT INTO schedules (name, data, team, position, last_saved)
    VALUES (?, ?, ?, ?, ?)
    ON CONFLICT(name) DO UPDATE SET
      data       = excluded.data,
      team       = excluded.team,
      position   = excluded.position,
      last_saved = excluded.last_saved
  `).bind(
    name,
    JSON.stringify(schedData),
    meta.team       || '',
    meta.position   || '',
    meta.lastSaved  || new Date().toISOString(),
  ).run();
  return { ok: true };
}

/* ── admin writes (require ADMIN_TOKEN env secret) ── */

function checkToken(env, body) {
  if (!env.ADMIN_TOKEN) throw new Error('ADMIN_TOKEN not configured on worker');
  if (body.token !== env.ADMIN_TOKEN) throw new Error('Unauthorized');
}

async function adminSaveConfig(env, body) {
  checkToken(env, body);
  const { start_date, end_date, deadline_date, deadline_time, holidays } = body;
  const upsert = env.DB.prepare(
    "INSERT INTO config (key, value) VALUES (?, ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value"
  );
  const stmts = [
    upsert.bind('start_date',    start_date    || ''),
    upsert.bind('end_date',      end_date      || ''),
    upsert.bind('deadline_date', deadline_date || ''),
    upsert.bind('deadline_time', deadline_time || ''),
  ];
  if (Array.isArray(holidays)) {
    stmts.push(env.DB.prepare('DELETE FROM holidays'));
    for (const d of holidays) stmts.push(env.DB.prepare('INSERT INTO holidays (date) VALUES (?)').bind(d));
  }
  await env.DB.batch(stmts);
  return { ok: true };
}

async function adminSaveResponders(env, body) {
  checkToken(env, body);
  const rows = body.responders;
  if (!Array.isArray(rows)) return { ok: false, error: 'responders must be an array' };
  const stmts = [env.DB.prepare('DELETE FROM responders')];
  for (const r of rows) {
    stmts.push(env.DB.prepare(
      'INSERT INTO responders (name, position, team, division, department) VALUES (?, ?, ?, ?, ?)'
    ).bind(r.NAME || r.name, r.POSITION || '', r.TEAM || '', r.DIVISION || '', r.DEPARTMENT || ''));
  }
  await env.DB.batch(stmts);
  return { ok: true };
}

async function adminSaveOrg(env, body) {
  checkToken(env, body);
  const upsert = env.DB.prepare(
    "INSERT INTO config (key, value) VALUES ('org_tree', ?) ON CONFLICT(key) DO UPDATE SET value = excluded.value"
  );
  await upsert.bind(JSON.stringify(body.org || [])).run();
  return { ok: true };
}

async function adminSaveSiteAssign(env, body) {
  checkToken(env, body);
  const assign = body.site_assign;
  if (!assign || typeof assign !== 'object') return { ok: false, error: 'site_assign must be an object' };
  const stmts = [env.DB.prepare('DELETE FROM site_assignments')];
  for (const [site, names] of Object.entries(assign)) {
    for (const name of (names || [])) {
      stmts.push(env.DB.prepare(
        'INSERT INTO site_assignments (site, name) VALUES (?, ?)'
      ).bind(site, name));
    }
  }
  await env.DB.batch(stmts);
  return { ok: true };
}

async function adminSavePulloutRules(env, body) {
  checkToken(env, body);
  const rules = body.rules;
  if (!Array.isArray(rules)) return { ok: false, error: 'rules must be an array' };
  const stmts = [env.DB.prepare('DELETE FROM pullout_rules')];
  for (const r of rules) {
    stmts.push(env.DB.prepare(
      'INSERT INTO pullout_rules (site, cycle, week, day, type) VALUES (?, ?, ?, ?, ?)'
    ).bind(r.Site || r.site, r.CYCLE ?? r.cycle, r.WEEK ?? r.week, r.DAY ?? r.day, r.TYPE ?? r.type ?? 0));
  }
  await env.DB.batch(stmts);
  return { ok: true };
}
