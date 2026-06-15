-- GDS Schedule Tracker — D1 Schema
-- Run: wrangler d1 execute gds-schedule-tracker --remote --file=schema.sql

CREATE TABLE IF NOT EXISTS config (
  key   TEXT PRIMARY KEY,
  value TEXT NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS holidays (
  date TEXT PRIMARY KEY  -- YYYY-MM-DD
);

CREATE TABLE IF NOT EXISTS responders (
  name       TEXT PRIMARY KEY,
  position   TEXT NOT NULL DEFAULT '',
  team       TEXT NOT NULL DEFAULT '',
  division   TEXT NOT NULL DEFAULT '',
  department TEXT NOT NULL DEFAULT ''
);

CREATE TABLE IF NOT EXISTS site_assignments (
  site TEXT NOT NULL,
  name TEXT NOT NULL,
  PRIMARY KEY (site, name)
);

CREATE TABLE IF NOT EXISTS pullout_rules (
  site  TEXT PRIMARY KEY,
  cycle INTEGER NOT NULL,
  week  INTEGER NOT NULL,
  day   INTEGER NOT NULL,
  type  INTEGER NOT NULL DEFAULT 0
);

CREATE TABLE IF NOT EXISTS schedules (
  name       TEXT PRIMARY KEY,
  data       TEXT NOT NULL DEFAULT '{}',
  team       TEXT NOT NULL DEFAULT '',
  position   TEXT NOT NULL DEFAULT '',
  last_saved TEXT NOT NULL DEFAULT ''
);
