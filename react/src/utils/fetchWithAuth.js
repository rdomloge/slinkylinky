import { getSession } from "next-auth/react";

export async function fetchWithAuth(url, options = {}) {
  const session = await getSession();
  if (session?.error === "RefreshTokenExpired") {
    // Redirect to login if refresh token has expired
    window.location.href = "/api/auth/signin"; 
    return; // Optionally, throw or return a rejected promise
  }
  const headers = {
    ...(options.headers || {}),
    ...(session?.accessToken ? { Authorization: `Bearer ${session.accessToken}` } : {}),
  };
  return fetch(url, { ...options, headers }); // do not call fetchWithAuth recursively!!
}
