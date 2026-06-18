PRAGMA foreign_keys = ON;

INSERT INTO users (full_name, email, password_hash, phone) VALUES
  ('Santiago Pizarro', 'santiago.pizarro@example.com', 'hash_demo_1', '+5491100000001'),
  ('Luciano Galeppi', 'luciano.galeppi@example.com', 'hash_demo_2', '+5491100000002'),
  ('Lucas Palavecino', 'lucas.palavecino@example.com', 'hash_demo_3', '+5491100000003');

INSERT INTO sports (name) VALUES
  ('Futbol'),
  ('Padel');

INSERT INTO venues (name, city, address) VALUES
  ('Grun FC', 'Buenos Aires', 'Av. Demo 123'),
  ('Babolat Padel Center', 'Buenos Aires', 'Calle Demo 456');

INSERT INTO courts (venue_id, sport_id, name, surface) VALUES
  (1, 1, 'Cancha 1', 'Cesped sintetico'),
  (2, 2, 'Cancha Padel 1', 'Sintetico');

INSERT INTO court_availability (court_id, weekday, open_time, close_time) VALUES
  (1, 3, '18:00', '19:00'),
  (1, 3, '19:00', '20:00'),
  (2, 3, '18:00', '19:00');

INSERT INTO time_slots (court_id, start_at, end_at, price_amount, status) VALUES
  (1, '2026-06-03 18:00:00', '2026-06-03 19:00:00', 25000, 'AVAILABLE'),
  (1, '2026-06-03 19:00:00', '2026-06-03 20:00:00', 28000, 'AVAILABLE'),
  (2, '2026-06-03 18:00:00', '2026-06-03 19:00:00', 18000, 'AVAILABLE');

SELECT
  ts.id AS slot_id,
  v.name AS venue,
  c.name AS court,
  s.name AS sport,
  ts.start_at,
  ts.end_at,
  ts.price_amount,
  ts.status
FROM time_slots ts
JOIN courts c ON c.id = ts.court_id
JOIN venues v ON v.id = c.venue_id
JOIN sports s ON s.id = c.sport_id
WHERE ts.status = 'AVAILABLE'
ORDER BY ts.start_at;

