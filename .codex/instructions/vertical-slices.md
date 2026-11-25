# Vertical slices and staged pull requests

## Default and scope

Use this workflow for new features and behavioral vertical slices whenever the work can be separated coherently. Apply it to solo and delegated implementation. Each slice still delivers one end-to-end behavior; the stages below partition its review, not the repository's architecture. Match existing file placement and conventions.

Skip stages with no meaningful changes. Do not create empty PRs, a PR per class, speculative infrastructure, or extra technical slices just to fill the sequence. Small fixes, technical-only work, or changes that cannot be separated safely may use fewer stages or one PR; record the concrete reason before implementation. Missing tools, credentials, or CI support are prerequisites to resolve or report, not reasons to silently abandon the workflow. Explicit task instructions take precedence.

This workflow does not authorize delegation, commits, pushes, PR publication, merges, deployments, production access, or protection bypasses. Follow existing action permissions. Without publication authorization, prepare the same local separation and report the proposed PRs. Preserve strict spec-TDD's independent authorship, visibility, approval, and review gates when that workflow is explicitly active; this default alone does not activate it.

## Plan the branches before writing

Identify the feature's parent branch and its eventual main-branch target (normally `main`, using the repository's actual default). All slice work converges on the parent; child PRs do not target main directly. Reuse an existing parent when supplied. Record each applicable stage, branch, fork point, PR base, owned files, contracts, unit checks, and acceptance command. Use repository branch naming conventions.

| Stage | Fork from / initial PR base | Contents |
| --- | --- | --- |
| Black-box acceptance tests | Parent | Acceptance scenarios, fixtures, controlled provider stubs, and necessary test support; no feature implementation |
| Base code, if needed | Parent | External connectors, file accessors, API clients, and other required foundation code, with its unit tests |
| Database code, if needed | Base branch if present, otherwise parent | Persistence adapters, mappings, migrations where required, and their unit tests |
| Business logic, if needed | Database branch if present, otherwise base branch if present, otherwise parent | Domain rules, use cases/services, and their unit tests |
| External interfaces, if needed | Business branch if present, otherwise nearest preceding production branch, otherwise parent | HTTP, CLI, consumers, scheduled jobs, composition/wiring, and their unit tests |

The acceptance branch is a sibling of the production stack. Never base production on it or copy acceptance assets into production PRs to obtain early green. In particular, retain base code as the business branch's ancestor when there is no database stage. Each production stage includes only its own implementation and supporting unit tests relative to its immediate base, while inheriting earlier production work.

Settle necessary consumer-defined ports, domain types, and signatures early using existing boundaries. Assign each shared contract, config, schema, dependency/lockfile, and generated asset to one stage/owner. Put minimal contracts in the earliest stage that needs them without introducing business policies into infrastructure or reversing dependency direction. Keep unassembled code inert; splitting PRs must not expose an incomplete or unsafe public feature. If a real dependency prevents this ordering, explain and agree the smallest necessary adjustment before affected work.

## Tests first, production in stages

1. Author acceptance tests on their parent-based branch before production implementation. The primary agent executes them against the unchanged parent application using controlled dependencies. Establish genuine assertion failures caused by missing required behavior. Record the exact tested source, test revision, commands, discovered scenarios, expected/observed outcomes, and criteria. Existing passing cases stay green. Already-satisfied criteria need verification evidence, never manufactured red.
2. Prepare the acceptance-test PR separately for review, documenting expected failing scenarios and evidence. Syntax, imports, compilation, discovery, readiness, infrastructure, or unrelated regression failures do not count as behavioral red. Keep the test expectations executable and enabled; do not use skips, artificial failures, relaxed assertions, or blanket success/allowed-failure CI settings. Do not bypass required checks to merge red tests. If CI/protection rules prevent the intended sequence, report the exact constraint and arrange final green verification before merge under existing permissions.
3. Implement only applicable production stages in order: base → database → business logic → external interfaces. Add each stage's unit tests in that same PR, including when a separate unit author owns them. Run its relevant unit/static/build and existing regression checks before calling it ready. Expected acceptance failures do not waive these checks. Whole-feature acceptance green is required after assembly, not for each incomplete production stage. Run focused integration checks earlier when the changed contract or risk requires them.

Ordinary implementation may use one author under the shared standards. Strict spec-TDD additionally requires its preimplementation independent acceptance-test review and distinct production/unit authors; do not combine those responsibilities to fit the PR structure. Test authors still never execute integration tests; the primary agent owns those runs.

## Review and merge

- Review production stages one by one in dependency order. Review acceptance tests separately against the requirements and public contracts. Give each review its exact base/head and stage scope; inherited stack changes are context rather than repeated review scope. Link the parent, sibling acceptance PR, dependencies, applicable criteria, checks, and expected incomplete behavior in PR descriptions. Avoid asking coworkers to rereview the cumulative feature at every stage.
- After individual production reviews, fold approved descendant branches into their preceding production branches and ultimately into the parent, respecting branch protections and required checks. Review each isolated stage diff before descendant merges enlarge that branch. If repository merge conventions instead land an upstream stage in the parent first, update descendant ancestry and retarget its PR to the new nearest base without bundling already-reviewed changes. Recheck diffs and invalidate affected evidence after conflict resolutions or substantive changes. Never automatically target main when an upstream branch disappears.
- Keep the acceptance-test PR separate until it has its own review. Assemble its exact reviewed tests with the completed production stack in an isolated local integration state when needed to demonstrate green before merging. Record both revisions and any assembly/conflict changes; re-review changed tests or behavior. Then merge the reviewed tests and production into the parent when authorized. Do not weaken checks or merge red tests into main.
- Final completion requires the primary agent to run the acceptance suite on the actual assembled parent source/artifact/configuration and observe green, plus applicable unit, regression, and required CI checks. A green stage, author handoff, or temporary assembly alone does not prove the final parent. If main changes or final conflict resolution invalidate results, rerun affected checks before readiness.
- The parent PR targets main and carries the complete slice with references to stage reviews and red-to-green evidence. Reuse those reviews while checking final integration and changes since review. After creating each requested PR, invoke `github-pr-feedback-checker` as required by AGENTS.md; account for intentional acceptance red under this workflow rather than treating it as a defect to suppress.

## Handoff and completion evidence

Keep a compact branch/PR map in chat with stage, fork point, current base/head, review/merge status, checks, skipped-stage reasons, and next action. Preserve it on resume and revalidate ancestry and evidence after merges. Distinguish `acceptance tests ready; expected red`, `production stage ready`, `assembled acceptance green`, and `parent verified; ready for main`. These describe evidence, not permission to merge. Report pending publication, reviews, CI, merges, and final-parent verification honestly; local preparation alone is not completion of a published feature workflow.
