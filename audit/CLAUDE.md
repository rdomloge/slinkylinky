# Audit Service

Microservice for recording and retrieving entity change history. Runs on port 8092.

## Overview

The audit service:
- Receives `AuditRecord` payloads from other services **via RabbitMQ only** (queue: `${rabbitmq.audit.queue}`; exchange: `slinkylinky.exchange`). It is never called over HTTP by other services.
- Exposes `GET /auditrecords` (tenant-scoped; `global_admin` can cross-tenant via `X-Tenant-Override` header).
- Persists to the `audit_record` table in the `audit` PostgreSQL database.

## AuditRecord Fields — How to Fill Them

### `who` — mandatory, `@NotBlank`

The authenticated user who triggered the action.

- In entity event handlers (`@HandleBeforeCreate` / `@HandleBeforeSave` / `@HandleAfterDelete`): use `entity.getCreatedBy()` for creates, `entity.getUpdatedBy()` for updates/deletes.
- In controllers: use `TenantContext.getUsername()`.
- Never hardcode a system username — if the actor is unknown, fail loudly rather than silently swallow the audit.

### `entityType` — `String`, nullable

The simple class name of the entity being audited. Always derive it with `ClassName.class.getSimpleName()` — never write the string literal by hand (class renames then silently break the audit log).

Known values: `Supplier`, `Demand`, `DemandSite`, `Proposal`, `Category`, `BlackListedSupplier`, `Organisation`, `User`.

Leave `null` only for cross-cutting events with no single target entity (e.g. `"login"`).

### `entityId` — `Long`, nullable

The database primary key of the audited entity. Pair it with `entityType` so the record can be used to look up the full entity history.

**Known issue:** `KeycloakUserController` stores a Keycloak UUID string (`String`) in this `Long` field — this is a bug. New code should always store a genuine `Long` PK, or leave the field `null` and describe the external reference in `detail` instead.

Leave `null` when the entity has no single numeric PK (e.g. login events, organisation-creation events before the entity is persisted with an ID).

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

## Sending an Audit Record

### Pattern (from linkservice or any caller)

```java
AuditRecord ar = new AuditRecord();
ar.setWho(TenantContext.getUsername());
ar.setWhat("create widget");
ar.setEntityType(Widget.class.getSimpleName());
ar.setEntityId(widget.getId());
ar.setDetail(objectMapper.writeValueAsString(widget));
ar.setEventTime(LocalDateTime.now());
ar.setOrganisationId(TenantContext.getOrganisationId());
auditRabbitTemplate.convertAndSend(ar);
```

### Transport

The `auditRabbitTemplate` bean (in `linkservice/config/RabbitConfig.java`) routes messages to `slinkylinky.exchange` with the audit routing key. The audit service's `AuditEventReceiver` listens, validates, and persists. There is no HTTP endpoint to POST audit records — do not add one.

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
