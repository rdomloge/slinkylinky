import React, { createContext, useContext, useState, useEffect, useCallback } from 'react';
import { jwtDecode } from 'jwt-decode';

const AuthContext = createContext(null);

const KEYCLOAK_URL = import.meta.env.VITE_KEYCLOAK_URL;
const KEYCLOAK_REALM = import.meta.env.VITE_KEYCLOAK_REALM;
const KEYCLOAK_CLIENT_ID = import.meta.env.VITE_KEYCLOAK_CLIENT_ID;

const TOKEN_KEY = 'sl_access_token';
const REFRESH_TOKEN_KEY = 'sl_refresh_token';
const ID_TOKEN_KEY = 'sl_id_token';

function getAuthorizationUrl() {
  const redirectUri = `${window.location.origin}/callback`;
  return `${KEYCLOAK_URL}/realms/${KEYCLOAK_REALM}/protocol/openid-connect/auth`
    + `?client_id=${KEYCLOAK_CLIENT_ID}`
    + `&response_type=code`
    + `&scope=openid profile email`
    + `&redirect_uri=${encodeURIComponent(redirectUri)}`;
}

function getTokenUrl() {
  return `${KEYCLOAK_URL}/realms/${KEYCLOAK_REALM}/protocol/openid-connect/token`;
}

function getLogoutUrl(idToken) {
  const redirectUri = `${window.location.origin}/`;
  let url = `${KEYCLOAK_URL}/realms/${KEYCLOAK_REALM}/protocol/openid-connect/logout`
    + `?post_logout_redirect_uri=${encodeURIComponent(redirectUri)}`
    + `&client_id=${KEYCLOAK_CLIENT_ID}`;
  if (idToken) {
    url += `&id_token_hint=${idToken}`;
  }
  return url;
}

function isTokenExpired(token) {
  try {
    const decoded = jwtDecode(token);
    return decoded.exp * 1000 < Date.now() + 30000; // 30s buffer
  } catch {
    return true;
  }
}

function getUserFromToken(token) {
  try {
    const decoded = jwtDecode(token);
    return {
      name: decoded.name || decoded.preferred_username,
      email: decoded.email,
      image: decoded.picture || null,
    };
  } catch {
    return null;
  }
}

export async function exchangeCodeForTokens(code) {
  const redirectUri = `${window.location.origin}/callback`;
  const body = new URLSearchParams({
    grant_type: 'authorization_code',
    client_id: KEYCLOAK_CLIENT_ID,
    code,
    redirect_uri: redirectUri,
  });

  const resp = await fetch(getTokenUrl(), {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body,
  });

  if (!resp.ok) throw new Error('Token exchange failed');

  const data = await resp.json();
  sessionStorage.setItem(TOKEN_KEY, data.access_token);
  sessionStorage.setItem(REFRESH_TOKEN_KEY, data.refresh_token);
  if (data.id_token) sessionStorage.setItem(ID_TOKEN_KEY, data.id_token);
  return data;
}

async function refreshAccessToken() {
  const refreshToken = sessionStorage.getItem(REFRESH_TOKEN_KEY);
  if (!refreshToken) return null;

  const body = new URLSearchParams({
    grant_type: 'refresh_token',
    client_id: KEYCLOAK_CLIENT_ID,
    refresh_token: refreshToken,
  });

  const resp = await fetch(getTokenUrl(), {
    method: 'POST',
    headers: { 'Content-Type': 'application/x-www-form-urlencoded' },
    body,
  });

  if (!resp.ok) return null;

  const data = await resp.json();
  sessionStorage.setItem(TOKEN_KEY, data.access_token);
  sessionStorage.setItem(REFRESH_TOKEN_KEY, data.refresh_token);
  if (data.id_token) sessionStorage.setItem(ID_TOKEN_KEY, data.id_token);
  return data;
}

export function getAccessToken() {
  return sessionStorage.getItem(TOKEN_KEY);
}

export function AuthProvider({ children }) {
  const [user, setUser] = useState(null);
  const [accessToken, setAccessToken] = useState(null);
  const [isLoading, setIsLoading] = useState(true);

  const loadSession = useCallback(async () => {
    let token = sessionStorage.getItem(TOKEN_KEY);

    if (!token) {
      setIsLoading(false);
      return;
    }

    if (isTokenExpired(token)) {
      const refreshed = await refreshAccessToken();
      if (!refreshed) {
        sessionStorage.clear();
        setIsLoading(false);
        return;
      }
      token = refreshed.access_token;
    }

    setAccessToken(token);
    setUser(getUserFromToken(token));
    setIsLoading(false);
  }, []);

  useEffect(() => {
    loadSession();
  }, [loadSession]);

  // Silently refresh before expiry
  useEffect(() => {
    if (!accessToken) return;

    try {
      const decoded = jwtDecode(accessToken);
      const expiresIn = decoded.exp * 1000 - Date.now() - 60000; // refresh 60s before expiry
      if (expiresIn <= 0) return;

      const timer = setTimeout(async () => {
        const refreshed = await refreshAccessToken();
        if (refreshed) {
          setAccessToken(refreshed.access_token);
          setUser(getUserFromToken(refreshed.access_token));
        } else {
          sessionStorage.clear();
          setUser(null);
          setAccessToken(null);
        }
      }, expiresIn);

      return () => clearTimeout(timer);
    } catch {
      // token decode failed, ignore
    }
  }, [accessToken]);

  const signIn = useCallback(() => {
    window.location.href = getAuthorizationUrl();
  }, []);

  const signOut = useCallback(() => {
    const idToken = sessionStorage.getItem(ID_TOKEN_KEY);
    sessionStorage.clear();
    setUser(null);
    setAccessToken(null);
    window.location.href = getLogoutUrl(idToken);
  }, []);

  const isAuthenticated = !!user && !!accessToken;

  return (
    <AuthContext.Provider value={{ user, accessToken, signIn, signOut, isAuthenticated, isLoading }}>
      {children}
    </AuthContext.Provider>
  );
}

export function useAuth() {
  const ctx = useContext(AuthContext);
  if (!ctx) throw new Error('useAuth must be used within AuthProvider');
  return ctx;
}
