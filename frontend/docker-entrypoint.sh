#!/bin/sh
# Generate runtime config from environment variables.
# This runs at container startup, BEFORE nginx serves any files,
# so the SPA picks up env-var values instead of build-time defaults.

cat <<EOF > /usr/share/nginx/html/config.js
window.__CONFIG__ = {
  VITE_KEYCLOAK_URL: "${VITE_KEYCLOAK_URL:-}",
  VITE_KEYCLOAK_REALM: "${VITE_KEYCLOAK_REALM:-}",
  VITE_KEYCLOAK_CLIENT_ID: "${VITE_KEYCLOAK_CLIENT_ID:-}",
  VITE_GA_TRACKING_ID: "${VITE_GA_TRACKING_ID:-}",
  VITE_REGISTRATION_ENABLED: "${ACCOUNTS_REGISTRATION_ENABLED:-true}"
};
EOF

exec "$@"
