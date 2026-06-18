# UTN-TestingMaster2026

Este repositorio contiene las actividades, proyectos prácticos y pruebas realizadas en el marco del curso **Testing Master** de la **UTN (Universidad Tecnológica Nacional)**.

---

## 📁 Estructura del Repositorio

El contenido del repositorio se divide en dos grandes áreas: **Actividades** de testing (manual, base de datos y gestión) y **Playwright** (automatización de pruebas de interfaz de usuario).

### 1. [actividades](./actividades)
Contiene las tareas de diseño, reporte y ejecución de pruebas tanto funcionales como a nivel de Base de Datos.

*   **[Actividad individual](./actividades/Actividad%20individual):** 
    *   Documentación y diagramas de flujo/reporte de bugs (formatos `.drawio` y capturas de pantalla).
    *   Ejemplos analizados: *Rate limiting* en formularios, descarga de PDFs instructivos en el INPI, visualización móvil de la Home de INPI y resultados de TAD en móviles.
    *   Planilla Excel ([Reporte bugs.xlsx](./actividades/Actividad%20individual/Reporte%20bugs.xlsx)) con el registro formal de defectos detectados.
*   **[Jira](./actividades/Jira):**
    *   Gestión del ciclo de vida de pruebas y bugs mediante Jira.
    *   Contiene una planilla Excel con casos de prueba ([Casos de prueba - Grupo 7.xlsx](./actividades/Jira/Casos%20de%20prueba%20-%20Grupo%207.xlsx)) y capturas que demuestran el uso del tablero Kanban de Jira.
*   **Pruebas de Base de Datos (SQL - SQLite):**
    Simulaciones de comportamiento de backend mediante triggers y scripts DDL/DML para validar reglas de negocio.
    *   **[US-02 Inicio de Sesión](./actividades/US-02_inicio_sesion):** Pruebas de credenciales correctas/incorrectas y restricciones de cuenta.
    *   **[US-06 Reservar Cancha](./actividades/US-06_reservar_cancha):** Pruebas de flujo exitoso de reserva y fallos de integridad por disponibilidad/reglas.
    *   **[US-23 Crear Cancha](./actividades/US-23_crear_cancha):** Validación de campos obligatorios e inserción correcta de nuevas instalaciones deportivas.

---

### 2. [playwright](./playwright)
Contiene la automatización de pruebas de interfaz de usuario utilizando el framework **Playwright**.

*   **[playwright-demo](./playwright/playwright-demo):** Un proyecto configurado en TypeScript para realizar pruebas E2E sobre el portal educativo **MIeL** (*Materias Interactivas en Línea*) de la UNLaM.
    *   **[miel.spec.ts](./playwright/playwright-demo/tests/miel.spec.ts):** Casos de prueba sin loguearse (Carga de página principal, login con campos vacíos, credenciales incorrectas, flujo de recuperación de clave y sección de FAQs).
    *   **[miel-logged-in.spec.ts](./playwright/playwright-demo/tests/miel-logged-in.spec.ts):** Casos de prueba que requieren autenticación utilizando variables de entorno (Verificación del perfil de usuario, navegación a configuración de perfil, visualización de contenidos de una materia como "Ingeniería en Software", cambio a Modo Oscuro y navegación al calendario académico).
