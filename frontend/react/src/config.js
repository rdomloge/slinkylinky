/**
 * Runtime configuration helper.
 *
 * In production the Docker entrypoint writes window.__CONFIG__ from env vars.
 * In development Vite inlines VITE_* from .env files via import.meta.env.
 * This helper checks the runtime value first, falling back to the build-time value.
 */
function getConfig(key) {
  const runtime = window.__CONFIG__ && window.__CONFIG__[key];
  if (runtime) return runtime;
  return import.meta.env[key];
}

export const KEYCLOAK_URL = getConfig('VITE_KEYCLOAK_URL');
export const KEYCLOAK_REALM = getConfig('VITE_KEYCLOAK_REALM');
export const KEYCLOAK_CLIENT_ID = getConfig('VITE_KEYCLOAK_CLIENT_ID');
export const GA_TRACKING_ID = getConfig('VITE_GA_TRACKING_ID') || 'G-4K0WX1L508';
