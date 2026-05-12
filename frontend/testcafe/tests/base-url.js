/**
 * Centralised base URL for all TestCafe tests.
 *
 * Override via environment variables:
 *   HOST      – hostname (default: localhost)
 *   APP_PORT  – port (default: 5173)
 *   PROTOCOL  – http or https (default: http)
 *
 * Examples:
 *   APP_PORT=8080 npx testcafe ...
 *   HOST=staging.example.com APP_PORT=443 PROTOCOL=https npx testcafe ...
 */

export const BASE_URL = `${process.env.PROTOCOL || 'http'}://${process.env.HOST || 'localhost'}:${process.env.APP_PORT || 5173}`;
