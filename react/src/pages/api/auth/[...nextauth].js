import NextAuth from "next-auth";
import GoogleProvider from "next-auth/providers/google";
import GithubProvider from "next-auth/providers/github";
import KeycloakProvider from "next-auth/providers/keycloak";


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
  secret: process.env.NEXTAUTH_SECRET,
});