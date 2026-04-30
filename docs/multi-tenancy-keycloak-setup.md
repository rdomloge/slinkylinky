# Multi-Tenancy Keycloak Setup Guide

This document describes the manual Keycloak configuration required to enable multi-tenancy in SlinkyLinky. No realm export exists in this repository — all configuration is done via the Keycloak Admin UI or Admin REST API.

## Role Model

| Keycloak Role | Name in UI | Capabilities |
|---|---|---|
| `global_admin` | Platform Admin | Cross-tenant access, Supplier CRUD, global-disable Suppliers, Blacklist management, Categories, Orders, tenant creation, tenant switching |
| `tenant_admin` | Tenant Admin | Manage own tenant's users, approve/manage Proposals, exclude Suppliers for their org, full Demand/DemandSite CRUD within own org |
| *(no special role)* | Tenant Operator | Read/create access within own org; cannot manage users or exclude Suppliers |

## Step 1 — Create the `org_id` Claim Mapper

This adds the user's organisation ID to every issued access token.

1. In Keycloak Admin UI, navigate to **Realm → Client Scopes**.
2. Click **Create client scope**.
   - Name: `org_id`
   - Type: Default
   - Protocol: openid-connect
3. Inside the new scope, click **Mappers → Add mapper → By configuration → User Attribute**.
   - Name: `org_id`
   - User Attribute: `org_id`
   - Token Claim Name: `org_id`
   - Claim JSON Type: String
   - Add to access token: **ON**
   - Add to ID token: ON (optional)
   - Add to userinfo: ON (optional)
4. Save.

## Step 2 — Assign the Scope to the `sl-webapp` Client

1. Navigate to **Realm → Clients → sl-webapp → Client Scopes**.
2. Under **Assigned default client scopes**, click **Add client scope** and add `org_id`.

## Step 3 — Ensure Realm Roles Exist

1. Navigate to **Realm → Realm roles**.
2. Confirm roles `global_admin` and `tenant_admin` exist. Create them if not:
   - Click **Create role** → Name: `global_admin` → Save.
   - Click **Create role** → Name: `tenant_admin` → Save.

## Step 4 — Assign `global_admin` to Platform/Root Users

For each user who should have cross-tenant root access:

1. Navigate to **Realm → Users → [user] → Role Mapping**.
2. Click **Assign role** → Filter by realm roles → Select `global_admin` → Assign.

## Step 5 — Set `org_id` Attribute on All Existing Users

Each user must have their organisation's UUID set as a user attribute.

# Ramsay Insert
The instructions are a little out of date and in order to add an attribute to a user, you first have to click 
Realm Settings >> User Profile >> Create attribute
..then you'll be able to add values for this attribute key below
# /Ramsay Insert

For each existing user:

1. Navigate to **Realm → Users → [user] → Attributes**.
2. Add attribute:
   - Key: `org_id`
   - Value: `<uuid of the user's organisation>` (the UUID you insert into the `organisation` table)
3. Save.

> **Note:** The `organisation` table UUID must be inserted in the database before assigning it here. See Phase 1 migration (`linkservice/db-scripts/v6.0-organisation.sql`).

## Step 6 — Grant `global_admin` to the `sl-server` Service Account

The `sl-server` client is used by the `supplierengagement` service for server-to-server calls to `linkservice` (e.g. converting a lead to a Supplier). Supplier creation is guarded by `SupplierWriteGuard`, which requires the `global_admin` realm role.

1. Navigate to **Realm → Clients → `sl-server`**.
2. Go to the **Service account roles** tab.
3. Click **Assign role** → Filter by realm roles → Select `global_admin` → **Assign**.

Without this, any service-to-service call that writes a Supplier will return 403.

## Step 7 — Create the `internal_service` Client Scope

`EmailVerifiedFilter` (applied in every service) blocks tokens where `email_verified` is false or absent. Keycloak service accounts have `email_verified: false` by default, so service-to-service calls would be rejected without an explicit bypass.

The bypass is the `internal_service` scope. Any JWT carrying this scope is treated as a machine token and skips the email-verification gate. It must be assigned to **every client that makes `client_credentials` calls**.

### Create the scope

1. Navigate to **Realm → Client Scopes → Create client scope**.
   - Name: `internal_service`
   - Type: Default
   - Protocol: openid-connect
2. On the **Settings** tab, ensure **"Include in token scope"** is **ON**. This is the critical setting — without it, the scope name never appears in the JWT `scope` claim, so `EmailVerifiedFilter` will not recognise the token as a machine token even if the scope is correctly assigned to the client.
3. No mappers needed — presence of the scope in the token is the only signal required.
4. Save.

### Assign to service-account clients

For each client that uses `grant_type=client_credentials`:

| Client | Used by |
|--------|---------|
| `sl-server` | supplierengagement → linkservice |
| `sl-admin` | linkservice → stats (spam score checks) and linkservice → Keycloak Admin API |

For each:

1. Navigate to **Realm → Clients → [client] → Client Scopes**.
2. Under **Assigned default client scopes**, click **Add client scope** → select `internal_service` → **Add**.

> **Gotcha:** Assigning the scope as Default or Optional is not enough on its own. The `internal_service` Client Scope must also have **"Include in token scope" = ON** (configured in the previous step). If that setting is off, Keycloak silently omits the scope name from the JWT even though the scope is assigned — the granted scope in the token response will show only `profile email` and the bypass in `EmailVerifiedFilter` will never fire.

Without this, service-to-service calls through `EmailVerifiedFilter` will return `403 EMAIL_NOT_VERIFIED`.

## Step 8 — Create Service Account Client for Admin API Proxy (Phase 6)

Required for the `KeycloakAdminClient` that manages users via the backend.

1. Navigate to **Realm → Clients → Create client**.
   - Client ID: `sl-admin`
   - Client authentication: **ON**
   - Service accounts roles: **ON**
   - Leave all other flows off.
2. After creation, go to **Credentials** tab — copy the client secret. Store it as:
   - K8s secret key: `KEYCLOAK_ADMIN_CLIENT_SECRET`
   - App property: `keycloak.admin.client.secret`
3. Go to **Service account roles** tab → Assign role:
   - Filter by clients → select `realm-management` client → assign `manage-users` and `view-users`.

## Step 8 — Enable Realm Login Events (Prerequisite for Last-Login Display)

For each tenant realm, in Keycloak Admin Console:

1. Go to **Realm Settings → Events**.
2. Under **Login events**, set **Save events** to **ON**.
3. Set **Expiration** to at least **30 days**.
4. Click **Save**.

Without this, the Organisations Overview page shows **Never** for all last-login values. Complete before the first users sign up in that realm.

## Environment Variables Summary

| Variable | Where used | Value |
|---|---|---|
| `KEYCLOAK_ADMIN_URL` | linkservice | `http://keycloak-service:8100` (internal K8s) |
| `KEYCLOAK_ADMIN_CLIENT_ID` | linkservice | `sl-admin` |
| `KEYCLOAK_ADMIN_CLIENT_SECRET` | linkservice / K8s secret | From step 6 credentials |

## Per-Tenant Onboarding Checklist

When a new organisation is created via the platform:

- [ ] Create new tenant realm in Keycloak
- [ ] Enable login events for the realm (Step 8 above)
- [ ] Insert row into `organisation` table (done by `OrganisationController.createOrganisation`)
- [ ] Create first user in Keycloak (done by `KeycloakUserController.createUser`)
- [ ] Set `org_id` attribute on that user to the new org's UUID
- [ ] Assign `tenant_admin` role to the first user
- [ ] Verify the user can log in and sees only their org's data
