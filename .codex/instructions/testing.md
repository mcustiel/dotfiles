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

## Integration execution and readiness

- The primary agent owns all integration execution and combined verification. Test authorship readiness does not establish integration success.
- Before each integration run, confirm production and test-asset readiness, relevant unit/static results, the actual application revision and built artifact, effective configuration, prerequisites, and resource availability. Resolve blocking readiness issues first. For test-only work against unchanged production code, confirm the existing application state directly; do not require a production writer solely to satisfy readiness.
- Keep production code, test assets, and configuration stable during each run. Serialize commands sharing ports, databases, queues, generated output, or other mutable resources unless isolation is provided.
- Classify failures from evidence as application defects, test defects, contract discrepancies, or environment failures. Do not assume which side is wrong or weaken expectations to match implementation.
- Route fixes to the responsible owner, wait for fixes and affected checks to finish, confirm readiness again, and rerun affected coverage. Resume idle writers through the available follow-up tool; notification alone may not start work.
- Integration writers prepare test assets only. They must never start the application, integration suites, or shared test infrastructure, including through aggregate commands, or provision/reset databases, brokers, or containers. They may run safe static checks on assigned files only when those checks cannot launch resources or conflict with shared work.
- Only the primary agent coordinates shared infrastructure. Use controlled test dependencies, bounded waits, and safe diagnostics. Do not repeat unchanged passing checks without a new reason.
- Strict spec-TDD stage ordering and criterion-specific exceptions are defined in `~/.codex/skills/run-spec-tdd/SKILL.md` and apply only during that explicitly approved cycle.
