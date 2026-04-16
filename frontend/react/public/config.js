// Runtime configuration placeholder for development.
// In production this file is replaced by the server (Docker entrypoint / K8s init container)
// with a script that populates window.__CONFIG__ from env vars, e.g.:
//
//   window.__CONFIG__ = {
//     VITE_KEYCLOAK_URL: "https://...",
//     VITE_KEYCLOAK_REALM: "slinkylinky",
//     VITE_KEYCLOAK_CLIENT_ID: "sl-webapp"
//   };
//
// In development, Vite serves this empty object and the app falls back to
// import.meta.env (loaded from .env.development).
window.__CONFIG__ = {};
