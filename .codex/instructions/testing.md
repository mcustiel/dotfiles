# Testing and verification

### Shared expectations

- Follow the inspect, match, or ask requirements in `engineering.md`. Before adding or modifying tests, inspect representative tests and support files from the relevant suite. Match established structure and patterns; explain any proposed departure and obtain explicit user approval before implementing it, even when small. The testing preferences below do not authorize a different style or support architecture. Surface conflicts with mandatory requirements and request a decision before affected work; do not weaken security controls, assertions, or required coverage to preserve a pattern.

- Test observable contracts and meaningful behavior. Keep expectations independent of production constants/helpers when sharing them would conceal accidental contract changes.
- Add or update tests for changed behavior, fixed defects, and security decisions. Avoid tests that merely reproduce implementation details.
- Cover applicable valid, invalid, boundary, negative, and failure scenarios. Verify required effects and effects that must not occur.
- Run relevant repository checks. Do not weaken assertions or change required behavior merely to make tests pass; report contract discrepancies with evidence.
- **Test discovery:** When adding or moving tests, verify that the exact local and CI commands discover them. Inspect filename filters, include/exclude patterns, and runner configuration; a passing local default command is insufficient.
- **Regression durability:** Temporary verification scripts provide execution evidence but do not replace committed regression tests for fixed defects. Before completion, ensure meaningful regression coverage is tracked and included in normal local and CI workflows, or explicitly explain why it cannot be.

### Test selection: own behavior only

- Before writing any unit or black-box integration test, search existing tests for the same behavior and case, then read the relevant setup, inputs, assertions, and parameterized cases. Compare what they actually verify, not just test names or line-coverage reports. Check both suites where relevant and permitted; if test visibility is restricted by an approved workflow, obtain a coverage/gap summary from the primary agent without bypassing that restriction.
- Reuse existing coverage when it already establishes the intended case. If it is incomplete, extend the existing scenario or parameterized cases where appropriate; add a separate test only for an identified gap. Before writing, briefly identify the relevant existing tests and the additional behavior or defect the proposed change will cover, or record that no matching coverage was found.
- Overlap between unit and black-box coverage needs a distinct purpose, such as an internal boundary/failure rule versus end-to-end wiring and observable effects. Do not duplicate a case merely in a different file or test layer, or with different incidental fixture values. Do not remove required black-box acceptance coverage because a mocked unit test exercises related logic.
- Before adding a test, identify the behavior owned by this application and the realistic defect in that behavior that the assertion would catch. Do not add tests whose only target is language/runtime behavior, a standard library, a framework, or an external dependency. For example, do not test that TypeScript/JavaScript `map` transforms an array or that a dependency implements its documented API.
- Exercise dependencies only as needed to verify our own decisions, transformations, orchestration, error handling, and externally observable effects. Testing our mapping rules is useful; testing `map` itself is not. Provider stubs supply controlled responses so tests can check our handling of them, not certify the provider or its SDK.
- Do not add tests for coverage percentages, one test per file, or stage-readiness formalities. If a change contains only wiring or configuration and has no meaningful unit-test target, record why unit tests are not applicable and verify the relevant black-box behavior.

### Configuration-independent correctness

- Test correctness across supported configuration values, not the current values in production defaults, environment files, or deployment manifests. A valid tuning change must not require assertion or snapshot updates. Do not pin worker counts, concurrency, batch sizes, retry counts, timeouts, or similar operational settings to their current values.
- Supply explicit test-controlled configuration through established seams. Choose representative supported values, including relevant boundaries, to detect code that ignores configuration or accidentally hardcodes a value. Assert the behavior relative to the supplied value; do not merely read a production setting and compare it to itself. Keep these expectations independent of production logic that computes results.
- For example, in `gcp-documents-migration-service`, configure different worker limits in tests and verify our scheduler respects each supplied limit, completes eligible work, and handles failures as required. Do not assert that the service's default or deployed worker count equals today's number. Use controlled synchronization rather than timing assumptions when verifying concurrency.
- Where black-box support needs effective configuration for setup or observation, obtain it from the test-controlled application configuration rather than copying a deployment value. Keep assertions about required outcomes independent of production policy helpers.
- Configuration-independent tests still verify our own parsing, validation, fallback, and behavior-selection rules where those contain application logic. Use explicit inputs and assert the documented rule. Distinguish tunable settings from fixed business/protocol contracts: a value explicitly required by such a contract may have an independent exact expectation; a current configuration value alone is not such a contract.

