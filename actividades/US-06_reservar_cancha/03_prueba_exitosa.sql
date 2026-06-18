PRAGMA foreign_keys = ON;

INSERT INTO reservations (user_id, court_id, slot_id, status, total_amount)
SELECT
  1,
  ts.court_id,
  ts.id,
  'CONFIRMED',
  ts.price_amount
FROM time_slots ts
WHERE ts.id = 1
  AND ts.status = 'AVAILABLE';

UPDATE time_slots
SET status = 'BOOKED'
WHERE id = 1
  AND status = 'AVAILABLE';

INSERT INTO reservation_confirmations (reservation_id, channel, sent_to)
VALUES (1, 'EMAIL', 'santiago.pizarro@example.com');

INSERT INTO audit_events (user_id, reservation_id, event_type, description)
VALUES (1, 1, 'RESERVATION_CREATED', 'Reserva creada correctamente desde el flujo de usuario.');

SELECT
  r.id AS reservation_id,
  u.full_name AS user_name,
  v.name AS venue,
  c.name AS court,
  ts.start_at,
  ts.end_at,
  r.status AS reservation_status,
  ts.status AS slot_status,
  r.total_amount
FROM reservations r
JOIN users u ON u.id = r.user_id
JOIN courts c ON c.id = r.court_id
JOIN venues v ON v.id = c.venue_id
JOIN time_slots ts ON ts.id = r.slot_id
WHERE r.id = 1;

SELECT
  rc.reservation_id,
  rc.channel,
  rc.sent_to,
  rc.sent_at
FROM reservation_confirmations rc
WHERE rc.reservation_id = 1;

