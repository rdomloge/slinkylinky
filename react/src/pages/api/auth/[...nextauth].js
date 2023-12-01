import NextAuth from "next-auth";
import GoogleProvider from "next-auth/providers/google";
import GithubProvider from "next-auth/providers/github";
import KeycloakProvider from "next-auth/providers/keycloak";


export default NextAuth({
  // Configure one or more authentication providers
  providers: [
    GoogleProvider({
        clientId: process.env.GOOGLE_CLIENT_ID,
        clientSecret: process.env.GOOGLE_CLIENT_SECRET,
***REMOVED***),
    GithubProvider({
        clientId: process.env.GITHUB_ID,
        clientSecret: process.env.GITHUB_SECRET,
***REMOVED***),
    KeycloakProvider({
        clientId: process.env.KEYCLOAK_ID,
        clientSecret: process.env.KEYCLOAK_SECRET,
        issuer: process.env.KEYCLOAK_ISSUER,
***REMOVED***),
    // ...add more providers here
  ],
  secret: process.env.NEXTAUTH_SECRET,
***REMOVED***