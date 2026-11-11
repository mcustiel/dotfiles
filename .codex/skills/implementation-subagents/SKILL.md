---
name: implementation-subagents
description: Authorize and coordinate production and integration-test writers for the current task when explicitly invoked. Assign ownership and coordinate verification; does not authorize review, exploration, or strict spec-TDD delegation.
---

# Implement with subagents

Explicit invocation authorizes `production-code-writer` and `integration-test-writer` assignments and bounded follow-ups for the current task. It does not require another assignment approval. Announce the roles, owned files/responsibilities, and expected benefit before dispatch. Prefer the primary agent or a single writer when additional coordination would not help.

## Prepare and assign

1. Read `~/.codex/instructions/engineering.md`, `~/.codex/instructions/security.md`, `~/.codex/instructions/testing.md`, and `~/.codex/instructions/delegation.md`. Establish requirements, acceptance criteria, contracts, security criteria, current changes, verification commands, and ownership before writing.
2. Give the production writer application code and relevant unit tests. Add an integration writer only when integration tests, fixtures, provider stubs, or explicitly assigned test infrastructure need adding or modifying; never assign it solely to run existing tests. Give each shared file one owner.
3. Provide bounded assignments, completion conditions, relevant evidence, all required reading paths, and exclusions. Writers must preserve others' changes. Parallelize preparation only with stable contracts and non-overlapping edit scopes; coordinate changed contracts or ownership through the primary agent.

## Verify and finish

Writers run only their permitted checks and report actual results and outstanding criteria. Integration writers author assets and run safe static checks only: they must never start applications, integration suites, or shared infrastructure. Their handoff is `tests ready; execution pending`.

The primary agent confirms readiness, source/artifact identity, configuration and resources, executes integration checks, and keeps code/assets stable during runs. Classify failures from evidence and route fixes to the appropriate owner. Complete fixes and affected checks before confirming readiness and rerunning coverage. Read the shared testing guidance for execution details.

Release unneeded writer capacity before review. This skill does not authorize reviewer subagents; perform primary-agent self-review or use review delegation only when separately authorized through `$review-subagents` or a direct user request. Read the handoff/completion sections of `~/.codex/instructions/reporting.md` and report resulting behavior, changed files, actual checks, review status, blockers, and limitations. Writer readiness is not combined feature completion.

## Authorization limits

- Permission covers this task and necessary writer follow-ups. Material task expansion needs fresh authorization. No independent unit-test writer, reviewer, or exploration agent is authorized by this skill; exploration requires a direct user request.
- Strict spec-TDD is a separate workflow with separate cycle-level assignment approval, independent production/unit/integration authorship, and mandatory reviews. This skill cannot authorize its delegation or bypass its gates. Follow `~/.codex/skills/run-spec-tdd/SKILL.md` only under the required approvals.
- Missing roles, guidance, or ownership stop dependent delegation. If authorization is withdrawn, interrupt affected agents and stop dispatch as required by the shared delegation instructions; continue safe independent work.
- Delegation adds no commit, push, publish, deploy, production-access, or destructive-action permission.