### Unit tests

- Keep tests fast, deterministic, isolated, repeatable, and independent of external services or special environment setup.
- Match existing unit tests in the relevant repository area, including their suite nesting, setup, test bodies, fixtures, mocking, and assertions. Use RSpec-style `describe`, `beforeEach`, and `it` only when consistent with those conventions, or when no established convention exists and repository guidance permits it.
- Name tests by context and expected behavior. Avoid complicated shared setup and order dependence.
- When mocking dependencies, verify relevant arguments and contractual effects without coupling assertions to incidental implementation steps.
- Do not unit-test NestJS module declarations, dependency-injection wiring, decorator metadata/fallback wiring, bootstrap composition, or configuration declarations. Do not add module-compilation-only tests, provider/import/export inventories, metadata snapshots, or assertions of configured values. This includes tests like `file-uploader-service/src/decorator-metadata-fallback.spec.ts` and `src/rest-api.module.spec.ts`; these are examples of excluded test targets, not templates.
- Verify wiring and configuration integration through black-box tests that start the real application and exercise the affected supported entry points and outcomes. If wiring errors could escape existing black-box coverage, add the missing behavioral scenario there. Test application rules separately when they warrant unit coverage; do not turn framework or configuration declarations into unit-test targets.

### Integration tests

- Match existing integration tests and their support code in the relevant repository area, including scenario structure, lifecycle hooks, application setup, fixtures, provider stubs, observation helpers, and assertions. Obtain explicit user approval before adopting a different structure or support pattern.

- Exercise the application as a whole through real supported entry points, including HTTP endpoints and message consumers.
- Independently derive expectations from agreed requirements and public contracts.
- Verify relevant responses, persisted data, published messages, external requests, and absence of forbidden side effects.
- Cover applicable malformed inputs, unsupported values, duplicates, persistence failures, downstream failures, and security decisions.
- Use controlled databases and brokers and configurable external-provider stubs that verify received requests.
- Keep tests isolated and repeatable, with bounded waits for asynchronous effects. Pursue meaningful contract and failure coverage without delaying delivery for exhaustive input coverage.

## Expressive and semantic integration tests

### Scope and intent

- Apply the repository conventions and approval requirements above to this entire section. These prescriptions do not authorize introducing new capability classes, verifiers, suite contexts, or support layouts that depart from existing tests. Propose such changes and obtain explicit user approval first; surface conflicts with mandatory requirements before affected work.

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

## Worked examples

These examples illustrate the rules above; they are not repository templates or
new application requirements. Adapt their syntax, setup, helpers, and placement
to the inspected suite. TypeScript/Jest notation is illustrative. The operation
router and return-label contracts below are hypothetical; confirm real contracts
before choosing inputs, expected values, or failure behavior.

### Independent contract values and dependency arguments

Suppose an application-owned operation router accepts the public tokens `+` and
`/`, delegates calculation, returns the dependency result, rejects other tokens,
and records a metric only for division by zero. The target is our dispatch and
error handling, not JavaScript arithmetic or the dependency's implementation.

