import { getAccessToken } from "@/auth/AuthProvider";
import { getTenantOverride } from "@/auth/TenantOverrideContext";

export async function fetchWithAuth(url, options = {}) {
  const accessToken = getAccessToken();

  if (!accessToken) {
    console.log("No access token - redirecting to login");
    window.location.href = "/";
    return;
  }

  const overrideOrgId = getTenantOverride();
  const headers = {
    ...(options.headers || {}),
    ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
    ...(overrideOrgId ? { 'X-Tenant-Override': overrideOrgId } : {}),
  };
  return fetch(url, { ...options, headers }); // do not call fetchWithAuth recursively!!
}
