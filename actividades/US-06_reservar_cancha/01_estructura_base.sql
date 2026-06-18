PRAGMA foreign_keys = OFF;

DROP TABLE IF EXISTS audit_events;
DROP TABLE IF EXISTS support_messages;
DROP TABLE IF EXISTS support_tickets;
DROP TABLE IF EXISTS password_reset_tokens;
DROP TABLE IF EXISTS user_sessions;
DROP TABLE IF EXISTS payments;
DROP TABLE IF EXISTS reservation_confirmations;
DROP TABLE IF EXISTS reservation_cancellations;
DROP TABLE IF EXISTS reservations;
DROP TABLE IF EXISTS time_slots;
DROP TABLE IF EXISTS court_availability;
DROP TABLE IF EXISTS courts;
DROP TABLE IF EXISTS venues;
DROP TABLE IF EXISTS sports;
DROP TABLE IF EXISTS users;
DROP TABLE IF EXISTS match_participants;
DROP TABLE IF EXISTS open_matches;

PRAGMA foreign_keys = ON;

CREATE TABLE users (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  full_name TEXT NOT NULL,
  email TEXT NOT NULL UNIQUE,
  password_hash TEXT NOT NULL,
  phone TEXT,
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'BLOCKED', 'DELETED')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  updated_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE sports (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL UNIQUE
);

CREATE TABLE venues (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  name TEXT NOT NULL,
  city TEXT NOT NULL,
  address TEXT,
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'INACTIVE'))
);

CREATE TABLE courts (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  venue_id INTEGER NOT NULL,
  sport_id INTEGER NOT NULL,
  name TEXT NOT NULL,
  surface TEXT,
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'MAINTENANCE', 'INACTIVE')),
  FOREIGN KEY (venue_id) REFERENCES venues(id),
  FOREIGN KEY (sport_id) REFERENCES sports(id),
  UNIQUE (venue_id, name)
);

CREATE TABLE court_availability (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  court_id INTEGER NOT NULL,
  weekday INTEGER NOT NULL CHECK (weekday BETWEEN 0 AND 6),
  open_time TEXT NOT NULL,
  close_time TEXT NOT NULL,
  FOREIGN KEY (court_id) REFERENCES courts(id),
  UNIQUE (court_id, weekday, open_time, close_time)
);

CREATE TABLE time_slots (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  court_id INTEGER NOT NULL,
  start_at TEXT NOT NULL,
  end_at TEXT NOT NULL,
  price_amount REAL NOT NULL CHECK (price_amount >= 0),
  status TEXT NOT NULL DEFAULT 'AVAILABLE'
    CHECK (status IN ('AVAILABLE', 'HELD', 'BOOKED', 'BLOCKED', 'CANCELLED')),
  FOREIGN KEY (court_id) REFERENCES courts(id),
  UNIQUE (court_id, start_at, end_at)
);

CREATE TABLE reservations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  court_id INTEGER NOT NULL,
  slot_id INTEGER NOT NULL,
  status TEXT NOT NULL DEFAULT 'PENDING'
    CHECK (status IN ('PENDING', 'CONFIRMED', 'CANCELLED', 'COMPLETED')),
  total_amount REAL NOT NULL CHECK (total_amount >= 0),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  cancelled_at TEXT,
  cancel_reason TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (court_id) REFERENCES courts(id),
  FOREIGN KEY (slot_id) REFERENCES time_slots(id)
);

CREATE UNIQUE INDEX ux_active_reservation_slot
ON reservations(slot_id)
WHERE status IN ('PENDING', 'CONFIRMED');

CREATE TABLE reservation_cancellations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reservation_id INTEGER NOT NULL UNIQUE,
  canceled_by_user_id INTEGER NOT NULL,
  reason TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reservation_id) REFERENCES reservations(id),
  FOREIGN KEY (canceled_by_user_id) REFERENCES users(id)
);

CREATE TABLE reservation_confirmations (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reservation_id INTEGER NOT NULL UNIQUE,
  channel TEXT NOT NULL CHECK (channel IN ('EMAIL', 'WHATSAPP', 'APP')),
  sent_to TEXT NOT NULL,
  sent_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reservation_id) REFERENCES reservations(id)
);

CREATE TABLE payments (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  reservation_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  amount REAL NOT NULL CHECK (amount >= 0),
  status TEXT NOT NULL CHECK (status IN ('PENDING', 'APPROVED', 'REJECTED', 'REFUNDED')),
  provider_transaction_id TEXT UNIQUE,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (reservation_id) REFERENCES reservations(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE user_sessions (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  started_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  ended_at TEXT,
  status TEXT NOT NULL DEFAULT 'ACTIVE'
    CHECK (status IN ('ACTIVE', 'CLOSED', 'EXPIRED')),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE password_reset_tokens (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  token TEXT NOT NULL UNIQUE,
  expires_at TEXT NOT NULL,
  used_at TEXT,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE support_tickets (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER NOT NULL,
  subject TEXT NOT NULL,
  status TEXT NOT NULL DEFAULT 'OPEN'
    CHECK (status IN ('OPEN', 'IN_PROGRESS', 'RESOLVED', 'CLOSED')),
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE support_messages (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  support_ticket_id INTEGER NOT NULL,
  user_id INTEGER NOT NULL,
  message TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (support_ticket_id) REFERENCES support_tickets(id),
  FOREIGN KEY (user_id) REFERENCES users(id)
);

CREATE TABLE audit_events (
  id INTEGER PRIMARY KEY AUTOINCREMENT,
  user_id INTEGER,
  reservation_id INTEGER,
  event_type TEXT NOT NULL,
  description TEXT NOT NULL,
  created_at TEXT NOT NULL DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (user_id) REFERENCES users(id),
  FOREIGN KEY (reservation_id) REFERENCES reservations(id)
);
