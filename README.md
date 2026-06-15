# GDS Schedule Tracker

A single-page web app for tracking team work schedules and leave records. Personnel view lets each member log their daily schedule; dashboard view lets supervisors see the full team at a glance.

---

## File Structure

```
├── index.html              # Entire app (HTML + JS, no build step)
├── config.json             # Date range, deadline, and holidays
├── Responders.json         # Personnel list (name, position, team)
├── organization.json       # Org hierarchy (supervisor → team tree)
├── site assignment.json    # Maps each site name to a list of people
├── pullout-deployment.json # Pullout/deployment cycle rules per site
└── schedules/              # One JSON file per person, saved by the Worker
```

---

## config.json

Controls the scheduling window and save deadline.

```json
{
  "START_DATE":    "2026-04-01",
  "END_DATE":      "2026-06-30",
  "DEADLINE DATE": "2026-04-01",
  "DEADLINE TIME": "GMT+8 1300",
  "HOLIDAYS": ["2026-04-02", "2026-04-09"]
}
```

| Field | Description |
|---|---|
| `START_DATE` / `END_DATE` | ISO date strings (`YYYY-MM-DD`). Bounds the calendar and fill-defaults logic. |
| `DEADLINE DATE` | ISO date string. After this date the Save button is locked. |
| `DEADLINE TIME` | Format: `GMT+8 HHMM` (or `GMT-5 HHMM`, etc.). Combined with the date to build the exact cutoff in UTC. |
| `HOLIDAYS` | Array of `YYYY-MM-DD` strings. Those days are auto-filled as `HOL` and are not selectable. |

---

## Responders.json

Flat array of all personnel. Drives the Team / Position / Name dropdowns.

```json
[
  { "POSITION": "SENIOR GIS SPECIALIST", "TEAM": "GDM", "NAME": "Dela Cruz, Juan" }
]
```

Names must be in **`Last, First`** format (matches `site assignment.json`).

---

## organization.json

Nested tree used by the dashboard supervisor filter and the "full-team leave" warning.

```json
[
  {
    "NAME": "Supervisor Name",
    "TEAM": [
      { "NAME": "Member A", "TEAM": [] },
      { "NAME": "Member B", "TEAM": [] }
    ]
  }
]
```

---

## site assignment.json

Maps each deployment site to the people assigned there. Names must match `Responders.json` exactly (case-insensitive lookup, `Last, First` format).

```json
{
  "GDS Tarlac DC": ["Dela Cruz, Juan", "Reyes, Maria"],
  "GDS Nasugbu DC": []
}
```

A person not listed in any site will have no deployment/pullout markers shown on their calendar.

---

## pullout-deployment.json

Controls when the app draws **DEPLOYMENT**, **PULLOUT**, and **SCHED WFH** markers on each person's calendar.

```json
[
  { "Site": "GDS Tarlac DC",        "CYCLE": 2, "WEEK": 2, "DAY": 2, "TYPE": 2 },
  { "Site": "GDS HQ MAKATI 1",     "CYCLE": 1, "WEEK": 2, "DAY": 2, "TYPE": 1 },
  { "Site": "GDS Antipolo Basemap", "CYCLE": 2, "WEEK": 2, "DAY": 0, "TYPE": 2 }
]
```

### Fields

| Field | Type | Description |
|---|---|---|
| `Site` | string | Must match a key in `site assignment.json` exactly (case-insensitive). |
| `CYCLE` | 1 / 2 / 3 / 4 | Rotation length in weeks (see below). |
| `WEEK` | integer ≥ 1 | Which week within a cycle the **active span starts**. Used to offset the baseline Monday. |
| `DAY` | 0 / 1 / 2 | Shift of the deploy/pullout anchor within the span (see per-cycle notes). |
| `TYPE` | 0 / 1 / 2 | What markers to draw (see below). |

---

### CYCLE — rotation length

