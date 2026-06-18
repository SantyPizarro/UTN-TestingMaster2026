import { test, expect } from '@playwright/test';

const getEnvVar = (key: string): string => {
  const value = process.env[key];
  if (!value) {
    throw new Error(`Missing environment variable: ${key}`);
  }
  return value;
};

const usuario = getEnvVar('usuario');
const contraseña = getEnvVar('contrasenia');

test.describe('Portal MIeL - Pruebas de Usuario Logueado', () => {

  test.beforeEach(async ({ page }) => {
    test.setTimeout(60000);

    await page.goto('https://miel.unlam.edu.ar/');

    await page.locator('input#usuario').fill(usuario);
    await page.locator('input#clave').fill(contraseña);

    await page.locator('button#btnLogin').click();

    await page.waitForURL('**/principal/interno/**', { timeout: 30000 });
  });

  test('CP-06 – Información del perfil del usuario', async ({ page }) => {
    // 1. Verificar que el nombre completo del usuario es visible en el panel principal
    const body = page.locator('body');
    await expect(body).toContainText('PIZARRO, SANTIAGO NAHUEL');

    // 2. Verificar que existe el enlace de perfil apuntando a /perfil/datos/
    const profileLink = page.locator('a[href*="/perfil/datos/"]').first();
    await expect(profileLink).toBeVisible();
  });

  test('CP-07 – Navegación a la configuración del perfil', async ({ page }) => {
    // Hacer clic en el enlace de perfil
    await page.locator('a[href*="/perfil/datos/"]').first().click();

    // Verificar la redirección a la página de datos de perfil
    await page.waitForURL('**/perfil/datos/**');
    expect(page.url()).toContain('/perfil/datos/');

    // Verificar la visibilidad del formulario en la página de perfil
    await expect(page.locator('form')).toBeVisible();
  });

  test('CP-08 – Navegación a Contenidos de una materia activa', async ({ page }) => {
    // Localizar y hacer clic en el link de Contenidos para la materia "Ingeniería en Software" (Comisión 116500)
    const contenidosLink = page.locator('a[href*="/contenido/archivos/comision/116500"]').first();
    await expect(contenidosLink).toBeVisible();
    await contenidosLink.click();

    // Verificar la redirección exitosa
    await page.waitForURL('**/contenido/archivos/comision/116500**');
    expect(page.url()).toContain('/contenido/archivos/comision/116500');

    // Confirmar que cargó el contenido del curso mostrando el nombre de la materia
    await expect(page.locator('body')).toContainText('Ingeniería en Software');
  });

  test('CP-09 – Alternar el tema a Modo Oscuro', async ({ page }) => {
    // Localizar el toggle de Modo Oscuro en la barra superior utilizando la clase botonCambiarTema
    const toggleLink = page.locator('a.botonCambiarTema');
    await expect(toggleLink).toBeVisible();

    // Hacer clic en el alternador de tema
    await toggleLink.click();

    // Esperar un segundo para la transición visual del tema
    await page.waitForTimeout(1000);
  });

  test('CP-10 – Navegación a la sección de Calendario', async ({ page }) => {
    // Localizar y hacer clic en el enlace de "Calendario" en el menú lateral
    const calendarioLink = page.locator('a[href*="/calendario/calendario/"]').first();
    await expect(calendarioLink).toBeVisible();
    await calendarioLink.click();

    // Verificar la redirección a la sección de calendario de cursada
    await page.waitForURL('**/calendario/calendario/**');
    expect(page.url()).toContain('/calendario/calendario/');
  });

});
