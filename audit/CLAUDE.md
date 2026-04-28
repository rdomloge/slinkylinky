# Audit Service

Microservice for recording and retrieving entity change history. Runs on port 8092.

## Overview

The audit service:
- Receives `AuditEvent` payloads from other services **via RabbitMQ only** (queue: `${rabbitmq.audit.queue}`; exchange: `slinkylinky.exchange`). It is never called over HTTP by other services.
- Exposes `GET /auditrecords` (tenant-scoped; `global_admin` can cross-tenant via `X-Tenant-Override` header) and `GET /auditrecords/trace` (tenant-aware trace lookup).
- Persists to the `audit_record` table in the `audit` PostgreSQL database.

## AuditRecord Fields — How to Fill Them

### `who` — mandatory, `@NotBlank`

The authenticated user who triggered the action.

- In entity event handlers (`@HandleBeforeCreate` / `@HandleBeforeSave` / `@HandleAfterDelete`): use `entity.getCreatedBy()` for creates, `entity.getUpdatedBy()` for updates/deletes.
- In controllers: use `TenantContext.getUsername()`.
- For public/unauthenticated flows (no JWT): use the email address supplied in the request body. Never use a hardcoded placeholder.
- Never hardcode a system username — if the actor is unknown, fail loudly rather than silently swallow the audit.

### `entityType` — `String`, nullable

The simple class name of the entity being audited. Always derive it with `ClassName.class.getSimpleName()` — never write the string literal by hand (class renames then silently break the audit log).

Known values: `Supplier`, `Demand`, `DemandSite`, `Proposal`, `Category`, `BlackListedSupplier`, `Organisation`, `User`.

Leave `null` only for cross-cutting events with no single target entity (e.g. `"login"`).

### `entityId` — `String`, nullable

An opaque identifier for the audited entity, normalised to a string to support multiple ID types. Pair it with `entityType` so the record can be used to look up the full entity history.

Conversion rules:
- Numeric IDs (from Long PKs): convert with `String.valueOf(id)` — e.g., `"42"`
- UUID-backed entities: convert with `uuid.toString()` — e.g., `"550e8400-e29b-41d4-a716-446655440000"`
- External string IDs (e.g., Keycloak UUIDs): pass through unchanged — e.g., `"abc123def"`

Leave `null` only for action-only events (e.g. login events, organisation-creation events before the entity is persisted with an ID).

### `what` — mandatory, `@NotBlank`

Human-readable, lowercase description of the action. Conventional format: `"<verb> <entity>"`.

Established values (match exactly for consistency):
- `"create supplier"` / `"update supplier"`
- `"create demand"` / `"update demand"` / `"delete demand"`
- `"create demand site"` / `"update demand site"` / `"delete demand site"`
- `"create proposal"` / `"update proposal"` / `"delete proposal"`
- `"create category"` / `"update category"`
- `"create blacklisted supplier"`
- `"create user"` / `"disable user"`
- `"register user"` — public self-registration (RegistrationController)
- `"email verified"` — email address confirmed via token (VerifyEmailController)
- `"send verification email"` — verification email dispatched (ResendVerificationController)
- `"list organisations overview"` — global admin overview read (OrganisationsOverviewController)
- `"login"`
- `"create organisation <name>"` (name interpolated)
- `"Use chatgpt"` ← legacy capitalisation; new entries should be lowercase

### `eventTime` — mandatory, `LocalDateTime`

Set to `LocalDateTime.now()` at the point the event handler or controller fires. Do not use the entity's own `createdAt`/`updatedAt` fields — those may differ from when the audit message is sent.

### `detail` — mandatory (`AuditValidator` requires non-null), `@Lob TEXT`

Full JSON serialisation of the entity state at event time. Use `ObjectMapper.writeValueAsString(entity)` (the `objectMapper` bean is available in all auditor classes). This field is what allows historical reconstruction of entity state.

### `organisationId` — `UUID`, nullable

Tenant scoping field. Rules:

- **Must be set** for all tenant-scoped entity types (`Demand`, `DemandSite`, `Proposal`, `Supplier`, `Organisation`, `User`, etc.).
- **Must be null** (or can be null) for global entity types: `BlackListedSupplier`, `Category`.
- The audit service's `AuditValidator` enforces this: if `entityType` is set and not in `{BlackListedSupplier, Category}`, a null `organisationId` will cause the record to be rejected and not saved.

For tenant-scoped entities: `entity.getOrganisationId()` if the entity carries it, or `TenantContext.getOrganisationId()` otherwise.

## Sending an Audit Event

All producer services use the shared `com.domloge.slinkylinky.events.AuditEvent` from the `events` module. Do not create local audit DTOs.

### Pattern (from linkservice or any caller)

```java
AuditEvent ae = new AuditEvent();
ae.setWho(TenantContext.getUsername());
ae.setWhat("create widget");
ae.setEntityType(Widget.class.getSimpleName());
ae.setEntityId(String.valueOf(widget.getId()));  // Convert to string
ae.setDetail(objectMapper.writeValueAsString(widget));
ae.setEventTime(LocalDateTime.now());
ae.setOrganisationId(TenantContext.getOrganisationId());
auditRabbitTemplate.convertAndSend(ae);
```

### Transport & Deserialization

Each producer service's `auditRabbitTemplate` bean routes `AuditEvent` messages to `slinkylinky.exchange` with the audit routing key. The audit service's `AuditEventReceiver` listens, deserializes the wire format into its JPA `AuditRecord`, validates, and persists. This separation of transport (shared `AuditEvent`) and persistence (`AuditRecord`) allows safe evolution. There is no HTTP endpoint to POST audit records — do not add one.

## Validation

The audit service's `AuditValidator` enforces these rules:

| Field | Rule |
|-------|------|
| `detail` | non-null |
| `eventTime` | non-null |
| `what` | non-null |
| `who` | non-null, non-blank |
| `organisationId` | non-null if `entityType` is set AND not in `{BlackListedSupplier, Category}` |

Records failing validation are **silently dropped** (logged as an error but not re-queued). Ensure all fields are set before sending.
