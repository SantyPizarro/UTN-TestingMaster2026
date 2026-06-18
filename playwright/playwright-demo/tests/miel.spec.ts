import { test, expect } from '@playwright/test';

test.describe('Portal MIeL - Pruebas de Login y Contenido', () => {

  test.beforeEach(async ({ page }) => {
    // Incrementar el tiempo de espera del test a 60 segundos por lentitud del entorno
    test.setTimeout(60000);
    // Ir a la página principal antes de cada test
    await page.goto('https://miel.unlam.edu.ar/');
  });

  test('CP-01 – Carga correcta de la página principal', async ({ page }) => {
    // Verifica el título del documento
    await expect(page).toHaveTitle('MIeL - Materias Interactivas en Línea');

    // Verifica el heading principal
    const heading = page.locator('h1.title');
    await expect(heading).toBeVisible();
    await expect(heading).toContainText('Materias Interactivas');
    await expect(heading).toContainText('en Línea');

    // Verifica el formulario de login y sus campos críticos
    const formLogin = page.locator('form#formLogin');
    await expect(formLogin).toBeVisible();

    const usuarioInput = page.locator('input#usuario');
    await expect(usuarioInput).toBeVisible();
    await expect(usuarioInput).toBeEditable();

    const claveInput = page.locator('input#clave');
    await expect(claveInput).toBeVisible();
    await expect(claveInput).toBeEditable();

    const loginButton = page.locator('button#btnLogin');
    await expect(loginButton).toBeVisible();
    await expect(loginButton).toContainText('Ingresar');
  });

  test('CP-02 – Login con campos vacíos', async ({ page }) => {
    // Asegurarse de que el usuario y la clave estén vacíos
    await page.locator('input#usuario').fill('');
    await page.locator('input#clave').fill('');

    // Hacer click en "Ingresar"
    await page.locator('button#btnLogin').click();

    // Comprobar que el sistema no navega ni autentica:
    // 1. La URL sigue siendo la página principal
    expect(page.url()).toBe('https://miel.unlam.edu.ar/');

    // 2. El formulario sigue visible y en pantalla
    await expect(page.locator('form#formLogin')).toBeVisible();
  });

  test('CP-03 – Login con credenciales incorrectas', async ({ page }) => {
    // Completar el formulario con datos falsos
    await page.locator('input#usuario').fill('usuario_falso_12345');
    await page.locator('input#clave').fill('clave_falsa_12345');

    // Hacer click en "Ingresar"
    await page.locator('button#btnLogin').click();

    // Verificación de robustez:
    // 1. El formulario de login sigue visible
    await expect(page.locator('form#formLogin')).toBeVisible();

    // 2. Esperamos y verificamos que aparezca el mensaje de error correspondiente
    const errorMsg = page.locator('div#mensajeErrorLogin');
    await expect(errorMsg).toBeVisible();
    await expect(errorMsg).toContainText('Usuario o contraseña incorrectos.');

    // 3. Confirmamos que la URL no haya cambiado a la sección privada
    expect(page.url()).not.toContain('principal/interno/');
  });

  test('CP-04 – Flujo "Olvidé mi contraseña"', async ({ page }) => {
    // Hacer click en el link de recuperación
    await page.locator('a#btnOlvideClave').click();

    // Verificar que aparezca la sección/modal correspondiente
    const recoveryCard = page.locator('#card-content-aviso-recuperar-clave');
    await expect(recoveryCard).toBeVisible();

    // Heading del modal/sección
    const heading = recoveryCard.locator('h2.subtitle');
    await expect(heading).toBeVisible();
    await expect(heading).toContainText('Olvidé mi contraseña');

    // Mención a Intraconsulta (para alumnos regulares)
    const intraconsultaLink = recoveryCard.locator('a[href*="alumno2.unlam.edu.ar"]');
    await expect(intraconsultaLink).toBeVisible();
    await expect(intraconsultaLink).toContainText('Intraconsulta');
    await expect(recoveryCard).toContainText('Intraconsulta');

    // Botón "Continuar"
    const continueButton = recoveryCard.locator('button.btnContinuar');
    await expect(continueButton).toBeVisible();
    await expect(continueButton).toContainText('Continuar');
  });

  test('CP-05 – Sección de Preguntas Frecuentes', async ({ page }) => {
    // Verificar que el contenedor de faqs esté presente
    const faqsSection = page.locator('#faqs');
    await expect(faqsSection).toBeVisible();

    // Comprobar 3 preguntas puntuales por su texto
    const q1 = faqsSection.locator('summary', { hasText: '¿Qué es la Educación a Distancia?' });
    await expect(q1).toBeVisible();

    const q2 = faqsSection.locator('summary', { hasText: '¿Qué es MIeL?' });
    await expect(q2).toBeVisible();

    const q3 = faqsSection.locator('summary', { hasText: '¿Cómo accedo a MIeL?' });
    await expect(q3).toBeVisible();
  });

});
