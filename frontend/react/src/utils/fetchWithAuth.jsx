import { getAccessToken } from "@/auth/AuthProvider";

export async function fetchWithAuth(url, options = {}) {
  const accessToken = getAccessToken();

  if (!accessToken) {
    console.log("No access token - redirecting to login");
    window.location.href = "/";
    return;
  }

  const headers = {
    ...(options.headers || {}),
    ...(accessToken ? { Authorization: `Bearer ${accessToken}` } : {}),
  };
  return fetch(url, { ...options, headers }); // do not call fetchWithAuth recursively!!
}
