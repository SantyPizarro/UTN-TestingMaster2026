-- US-02 - Inicio de sesion
-- Caso: TC-US2-02 - Contrasena incorrecta.
-- Prueba negativa de integridad mediante trigger.

PRAGMA foreign_keys = ON;

-- El correo existe, pero el hash de la contrasena no coincide.
-- El backend intenta aprobar el acceso y el trigger lo rechaza.
INSERT INTO login_attempts (
  submitted_email,
  submitted_password_hash,
  result,
  message
) VALUES (
  'santiago.pizarro@example.com',
  'hash_contrasena_incorrecta',
  'SUCCESS',
  'Inicio de sesion exitoso'
);

-- Resultado esperado:
-- Credenciales incorrectas
-- No se crea ningun intento exitoso ni una nueva sesion.
--
-- El mismo mensaje generico se obtiene con un correo inexistente,
-- por lo que no se revela cual de las dos credenciales fue incorrecta.
