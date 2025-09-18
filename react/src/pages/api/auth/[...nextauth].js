import NextAuth from "next-auth";
import GoogleProvider from "next-auth/providers/google";
import GithubProvider from "next-auth/providers/github";
import KeycloakProvider from "next-auth/providers/keycloak";
import { fetchWithAuth } from "@/utils/fetchWithAuth";

async function refreshAccessToken(token) {
  try {
    const url = `${process.env.KEYCLOAK_ISSUER}/protocol/openid-connect/token`;
    const params = new URLSearchParams({
      client_id: process.env.KEYCLOAK_ID,
      client_secret: process.env.KEYCLOAK_SECRET,
      grant_type: "refresh_token",
      refresh_token: token.refreshToken,
    });
    const response = await fetch(url, {       // Do not use fetchWithAuth here!! This is a call to the Keycloak server directly
      method: "POST",
      headers: {
        "Content-Type": "application/x-www-form-urlencoded",
      },
      body: params,
    });
    if (!response.ok) throw new Error("Failed to refresh token");
    const refreshedTokens = await response.json();
    return {
      ...token,
      accessToken: refreshedTokens.access_token,
      accessTokenExpires: Date.now() + refreshedTokens.expires_in * 1000,
      refreshToken: refreshedTokens.refresh_token ?? token.refreshToken,
    };
  } catch (error) {
    return { ...token, error: "RefreshAccessTokenError" };
  }
}

export default NextAuth({
  // Configure one or more authentication providers
  providers: [
    KeycloakProvider({
        clientId: process.env.KEYCLOAK_ID,
        clientSecret: process.env.KEYCLOAK_SECRET,
        issuer: process.env.KEYCLOAK_ISSUER,
    }),
    // ...add more providers here
  ],
  callbacks: {
    async jwt({ token, account, user }) {
      // Initial sign in
      if (account && user) {
        return {
          accessToken: account.access_token || account.id_token,
          accessTokenExpires: Date.now() + (account.expires_in ? account.expires_in * 1000 : 0),
          refreshToken: account.refresh_token,
          user, // store user info in token
        };
      }
      // Return previous token if the access token has not expired yet
      if (token.accessTokenExpires && Date.now() < token.accessTokenExpires) {
        return token;
      }
      // Access token has expired, try to update it
      return await refreshAccessToken(token);
    },
    async session({ session, token }) {
      session.accessToken = token.accessToken;
      session.error = token.error;
      session.user = token.user; // restore user info to session
      return session;
    }
  },
  secret: process.env.NEXTAUTH_SECRET,
  session: {
    strategy: "jwt",
  },
});