The baseline is the **first Monday of the START_DATE year**, shifted forward by `(WEEK - 1)` weeks. Cycles then repeat from that anchor.

| CYCLE | Active span | Full period | Meaning |
|---|---|---|---|
| `1` | 7 days | 7 days | Weekly rotation (1 week on-site, no off week) |
| `2` | 14 days | 14 days | Bi-weekly rotation (2 weeks on-site, no off week) |
| `3` | 21 days | 28 days | 3 weeks on-site / 1 week WFH |
| `4` | 84 days | 91 days | 12 weeks on-site / 1 week WFH |

---

### DAY — anchor within the active span

Shifts when inside the span the deployment and pullout fall.

| DAY | DEPLOYMENT lands on | PULLOUT lands on |
|---|---|---|
| `0` | 1st working day of span | Last working day of span |
| `1` | 1st working day of span | 2nd-to-last working day of span |
| `2` | 2nd working day of span | Last working day of span |

> **CYCLE 3** always uses the 1st working day (deploy) and the 3rd Friday (pullout) regardless of `DAY`.

---

### TYPE — which markers are drawn

| TYPE | DEPLOYMENT / PULLOUT markers | SCHED WFH band (days between pullout and next deployment) |
|---|---|---|
| `0` (or omit) | ✅ drawn | ❌ not drawn |
| `1` | ❌ not drawn | ✅ drawn (holiday-aware: anchors snap to nearest working day) |
| `2` | ✅ drawn | ✅ drawn |

**TYPE 1 detail:** the WFH band runs from the day after the effective pullout to the day before the next effective deployment. If either anchor falls on a holiday, it is shifted to the nearest working day before drawing the band edges.

**TYPE 2 detail:** same band logic but anchors are not shifted for holidays.

---

### How the calendar markers work end-to-end

1. When a person is selected, the app looks up their name in `site assignment.json` to find their site.
2. It then finds that site's rule in `pullout-deployment.json`.
3. Starting from the computed baseline Monday, it generates repeating blocks (deploy date + pullout date) across a ±16-week window around the current calendar view.
4. Dates that fall within `START_DATE`–`END_DATE` are stamped:
   - **DEPLOYMENT** — the day they leave for the site.
   - **PULLOUT** — the day they return.
   - **SCHED WFH** — working days in the WFH band between cycles (TYPE 1 or 2 only).

---

## Schedule codes

| Code | Label | Meaning |
|---|---|---|
| `ONS` | ONS | On-Site (default weekday) |
| `OFC` | OFC | Office |
| `WFH` | WFH | Work From Home |
| `VL`  | VL  | Vacation Leave |
| `AA`  | AA  | Authorized Absent |
| `PTO` | PTO | Paid Time Off |
| `BDL` | BDL | Birthday Leave |
| `ML`  | ML  | Maternity Leave |
| `PL`  | PL  | Paternity Leave |
| `RD`  | RD  | Rest Day (auto, weekends) |
| `HOL` | HOL | Holiday (auto) |

---

## Dashboard access

Only these positions can open the dashboard:

- Manager
- Deputy Manager
- Lead Senior Land Technical Specialist
- Senior GIS Specialist
- Senior GIS Operator

Select your name first; the calendar icon in the header activates when eligible.

---

## Adding a new site / rotation

1. Add the site name and its members to **`site assignment.json`**.
2. Add a rule row to **`pullout-deployment.json`** with the correct `CYCLE`, `WEEK`, `DAY`, and `TYPE`.
3. Make sure the site name matches between both files (comparison is case-insensitive).
4. No code changes required — the app reads these files on load.

## Adding a new person

1. Add their entry to **`Responders.json`** (`POSITION`, `TEAM`, `NAME`).
2. Add their name to the appropriate site in **`site assignment.json`** if they have a deployment rotation.
3. Optionally add them to **`organization.json`** under their supervisor's `TEAM` array.
