# Spec outline

Use natural language and concrete examples. Scale detail to the task rather than filling every heading mechanically.

## Identity and intent

- Title, revision, draft/approved status; approval evidence is in the chat.
- Behavioral, technical, or mixed; purpose and intended users.
- Current state, desired outcome, scope boundaries, compatibility constraints.

## Acceptance criteria

Use stable identifiers such as AC-1. Link each criterion to its slice.

Behavioral example:

> AC-1 — Given an authenticated customer who owns an eligible order, when they request a return label, then the service returns the agreed label response and records one label for that order.

Define relevant denial and duplicate outcomes separately; do not infer them from this example.

Technical example:

> AC-2 — Replace the deprecated persistence adapter while preserving the documented read/write contracts. Existing contract tests must pass before and after; the domain must no longer import the provider SDK, established by the repository's dependency check or a focused dependency review.

Specify the actual adapter, contracts, and verification method when drafting a real spec. Resolve material unknowns before approval.

## Interfaces and constraints

Describe relevant public inputs/results/errors and preserved invariants. Record required security, failure, and forbidden-effect behavior. Add internal contracts only where separate test authors need them; keep implementation suggestions in a clearly separate note.

## Slices and verification

| Slice | Criterion | Test/check and entry point | Expected outcome | Gate / applicability |
|---|---|---|---|---|

Populate with concrete test/check intentions and known commands where available. Execution-time discovery may resolve exact filenames without changing agreed outcomes. Every criterion needs evidence. Map externally observable behavioral criteria to black-box integration tests. Technical stage omissions need a specific reason; behavioral stages follow integration red → independent acceptance-test review → implementation with supporting unit tests → integration green → regression checks and review. Unit red is not a prerequisite; applicable unit tests must pass before completion.

## Operational requirements and open decisions

Record relevant migration/rollout/rollback constraints, dependencies, and unresolved questions. No material unresolved product or contract decision may be concealed by approved status.
