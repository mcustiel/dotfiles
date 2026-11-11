---
name: review-subagents
description: Authorize and coordinate specialist review subagents for the current task when explicitly invoked. Select relevant reviewers and consolidate evidence-backed findings; does not authorize implementation or exploration delegation.
---

# Review with subagents

Explicit invocation authorizes relevant `code-quality-reviewer`, `security-reviewer`, `reliability-reviewer`, and `test-reviewer` assignments and bounded follow-ups for the current task. It does not require another assignment approval. Announce the chosen roles, scope, and rationale before dispatch; use only reviewers whose concerns are affected. If no specialist review is useful, explain that briefly and perform primary-agent self-review.

## Prepare and assign

1. Read `~/.codex/instructions/delegation.md` for assignment, review-selection, snapshot, ownership, and permission requirements. Read `~/.codex/instructions/testing.md` before planning verification, and apply required engineering/security guidance from `~/.codex/AGENTS.md`.
2. Confirm requirements, acceptance criteria, applicable security criteria, checks performed, and unrelated changes. Supply the explicit comparison base, included changes/files (including relevant staged and untracked files), and stable reviewed state. Do not dispatch a review with missing scope.
3. Assign each selected reviewer one bounded question, relevant evidence and reading requirements, exclusions, and a completion condition. Reviewers remain read-only. Use independent reviews concurrently when capacity permits, with scoped files frozen or an immutable snapshot.

## Resolve and finish

Wait for all assigned reviews, assess evidence, and consolidate duplicates. Resolve confirmed findings within the current task through the primary agent or an already authorized implementation owner. This skill does not authorize writer subagents: use `$implementation-subagents` only if the user separately invokes it or directly authorizes bounded implementation delegation. Rerun affected checks and arrange focused re-review against the new recorded state; reassess other conclusions only where affected.

Read the findings/completion sections of `~/.codex/instructions/reporting.md` before reporting. Distinguish independent reviews from self-review and passed, failed, or unperformed checks. Report material findings, dispositions, reviewed state, and remaining limitations.

## Authorization limits

- Permission covers this task and necessary review follow-ups, not unrelated work. Material task expansion needs fresh authorization. No exploration agents are authorized; they require a direct user request.
- In a strict spec-TDD cycle, this skill cannot replace cycle-level assignment approval or bypass any independent authorship, preimplementation review, or verification gate. Follow `~/.codex/skills/run-spec-tdd/SKILL.md` under its separately approved assignments.
- Missing roles, guidance, or scope stop dependent delegation. If authorization is withdrawn, interrupt affected agents and stop dispatch as required by the shared delegation instructions; continue safe independent work.
- Delegation adds no commit, push, publish, deploy, production-access, or destructive-action permission.
