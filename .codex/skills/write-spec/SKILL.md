---
name: write-spec
description: Collaboratively draft or revise an approvable repository specification for behavioral, technical, or mixed engineering work, with measurable criteria and a verification mapping. Use before implementation or when requirements change; drafting a spec does not start the implementation cycle.
---

# Write a spec

Turn the user's natural-language intent into a spec that independent test and production authors can use. The approved spec defines intended outcomes; black-box integration tests are the executable source of truth for externally observable behavioral acceptance criteria. Unit tests support internal rule and failure-case verification. Tests and checks can themselves be wrong; resolve disagreements against the approved spec.

## Ground and clarify

1. Identify the target repository, applicable instructions, existing specs, public contracts, test conventions, and current behavior. Use the installed codebase-memory skill for structural exploration when applicable. Resolve discoverable facts before asking questions.
2. Read `~/.codex/instructions/security.md` before defining security acceptance criteria. Apply relevant controls to affected boundaries; flag an unavailable reference or unsafe contract rather than claiming readiness.
3. Clarify goals, audience, in/out of scope, observable results, compatibility, and material tradeoffs. Ask focused questions only about unresolved decisions. Do not silently turn assumptions into requirements.
4. Classify each task or slice as behavioral, technical, or mixed. Classification follows its outcomes: technical implementation that changes public behavior still needs behavioral criteria.

## Specify outcomes

Use [the spec outline](references/spec-outline.md), adapting its length to the task. Omit irrelevant sections or mark them not applicable with a brief reason; do not create boilerplate requirements.

- **Behavioral:** numbered acceptance criteria with concrete Given/When/Then examples. Include relevant allowed, denied, invalid, boundary, failure, and forbidden-effect cases. Describe externally observable results rather than internal method calls.
- **Technical:** current state, target state, constraints, preserved invariants, and measurable acceptance criteria. Name the evidence establishing each outcome: regression tests, dependency resolution/advisory evidence, builds, static checks, compatibility checks, or a reproducible experiment. Define an experiment's setup, measure, and success threshold where relevant; do not invent performance targets.
- **Mixed:** use both forms and map verification per criterion. Do not force technical invariants into artificial Given/When/Then scenarios.

Cover purpose, scope boundaries, relevant interfaces, compatibility, and applicable security/failure requirements. Include migration, cutover, rollout, or rollback requirements when affected. Keep desired outcomes separate from implementation notes. Agree domain/application interfaces only when needed for independent unit-test authorship, using existing boundaries where possible; supporting internal interfaces may be settled during implementation without gating integration red. Material changes to approved contracts still require renewed approval.

Split work into small coherent vertical slices. Map every numbered criterion to a slice, test/check, expected outcome, and gate: integration red-to-green for behavioral acceptance criteria, unmet technical check-to-green, or passing regression baseline preserved. Unit tests may be authored before or during implementation and must pass where applicable before completion; unit red is not a prerequisite. Record criterion-specific justification for any technical integration/unit stage that is not applicable. Missing tooling is a blocker, not proof that a stage is unnecessary.

Examples of technical evidence:

- Dependency upgrade: installed and locked versions meet the approved patched range, dependency-resolution evidence is current, and relevant compatibility/regression checks pass.
- Behavior-preserving refactor: regression baseline stays green and a named architecture check or focused review demonstrates the required boundary. Do not break existing code to manufacture red.
- CI change: a controlled fixture or execution validates discovery, expected success/failure propagation, and the required job behavior; record remote execution prerequisites if local checks cannot establish it.

## Save and approve

Save the spec in the repository's established location, defaulting to `specs/<feature>.md`. Use a stable revision identifier such as `r1` plus a content digest recorded in chat. Present the complete draft and unresolved questions, then request explicit approval of that exact revision. Writing a file or invoking this skill is not approval.

Keep the file marked draft until affirmative approval arrives. After approval, record the approved revision in the spec; compute its digest after this metadata update and record it in chat. Approval metadata alone is not evidence of user approval. Do not record operational progress in the spec.

Material changes to outcomes, examples, interfaces, constraints, or verification invalidate approval for affected criteria. Increment the revision, explain the change, and obtain renewed approval before dependent implementation. Pure formatting changes may retain approval if semantic equivalence is established and the new digest is recorded.

End with the spec path, revision, approval status, and remaining blockers. Hand off to `$run-spec-tdd` only when the user requests execution; spec approval does not authorize spawning agents, implementation, commits, or publication.
