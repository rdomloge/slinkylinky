import { getSession } from "next-auth/react";

export async function fetchWithAuth(url, options = {}) {
  const session = await getSession();
  const headers = {
    ...(options.headers || {}),
    ...(session?.accessToken ? { Authorization: `Bearer ${session.accessToken}` } : {}),
  };
  return fetch(url, { ...options, headers }); // do not call fetchWithAuth recursively!!
}
