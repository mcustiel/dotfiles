# Testing and verification

### Shared expectations

- Test observable contracts and meaningful behavior. Keep expectations independent of production constants/helpers when sharing them would conceal accidental contract changes.
- Add or update tests for changed behavior, fixed defects, and security decisions. Avoid tests that merely reproduce implementation details.
- Cover applicable valid, invalid, boundary, negative, and failure scenarios. Verify required effects and effects that must not occur.
- Run relevant repository checks. Do not weaken assertions or change required behavior merely to make tests pass; report contract discrepancies with evidence.
- **Test discovery:** When adding or moving tests, verify that the exact local and CI commands discover them. Inspect filename filters, include/exclude patterns, and runner configuration; a passing local default command is insufficient.
- **Regression durability:** Temporary verification scripts provide execution evidence but do not replace committed regression tests for fixed defects. Before completion, ensure meaningful regression coverage is tracked and included in normal local and CI workflows, or explicitly explain why it cannot be.

### Unit tests

- Keep tests fast, deterministic, isolated, repeatable, and independent of external services or special environment setup.
- Follow repository conventions. Prefer RSpec-style `describe`, `beforeEach`, and `it` where clear; execution within individual tests is also acceptable.
- Name tests by context and expected behavior. Avoid complicated shared setup and order dependence.
- When mocking dependencies, verify relevant arguments and contractual effects without coupling assertions to incidental implementation steps.

### Integration tests

- Exercise the application as a whole through real supported entry points, including HTTP endpoints and message consumers.
- Independently derive expectations from agreed requirements and public contracts.
- Verify relevant responses, persisted data, published messages, external requests, and absence of forbidden side effects.
- Cover applicable malformed inputs, unsupported values, duplicates, persistence failures, downstream failures, and security decisions.
- Use controlled databases and brokers and configurable external-provider stubs that verify received requests.
- Keep tests isolated and repeatable, with bounded waits for asynchronous effects. Pursue meaningful contract and failure coverage without delaying delivery for exhaustive input coverage.

## Expressive and semantic integration tests

### Scope and intent

- Integration scenarios must describe business setup, actions, and expected
  outcomes using the repository's domain language.
- Apply these conventions to new and modified integration tests in all
  repositories, following their languages, frameworks, and established structure.
  Migrate existing suites incrementally when requested; this policy alone does
  not authorize a repository-wide refactor.
- Apply boundary-specific guidance only to capabilities used by the repository;
  do not introduce infrastructure to satisfy this policy.
- Preserve scenario intent, test identifiers, public contracts, and existing
  coverage when refactoring.

### Scenario readability

- Keep each scenario at a consistent semantic level: arrange business
  conditions, perform an application action, observe its effects, and verify
  the outcomes.
- Hide HTTP clients, database drivers, broker clients, provider-stub
  configuration, shell commands, serialization, and polling loops in reusable
  test support.
- Keep business-relevant inputs explicit: customer identity, tenant, API
  version, device, quantities, dates, and exceptional provider behavior.
  Fixture factories may supply incidental defaults.
- Protocol-specific expectations remain explicit where they are part of the
  contract, including status codes, headers, schemas, and message properties.

### Cohesive capabilities

- Organize support around cohesive capabilities, using the repository's domain
  names, such as `ProductClaims`, `StoredClaims`, `CustomerStatusEvents`,
  `OrderService`, and `MaintenanceJobs`.
- Give operations meaningful names such as `create`, `givenOrder`,
  `findMissing`, `publishBlocked`, and `cleanShipmentHistory`.
- Group related operations together. Do not automatically create one class
  per endpoint or wrap every individual technical call in a separate class.
- Use composition and straightforward explicit types appropriate to the
  language. Classes, modules, or objects may express these capabilities.
  Avoid inheritance frameworks, fluent DSLs, generic "perform action"
  interfaces, and speculative abstractions.
- Place reusable capabilities under the integration suite's `support`
  directory or established equivalent, grouped by responsibility. Keep shared
  technical adapters internal. Follow the repository's existing structure.

### Separate execution, observation, and verification

- Action methods perform operations and return observations. They must not
  assert expected application behavior.
- Verification methods receive observations and explicit expectations.
  They must not issue requests, read storage, consume messages, run jobs,
  configure stubs, or wait for effects.
- Simple inline assertions are acceptable. Put larger, repeated checks in
  capability-specific verification classes or modules.
- Do not hide assertions in transport interceptors, setup methods, or fixture
  factories.

Use observations appropriate to each boundary:

- HTTP: return status, headers, and payload. HTTP error responses remain
  results; connection failures throw.
- Persistence: return independently defined stored-record observations
  containing the fields required by persistence assertions.
- Messaging: retain parsed payload, raw content, relevant properties,
  exchange/topic, and routing metadata.
- Jobs: return exit code, stdout, and stderr, including nonzero exits.
- External dependencies: expose semantic setup operations and observations
  of received requests.

### Contracts and malformed inputs

- Exercise the application through real supported entry points, including
  HTTP endpoints, message consumers, and CLI commands.
- Stub external providers at their boundaries; do not replace the application
  behavior under test with mocked services or repositories.
- Preserve version-specific contracts through explicitly named operations.
  Share transport mechanics without normalizing away meaningful differences.
- Provide clearly named raw operations for malformed or deliberately
  incomplete inputs.
- Raw operations must preserve supplied bytes and properties, including
  omitted properties. They must not validate, sanitize, repair, or silently
  supply missing values.
- Derive expectations independently from agreed requirements and public
  contracts. Do not use production converters or policy helpers to calculate
  expected results.

### Lifecycle, isolation, and asynchronous effects

- Use a suite-scoped context or equivalent composition root to assemble
  capabilities, read configuration, and own connections and listeners.
  Keep shared infrastructure provisioning in the established global setup.
- Register listeners before triggering actions.
- Make reset and disposal explicit and reliable. Prevent data, message,
  stub, and connection leakage between scenarios.
- Centralize bounded polling in support code. Use immediate `find` operations
  for synchronous observations and explicitly named `waitFor` operations for
  asynchronous effects, or their idiomatic language equivalents.
- Timeout errors must identify the awaited condition using safe diagnostics.
- Match messages by correlation identity and relevant contract fields.
  Preserve duplicate checks, queue/dead-letter checks, and assertions about
  forbidden side effects.
- Negative assertions require a bounded observation period or an established
  processing-completion signal. A single immediate read is insufficient.
- Follow `~/.codex/instructions/security.md` and applicable repository
  data-protection requirements for support diagnostics and test artifacts.

### Verification and maintenance

- During migrations, inventory existing scenarios and assertions. The primary
  agent records baseline results and runs affected suites before and after
  migration, following the execution and readiness rules below.
- Preserve checks for responses, persistence, outgoing messages, external
  requests, metrics, failures, duplicates, and forbidden side effects.
- Add focused support tests where a helper defect could conceal coverage:
  rejection handling, exact raw-input forwarding, correlation, timeout
  behavior, job failure results, and verifier failures on incorrect
  observations. Avoid tests for trivial delegation. Respect assigned file and
  role ownership; report needed support tests outside your ownership to the
  primary agent for assignment.
- The primary agent ensures relevant integration, type, lint, and formatting
  checks run. Ensure support tests are included in normal local and CI
  workflows. Writers remain subject to their execution restrictions below.
- When establishing or migrating conventions, document representative
  examples for the HTTP, messaging, persistence, and job boundaries actually
  used by the repository.

## Integration execution and readiness

- The primary agent owns all integration execution and combined verification. Test authorship readiness does not establish integration success.
- Before each integration run, confirm production and test-asset readiness, relevant unit/static results, the actual application revision and built artifact, effective configuration, prerequisites, and resource availability. Resolve blocking readiness issues first. For test-only work against unchanged production code, confirm the existing application state directly; do not require a production writer solely to satisfy readiness.
- Keep production code, test assets, and configuration stable during each run. Serialize commands sharing ports, databases, queues, generated output, or other mutable resources unless isolation is provided.
- Classify failures from evidence as application defects, test defects, contract discrepancies, or environment failures. Do not assume which side is wrong or weaken expectations to match implementation.
- Route fixes to the responsible owner, wait for fixes and affected checks to finish, confirm readiness again, and rerun affected coverage. Resume idle writers through the available follow-up tool; notification alone may not start work.
- Integration writers prepare test assets only. They must never start the application, integration suites, or shared test infrastructure, including through aggregate commands, or provision/reset databases, brokers, or containers. They may run safe static checks on assigned files only when those checks cannot launch resources or conflict with shared work.
- Only the primary agent coordinates shared infrastructure. Use controlled test dependencies, bounded waits, and safe diagnostics. Do not repeat unchanged passing checks without a new reason.
- Strict spec-TDD stage ordering and criterion-specific exceptions are defined in `~/.codex/skills/run-spec-tdd/SKILL.md` and apply only during that explicitly approved cycle.