```typescript
describe('OperationRouter', () => {
  let dependency: { sum: jest.Mock; div: jest.Mock };
  let metrics: { divisionByZero: jest.Mock };
  let router: OperationRouter;

  beforeEach(() => {
    dependency = { sum: jest.fn(), div: jest.fn() };
    metrics = { divisionByZero: jest.fn() };
    router = new OperationRouter(dependency, metrics);
  });

  describe('when adding 2 and 3', () => {
    let result: number;

    beforeEach(() => {
      dependency.sum.mockReturnValue(5);
      result = router.operate('+', 2, 3);
    });

    it('returns the dependency result', () => {
      expect(result).toBe(5);
    });

    it('passes both operands to addition', () => {
      expect(dependency.sum).toHaveBeenCalledWith(2, 3);
      expect(dependency.div).not.toHaveBeenCalled();
    });
  });

  describe('when dividing 6 by 2', () => {
    beforeEach(() => {
      dependency.div.mockReturnValue(3);
    });

    it('returns the result and preserves operand order without recording division by zero', () => {
      const result = router.operate('/', 6, 2);

      expect(result).toBe(3);
      expect(dependency.div).toHaveBeenCalledWith(6, 2);
      expect(dependency.sum).not.toHaveBeenCalled();
      expect(metrics.divisionByZero).not.toHaveBeenCalled();
    });
  });

  it.each(['-', '*', '', ' ', 'divide'])(
    'rejects unsupported operation %j without invoking dependencies',
    operation => {
      expect(() => router.operate(operation, 6, 2))
        .toThrow('Unsupported operation');
      expect(dependency.sum).not.toHaveBeenCalled();
      expect(dependency.div).not.toHaveBeenCalled();
      expect(metrics.divisionByZero).not.toHaveBeenCalled();
    },
  );
});
```

The literal `+` is an independent public-contract input. Importing the
production `SUM_OPERATION` constant would allow a change to `-` to change both
implementation and test unnoticed. This does not justify copying tunable
configuration values into tests.

A fixed mock return value alone cannot detect reversed division arguments;
`toHaveBeenCalledWith(6, 2)` can. The metric assertion detects a condition changed
from zero to nonzero. Cover the metric's required positive case separately when
it is not already covered, using the agreed zero-divisor behavior. Choose invalid
cases for distinct risks (another operator, empty input, whitespace, an unknown
word); do not generate a large arbitrary list merely for volume. Assert missing
or wrong-type values at the real untyped boundary rather than bypassing types in
an unrelated domain unit test.

### Deterministic dates and meaningful boundaries

For a shipped-date return-window rule, avoid `new Date()` tied to wall-clock
time and avoid importing the production cutoff to calculate every expectation.
Suppose the agreed contract includes shipments exactly 30 elapsed days old, and
excludes older shipments. Control the clock at `2026-06-15T12:00:00.000Z` through
the established clock seam or fake-timer support, then check these explicit cases:

| Shipped at | Eligible | Defect detected |
| --- | --- | --- |
| `2026-06-14T12:00:00.000Z` | Yes | Rejecting an ordinary eligible shipment |
| `2026-05-16T12:00:00.000Z` | Yes | Excluding the inclusive boundary |
| `2026-05-16T11:59:59.999Z` | No | Accepting a shipment just outside the window |

Restore any modified global clock after each test. If the actual rule uses
calendar days, a business timezone, or a configurable window, derive cases from
that rule instead. Do not silently turn this illustrative 30-day rule into a
repository requirement.

### Configuration behavior and existing coverage

For a scheduler with a configurable worker limit, first read the existing
scheduler cases. If they already cover completion at limit `1`, extend their
parameterized cases with another supported limit such as `3` when that exposes
a hardcoded-limit risk; do not create a duplicate suite with different job IDs.

Use more eligible jobs than the supplied limit and a controlled worker gate.
Keep started workers pending; observe that the configured number can start and
no additional job starts while all slots are occupied, using an established
scheduler-idle signal or bounded observation. Release a slot, observe another
job start, then release remaining work and verify every eligible job completes
and peak active work never exceeds the supplied limit. Release gates in cleanup
even on failure. An upper-bound assertion alone would let a scheduler that
never starts work pass. Do not use arbitrary sleeps or assert today's deployed
worker count.

### A black-box scenario verifies all relevant outputs

Suppose an agreed return-label contract requires an HTTP `201` response, a
stored label, one creation event, and a carrier request. A scenario should express
the following steps through the suite's existing semantic support:

```text
Given an authenticated customer, an eligible order, and a unique request ID
And a carrier stub configured to return a known label reference
And an event listener registered before the request
When the customer requests a return label through the real HTTP endpoint
Then observe the HTTP status, headers, and body
And independently read the stored label
And wait with a deadline for the event matching this request
And observe the carrier requests matching this request
Then verify 201 and the required response fields
And verify stored customer, tenant, order, and carrier reference
And verify event payload, correlation ID, and required routing/properties
And verify the carrier request's method, path, and required data
And verify exactly one event over the bounded observation/completion interval
```

