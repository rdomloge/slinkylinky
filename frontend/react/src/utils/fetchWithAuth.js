import { getAccessToken, isTokenExpired, refreshAccessToken } from "@/auth/AuthProvider";
import { getTenantOverride } from "@/auth/TenantOverrideContext";

async function getValidToken() {
  let token = getAccessToken();
  if (!token) return null;

  if (isTokenExpired(token)) {
    const refreshed = await refreshAccessToken();
    if (!refreshed) return null;
    token = refreshed.access_token;
  }

  return token;
}

function buildHeaders(token, options) {
  const overrideOrgId = getTenantOverride();
  return {
    ...(options.headers || {}),
    Authorization: `Bearer ${token}`,
    ...(overrideOrgId ? { 'X-Tenant-Override': overrideOrgId } : {}),
  };
}

export async function fetchWithAuth(url, options = {}) {
  let token = await getValidToken();

  if (!token) {
    console.log("No valid access token — redirecting to login");
    window.location.href = "/";
    return;
  }

  const response = await fetch(url, { ...options, headers: buildHeaders(token, options) });

  // On 401, attempt one token refresh and retry
  if (response.status === 401) {
    const refreshed = await refreshAccessToken();
    if (!refreshed) {
      window.location.href = "/";
      return;
    }
    token = refreshed.access_token;
    return fetch(url, { ...options, headers: buildHeaders(token, options) });
  }

  return response;
}
