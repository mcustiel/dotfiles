# Engineering security requirements

## Scope and application

- Security applies throughout design, implementation, testing, and review. Delegation does not transfer all security responsibility away from the primary agent.
- Validate external inputs, enforce authentication and resource authorization, protect sensitive data, and require relevant negative tests.
- This file is the authoritative home for detailed security requirements. Role and workflow instructions define responsibilities without redefining or weakening these requirements.

- Apply these requirements to changed behavior and affected boundaries, using applicable repository instructions and established safe contracts.
- Identify applicable controls and include them in acceptance criteria. The same requirements apply to direct and delegated implementation.
- If a contract requires unsafe behavior, report the conflict and obtain a decision before implementing dependent behavior. Continue independent work where possible.
- Report material existing gaps outside scope; do not silently expand the task or claim security without evidence.

## External inputs and domain invariants

- Treat external inputs as untrusted, including HTTP requests, CLI arguments, incoming messages, files and file metadata, configuration, and external-service responses.
- Validate shape, supported values, and applicable size limits at the external boundary before invoking application/domain logic.
- Convert primitives representing domain concepts into validated value objects or branded types before crossing the domain boundary.
- Establish domain invariants when constructing values and preserve them through operations. Do not repeat boundary validation for validated domain values in trusted internal calls.
- Allowlist finite supported sets, such as tenants, actions, statuses, features, device types, and document types. Reject unknown behavior-controlling values instead of selecting a default.
- Deliberately reject or strip unsupported fields according to the contract. Define appropriate limits for strings, metadata, and collections.
- In NestJS, use DTO validation and appropriate validation pipes. Explicitly validate DTOs outside automatically validated controller paths, such as with `validateOrReject`.
- Test applicable malformed, unsupported, missing, and boundary inputs, including absence of forbidden side effects.

## Authentication and authorization

- Require authenticated identity for protected operations. Derive identity from trusted authentication context, not requester-supplied customer or tenant IDs.
- Verify applicable permissions, tenant relationships, and resource ownership before returning or changing protected data.
- Fail closed for missing identity, ownership or tenant mismatches, unsupported permissions, and failed authorization checks.
- Test authorized access and relevant denied paths, including wrong identity and tenant mismatch. Verify rejected access has no forbidden side effects.

## Rendered text and HTML

Apply when user-controlled content can be rendered:

- Define whether fields are plain text or intentionally support HTML. Do not interpret ordinary text as HTML.
- Encode output for its rendering context. Sanitize permitted HTML using a maintained sanitizer and explicit policy; reject unsupported content when appropriate.
- When metadata or comments require sanitization, apply the policy through nested objects and arrays while preserving valid non-string values.
- Avoid blanket sanitization or premature HTML encoding that corrupts ordinary domain data.
- Test malicious payloads, nested content, and permitted content.

## Database operations and dynamic keys

Apply when constructing database operations or accepting dynamic keys:

- Build filters, updates, and pipelines from validated inputs. Never spread raw request objects into database operations.
- MongoDB operators, such as `$in`, `$set`, and `$ne`, must originate from application code.
- Reject unsupported dynamic keys beginning with `$`, prototype-pollution keys (`__proto__`, `constructor`, `prototype`), and dot notation where it could alter the intended database path.
- Apply key validation recursively to accepted nested metadata. Prefer rejection; preserve deliberate sanitization only when required by the established contract and the result remains safe.
- Test applicable operator injection, unsafe keys, nested structures, and invalid dynamic paths.

## Uploads

Apply when accepting uploads:

- Validate required file presence, size, supported type, and detected content type according to the feature's contract.
- Do not trust filenames, extensions, or declared MIME types alone. Check detected content against the supported-type allowlist and declared type.
- Enforce limits before expensive processing or unbounded buffering where practical. Keep supported types and limits specific to the feature.
- Test missing files, unsupported content, MIME mismatches, and oversized uploads.

## Payload and rate limits

Apply to externally triggered HTTP endpoints and message flows:

- Assess payload limits and rate limiting according to normal usage, processing cost, and downstream capacity, especially for writes, uploads, refunds, cancellations, notifications, and expensive operations.
- Prefer trusted identity keys, such as tenant plus authenticated customer ID. For unauthenticated traffic, use the safest available client/network identity and document its limitations.
- Align application and platform/gateway limits, including Istio where applicable. Identify decisions requiring IT Platform coordination.
- Return `429 Too Many Requests` for HTTP rate-limit rejection according to the contract.
- Safely measure and log limit hits so limits can be tuned.
- When limits are introduced or changed, test accepted requests and requests exceeding them.

## Sensitive data, errors, and logging

- Never log bearer tokens, raw JWTs, authorization headers, file contents, full metadata payloads, or unnecessary personal data.
- Use the existing logger and redaction configuration. Update redaction rules when introducing secret-bearing fields.
- Verify relevant logging paths honor redaction, including debug and failure paths.
- Prefer safe decision labels, such as `token_expired` or `tenant_mismatch`, with only identifiers necessary for investigation.
- Keep infrastructure internals, secrets, and unnecessary personal data out of client-facing errors. Preserve original causes and safe diagnostic context internally.
- Do not expose credentials or sensitive payloads through test output, fixtures, command output, or verification reports.

## Verification and reporting

- Assess validation, deny-by-default behavior, authorization, injection defenses, uploads, payload/rate limits, safe logging, and negative tests against changed behavior and affected boundaries.
- Record applicable controls and verification evidence. Mark remaining categories as not applicable with brief reasons.
- Derive test expectations from requirements and public contracts rather than copying implementation decisions.
- Verify required effects and forbidden effects through appropriate unit and integration coverage.
- Distinguish implemented controls, verified controls, unperformed checks, and unresolved gaps.
- Report decisions requiring user or platform input. Keep user-facing reporting proportional to material findings and limitations.
