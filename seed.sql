-- GDS Schedule Tracker — Seed Data (updated 2026-06-15)
-- Run AFTER schema.sql:
-- wrangler d1 execute gds-schedule-tracker --remote --file=seed.sql

-- ── Config ───────────────────────────────────────────────────────────────────
INSERT INTO config (key, value) VALUES
  ('start_date',    '2026-07-01'),
  ('end_date',      '2026-09-30'),
  ('deadline_date', '2026-06-19'),
  ('deadline_time', 'GMT+8 1830')
ON CONFLICT(key) DO UPDATE SET value = excluded.value;

-- ── Holidays ─────────────────────────────────────────────────────────────────
DELETE FROM holidays;
INSERT INTO holidays (date) VALUES
  ('2025-10-31'), ('2025-11-01'), ('2025-12-08'), ('2025-12-24'),
  ('2025-12-25'), ('2025-12-30'), ('2025-12-31'), ('2026-01-01'),
  ('2026-02-17'), ('2026-04-02'), ('2026-04-03'), ('2026-04-04'),
  ('2026-04-09'), ('2026-05-01'), ('2026-06-12'), ('2026-08-21'),
  ('2026-08-31'), ('2026-11-01'), ('2026-11-02'), ('2026-11-30'),
  ('2026-12-08'), ('2026-12-24'), ('2026-12-25'), ('2026-12-30'),
  ('2026-12-31');