Execution and observation return data; verification checks that data without
performing more I/O. Build expected records and payloads from the agreed contract
and explicit scenario inputs, not production mappers. Only assert an exact event
count when the delivery contract requires it; otherwise verify the agreed
duplicate-handling behavior. A first matching event does not prove that no
duplicates followed. Include each output only when the actual feature uses it.

For a consumer entry point, publish a real message through the controlled broker
and observe the resulting application effects. For a job entry point, run the
supported command through existing support and observe exit code, stdout,
stderr, and relevant effects, including a nonzero-exit scenario. Importing and
calling the internal handler does not establish entry-point wiring.

### Rejected requests and downstream failures

For a required-field rejection, send raw JSON with that field actually omitted;
do not use a fixture builder that restores it. Check the agreed status and safe
error body, no new stored record, no carrier request, and no creation event.
For asynchronous forbidden effects, use a correlated bounded observation period
or a processing-completion signal before asserting absence. An immediate empty
queue read does not establish absence.

For cross-tenant access, authenticate as a customer in tenant A and request a
protected resource belonging to tenant B. Verify the agreed denial, no protected
data in the response, and no forbidden writes, provider calls, or messages. A
spoofed tenant field alone does not establish the authenticated identity.

For carrier timeouts or database write failures, induce the failure through the
controlled dependency boundary and verify the documented response, persistence
state, events, and retry/compensation behavior. Do not guess whether a partial
record or retry is allowed. A mocked repository exception in a unit test can
establish our error-handling decision; a separate black-box scenario establishes
that the real application and adapter deliver the required observable outcome.

## Acceptance tests across staged PRs

- For feature slices, read and follow `~/.codex/instructions/vertical-slices.md`. Author black-box tests first on a branch from the parent, separately from the production stack. The primary agent establishes behavioral red against the unchanged parent and combined green in a disposable local assembly while component PRs remain open targeting the parent. Verification on the actual assembled parent follows the user's manual merges and is required before readiness for main; report it as pending at the open-PR handoff. Unit tests live with their production stage and must pass for that stage to be ready.
- Intentional feature assertion failures on the acceptance PR are evidence of missing behavior, not permission to skip tests, relax assertions, bypass protection, or ignore unrelated failures. Stage readiness does not require whole-feature acceptance green. Test-only red readiness confirms that the existing app and harness run; supporting feature unit tests need not exist yet. Strict spec-TDD retains its additional independent review and authorship gates.

## Integration execution and readiness

- The primary agent owns all integration execution and combined verification. Test authorship readiness does not establish integration success.
- Before each integration run, confirm production and test-asset readiness, relevant unit/static results, the actual application revision and built artifact, effective configuration, prerequisites, and resource availability. Resolve blocking readiness issues first. For test-only work against unchanged production code, confirm the existing application state directly; do not require a production writer solely to satisfy readiness.
- Keep production code, test assets, and configuration stable during each run. Serialize commands sharing ports, databases, queues, generated output, or other mutable resources unless isolation is provided.
- Classify failures from evidence as application defects, test defects, contract discrepancies, or environment failures. Do not assume which side is wrong or weaken expectations to match implementation.
- Route fixes to the responsible owner, wait for fixes and affected checks to finish, confirm readiness again, and rerun affected coverage. Resume idle writers through the available follow-up tool; notification alone may not start work.
- Integration writers prepare test assets only. They must never start the application, integration suites, or shared test infrastructure, including through aggregate commands, or provision/reset databases, brokers, or containers. They may run safe static checks on assigned files only when those checks cannot launch resources or conflict with shared work.
- Only the primary agent coordinates shared infrastructure. Use controlled test dependencies, bounded waits, and safe diagnostics. Do not repeat unchanged passing checks without a new reason.
- Strict spec-TDD stage ordering and criterion-specific exceptions are defined in `~/.codex/skills/run-spec-tdd/SKILL.md` and apply only during that explicitly approved cycle.