-- ── Responders ───────────────────────────────────────────────────────────────
DELETE FROM responders;
INSERT INTO responders (name, position, team, division, department) VALUES
  ('Barcena, Blincent Addam',    'MANAGER',                              '',    'MDM', 'GDS'),
  ('Bongalbal, Ronnel',          'DEPUTY MANAGER',                       '',    'MDM', 'GDS'),
  ('Calma, Voughn Emil',         'SENIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('De Jesus, Edgar Chevy',      'SENIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Encarnado, Gerik Ivan',      'SENIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('See, Eliza Kathleen',        'SENIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Wenceslao, Roesel',          'SENIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Cinco, Creesialyn Anne',     'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Cobsilen, Clifford Jr.',     'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Cuevas, Erick Paul',         'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('De Guzman, Kyle Ashley Rae', 'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Etable, Joseph',             'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Gerodias, Alrey John',       'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Kawi, Philip',               'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Lafuente, RJ',               'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Lariba, Keith Jones Paul',   'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Laserna, Kernell',           'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Mendoza, Carlo',             'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Ordoño, Abigail Jafet',      'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Postrado, Jay',              'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Viernes, Joseph',            'JUNIOR GIS SPECIALIST',                'GDM', 'MDM', 'GDS'),
  ('Sana, Abegail',              'LEAD SENIOR LAND TECHNICAL SPECIALIST', 'LTS', 'MDM', 'GDS'),
  ('Cutamora, Marc Justin',      'LEAD SENIOR LAND TECHNICAL SPECIALIST', 'LTS', 'MDM', 'GDS'),
  ('Dancel, Angelic',            'SENIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Rollo, Mark Gil',            'SENIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Tumbaga, Nicole Louisse',    'SENIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Casilla, Regine',            'JUNIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Dacayanan, Jessa Mae',       'JUNIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Datul, Pel-Jay',             'JUNIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Felipe, Roberto Jr.',        'JUNIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Galinato, Leonard Gelo',     'JUNIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Pacada, Roniel',             'JUNIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Reboroso, Sunrise',          'JUNIOR LAND TECHNICAL SPECIALIST',     'LTS', 'MDM', 'GDS'),
  ('Zapanta, Andrew',            'SENIOR GIS OPERATOR',                  'GDP', 'MDM', 'GDS'),
  ('Concepcion, Jamaica',        'JUNIOR GIS OPERATOR',                  'GDP', 'MDM', 'GDS'),
  ('Cruz, Vjan Michael',         'JUNIOR GIS OPERATOR',                  'GDP', 'MDM', 'GDS'),
  ('Llegue, Michelle',           'JUNIOR GIS OPERATOR',                  'GDP', 'MDM', 'GDS'),
  ('Mendoza, Anthony',           'JUNIOR GIS OPERATOR',                  'GDP', 'MDM', 'GDS'),
  ('Salcedo, Francis',           'JUNIOR GIS OPERATOR',                  'GDP', 'MDM', 'GDS');

-- ── Organization tree ─────────────────────────────────────────────────────────
INSERT INTO config (key, value) VALUES ('org_tree', '[{"NAME":"Barcena, Blincent Addam","POSITION":"MANAGER","TEAM":[{"NAME":"Bongalbal, Ronnel","POSITION":"DEPUTY MANAGER"},{"NAME":"Calma, Voughn Emil","POSITION":"SENIOR GIS SPECIALIST"},{"NAME":"De Jesus, Edgar Chevy","POSITION":"SENIOR GIS SPECIALIST"},{"NAME":"Encarnado, Gerik Ivan","POSITION":"SENIOR GIS SPECIALIST"},{"NAME":"See, Eliza Kathleen","POSITION":"SENIOR GIS SPECIALIST"},{"NAME":"Wenceslao, Roesel","POSITION":"SENIOR GIS SPECIALIST"},{"NAME":"Zapanta, Andrew","POSITION":"SENIOR GIS OPERATOR"},{"NAME":"Sana, Abegail","POSITION":"LEAD SENIOR LAND TECHNICAL SPECIALIST"},{"NAME":"Cutamora, Marc Justin","POSITION":"LEAD SENIOR LAND TECHNICAL SPECIALIST"}]},{"NAME":"Bongalbal, Ronnel","POSITION":"DEPUTY MANAGER","TEAM":[{"NAME":"Cinco, Creesialyn Anne","POSITION":"JUNIOR GIS SPECIALIST"},{"NAME":"De Guzman, Kyle Ashley Rae","POSITION":"JUNIOR GIS SPECIALIST"}]},{"NAME":"Calma, Voughn Emil","POSITION":"SENIOR GIS SPECIALIST","TEAM":[{"NAME":"Cuevas, Erick Paul","POSITION":"JUNIOR GIS SPECIALIST"},{"NAME":"Etable, Joseph","POSITION":"JUNIOR GIS SPECIALIST"}]},{"NAME":"De Jesus, Edgar Chevy","POSITION":"SENIOR GIS SPECIALIST","TEAM":[{"NAME":"Cobsilen, Clifford Jr.","POSITION":"JUNIOR GIS SPECIALIST"},{"NAME":"Gerodias, Alrey John","POSITION":"JUNIOR GIS SPECIALIST"},{"NAME":"Viernes, Joseph","POSITION":"JUNIOR GIS SPECIALIST"}]},{"NAME":"Encarnado, Gerik Ivan","POSITION":"SENIOR GIS SPECIALIST","TEAM":[]},{"NAME":"See, Eliza Kathleen","POSITION":"SENIOR GIS SPECIALIST","TEAM":[{"NAME":"Lafuente, RJ","POSITION":"JUNIOR GIS SPECIALIST"},{"NAME":"Postrado, Jay","POSITION":"JUNIOR GIS SPECIALIST"},{"NAME":"Lariba, Keith Jones Paul","POSITION":"JUNIOR GIS SPECIALIST"},{"NAME":"Kawi, Philip","POSITION":"JUNIOR GIS SPECIALIST"}]},{"NAME":"Wenceslao, Roesel","POSITION":"SENIOR GIS SPECIALIST","TEAM":[{"NAME":"Laserna, Kernell","POSITION":"JUNIOR GIS SPECIALIST"},{"NAME":"Mendoza, Carlo","POSITION":"JUNIOR GIS SPECIALIST"},{"NAME":"Ordoño, Abigail Jafet","POSITION":"JUNIOR GIS SPECIALIST"}]},{"NAME":"Zapanta, Andrew","POSITION":"SENIOR GIS OPERATOR","TEAM":[{"NAME":"Cruz, Vjan Michael","POSITION":"JUNIOR GIS OPERATOR"},{"NAME":"Concepcion, Jamaica","POSITION":"JUNIOR GIS OPERATOR"},{"NAME":"Llegue, Michelle","POSITION":"JUNIOR GIS OPERATOR"},{"NAME":"Mendoza, Anthony","POSITION":"JUNIOR GIS OPERATOR"},{"NAME":"Salcedo, Francis","POSITION":"JUNIOR GIS OPERATOR"}]},{"NAME":"Sana, Abegail","POSITION":"LEAD SENIOR LAND TECHNICAL SPECIALIST","TEAM":[{"NAME":"Dancel, Angelic","POSITION":"SENIOR LAND TECHNICAL SPECIALIST"},{"NAME":"Casilla, Regine","POSITION":"JUNIOR LAND TECHNICAL SPECIALIST"},{"NAME":"Reboroso, Sunrise","POSITION":"JUNIOR LAND TECHNICAL SPECIALIST"},{"NAME":"Dacayanan, Jessa Mae","POSITION":"JUNIOR LAND TECHNICAL SPECIALIST"},{"NAME":"Tumbaga, Nicole Louisse","POSITION":"SENIOR LAND TECHNICAL SPECIALIST"}]},{"NAME":"Cutamora, Marc Justin","POSITION":"LEAD SENIOR LAND TECHNICAL SPECIALIST","TEAM":[{"NAME":"Datul, Pel-Jay","POSITION":"JUNIOR LAND TECHNICAL SPECIALIST"},{"NAME":"Felipe, Roberto Jr.","POSITION":"JUNIOR LAND TECHNICAL SPECIALIST"},{"NAME":"Rollo, Mark Gil","POSITION":"SENIOR LAND TECHNICAL SPECIALIST"},{"NAME":"Galinato, Leonard Gelo","POSITION":"JUNIOR LAND TECHNICAL SPECIALIST"},{"NAME":"Pacada, Roniel","POSITION":"JUNIOR LAND TECHNICAL SPECIALIST"}]}]')
ON CONFLICT(key) DO UPDATE SET value = excluded.value;

-- ── Site Assignments ──────────────────────────────────────────────────────────
DELETE FROM site_assignments;
INSERT INTO site_assignments (site, name) VALUES
  ('GDS HQ MAKATI 1', 'Daluping, Aizely'),
  ('GDS HQ MAKATI 1', 'Bongalbal, Ronnel'),
  ('GDS HQ MAKATI 1', 'Encarnado, Gerik Ivan'),
  ('GDS HQ MAKATI 1', 'Wenceslao, Roesel'),
  ('GDS HQ MAKATI 1', 'Cruz, Vjan Michael'),
  ('GDS HQ MAKATI 1', 'Llegue, Michelle'),
  ('GDS HQ MAKATI 1', 'De Jesus, Edgar Chevy'),
  ('GDS HQ MAKATI 1', 'Salcedo, Francis'),
  ('GDS HQ MAKATI 2', 'Barcena, Blincent Addam'),
  ('GDS HQ MAKATI 2', 'Calma, Voughn Emil'),
  ('GDS HQ MAKATI 2', 'See, Eliza Kathleen'),
  ('GDS HQ MAKATI 2', 'Zapanta, Andrew'),
  ('GDS HQ MAKATI 2', 'Concepcion, Jamaica'),
  ('GDS HQ MAKATI 2', 'Mendoza, Anthony'),
  ('GDS Nasugbu DC',  'Laserna, Kernell'),
  ('GDS Nasugbu DC',  'Mendoza, Carlo'),
  ('GDS Nasugbu DC',  'Ordoño, Abigail Jafet'),
  ('GDS Tuy DC',      'Cutamora, Marc Justin'),
  ('GDS Tuy DC',      'Galinato, Leonard Gelo'),
  ('GDS Tuy DC',      'Datul, Pel-Jay'),
  ('GDS Tuy DC',      'Felipe, Roberto Jr.'),
  ('GDS Tuy DC',      'Rollo, Mark Gil'),
  ('GDS Tuy DC',      'Pacada, Roniel'),
  ('GDS Tarlac DC',   'Sana, Abegail'),
  ('GDS Tarlac DC',   'Cobsilen, Clifford Jr.'),
  ('GDS Tarlac DC',   'Dacayanan, Jessa Mae'),
  ('GDS Tarlac DC',   'Dancel, Angelic'),
  ('GDS Tarlac DC',   'Casilla, Regine'),
  ('GDS Tarlac DC',   'Reboroso, Sunrise'),
  ('GDS Tarlac DC',   'Tumbaga, Nicole Louisse'),
  ('GDS Tarlac DC',   'Gerodias, Alrey John'),
  ('GDS Tarlac DC',   'Kawi, Philip'),
  ('GDS Tarlac DC',   'Viernes, Joseph'),
  ('GDS Tayabas DC',  'Postrado, Jay'),
  ('GDS Tayabas DC',  'Lariba, Keith Jones Paul'),
  ('GDS Tayabas DC',  'Lafuente, RJ'),
  ('MDM Alaminos',    'Cinco, Creesialyn Anne'),
  ('MDM Alaminos',    'De Guzman, Kyle Ashley Rae'),
  ('MDM Zambales',    'Etable, Joseph'),
  ('MDM Zambales',    'Cuevas, Erick Paul');

-- ── Pullout / Deployment Rules ────────────────────────────────────────────────
DELETE FROM pullout_rules;
INSERT INTO pullout_rules (site, cycle, week, day, type) VALUES
  ('GDS HQ MAKATI 1',      1, 2, 2, 1),
  ('GDS HQ MAKATI 2',      1, 2, 1, 1),
  ('GDS Antipolo Basemap', 2, 2, 0, 2),
  ('Makati Head Office',   1, 2, 2, 1),
  ('MDM Alaminos',         2, 2, 2, 2),
  ('GDS Tarlac DC',        2, 2, 2, 2),
  ('GDS San Miguel DC',    2, 2, 1, 2),
  ('GDS Tuy DC',           2, 2, 1, 2),
  ('GDS Nasugbu DC',       2, 2, 1, 2),
  ('GDS Tayabas DC',       2, 2, 2, 2),
  ('GDS Pili DC',          3, 2, 0, 2),
  ('MDM Zambales',         2, 2, 2, 2),
  ('MDM Ormoc',            2, 2, 0, 2);
