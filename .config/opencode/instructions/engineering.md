# Engineering standards

## Scope and working approach

- Apply these guidelines to engineering work. Apply technology-specific guidance only when that technology is involved.
- Follow explicit task instructions and applicable repository instructions, conventions, and tooling.
- Choose the simplest clear solution that satisfies the requirements, security obligations, and architectural boundaries below.
- Draw on Clean Code, Clean Architecture, Refactoring, Design Patterns, Domain-Driven Design, Structure and Interpretation of Computer Programs: JavaScript Edition, and Dijkstra's work on algorithms and concurrency. Apply relevant lessons from C programming and systems design. Use these sources to inform judgment, not to justify unnecessary abstractions or changes beyond the task.
- Keep changes proportional to the task. Avoid speculative abstractions, extensibility, unrelated cleanup, and architectural migrations.
- Make routine implementation decisions autonomously within the authorized scope and established repository conventions. Departures require explicit user approval under the repository conventions section below, even when small. Explain the benefit and cost of broader improvements and obtain approval before implementing them.
- Preserve documented public contracts. If a contract requires unsafe behavior, report the conflict and obtain a decision; do not silently preserve the vulnerability or change the contract.
- Treat work as production work unless explicitly designated a disposable prototype. Prototype status does not waive security or data protection requirements.

## Feature implementation workflow

- Before planning or implementing a feature or behavioral vertical slice, read and follow `~/.config/opencode/instructions/vertical-slices.md`. Use its separate acceptance-test branch and staged production PRs wherever applicable, keeping each stage coherent and its unit tests together. Record justified exceptions and skipped stages; preserve repository architecture, security requirements, and action permissions.

## Repository conventions: inspect, match, or ask

- Before writing production code, read the relevant worked examples in `~/.config/opencode/instructions/production-code-examples.md`. They illustrate these standards; adapt them to inspected repository conventions and confirmed contracts rather than copying their structure or hypothetical business rules.

- Before adding or modifying production code, unit tests, or integration tests, inspect representative existing files of the same kind in the relevant repository area and applicable repository instructions. Identify the established patterns before writing; do not infer them solely from general guidance or framework defaults.
- Match existing production structure for module definitions, use cases, controllers, services, repositories, and other components. Follow established file placement, naming, imports, dependency injection, interfaces, error handling, and implementation patterns.
- Inspect unit tests and integration tests separately. Match the relevant suite's structure, naming, scenario organization, setup and teardown, fixtures, builders, helpers, mocks or stubs, and assertion patterns. Do not introduce a parallel test style or support framework merely because it appears cleaner.
- If a different approach appears preferable, explain the existing pattern, proposed departure, benefits, and tradeoffs, and obtain explicit user approval before implementing it. This applies even to small departures. General authorization to implement a feature, fix a defect, or improve code does not approve a departure; approval must explicitly cover the proposed change in convention.
- Architectural and testing preferences in these shared instructions do not authorize silently replacing established repository patterns. If an existing pattern conflicts with a mandatory architectural, security, or testing requirement, surface the conflict and request a decision before proceeding with affected work. Do not silently preserve unsafe behavior or waive mandatory requirements; continue safe independent work where possible.
- If no comparable examples exist, use applicable repository guidance and the closest established patterns. If those sources conflict or leave a material structural choice unresolved, ask before introducing a new convention.

## Architecture and domain modeling

- Apply this section subject to the repository conventions and approval requirements above.

- Keep business policies in a clear domain layer, independent of HTTP, databases, frameworks, and external providers. Keep presentation and persistence outside that layer.
- Use domain language in names. Organize application code at the top level by business capability or cohesive domain area, such as returns, refunds, claims, and validation. Within each group, place its HTTP adapters, use cases, domain behavior, persistence, and messaging as needed. Prefer this business grouping over top-level technical groups such as controllers, services, and repositories. A group need not correspond to a single DDD aggregate.
- Keep related behavior within its business group and cross-domain communication behind clear interfaces. Keep genuinely shared infrastructure and application composition separate where appropriate; do not move capability-specific behavior into shared technical folders merely because it uses the same framework or mechanism. Apply these organization and boundary rules when implementing and reviewing code.
- Preserve existing repository structure during focused changes. New or changed business logic must respect the required boundaries. If even a local separation would depart from established patterns, explain the conflict and obtain explicit user approval before implementing it; broader structural changes also require a scope decision.
- For database or external-provider migrations, identify affected read/write contracts, data ownership, migration and synchronization needs, failure semantics, operational configuration, cutover, and rollback. Distinguish completing the application changes from completing the operational migration.
- Domain entities, value objects, and aggregates own business rules and invariants. Keep DTOs, external payloads, and persistence records separate, translating at boundaries.
- Represent meaningful domain concepts, such as customer IDs, tenants, money, quantities, hashes, and statuses, with validated value objects or branded types before they enter the domain. Plain type aliases do not provide type distinction; brands still require runtime validation.
- Establish invariants through constructors or factories and preserve them through operations. Keep representation conversions in the relevant type or boundary mapper. Do not revalidate already validated domain values in trusted internal calls.
- Use cases accept application/domain inputs, orchestrate domain behavior, and produce application/domain results. Keep HTTP objects, status codes, CLI formatting, and persistence models outside use cases.
- Abstract every persistence dependency used by the domain behind an interface defined by the domain's needs. Implement it outside the domain.
- Abstract services with interchangeable techniques or providers behind interfaces defined by their consumers. Add other interfaces or layers only when they serve a clear responsibility.
- Controllers validate and map external inputs into use-case commands or queries. Controllers or presenters map results and errors into the caller's representation; separate presenters when complexity, reuse, or multiple interfaces justify them.
- Assemble concrete implementations, configuration, and dependency injection in the composition root, such as bootstrap code or NestJS modules.
- Make business rules testable without a server, database, UI, or external service.
- Required domain boundaries and validated domain types take priority over avoiding layers or primitive wrappers.
- Use C4 diagrams when architectural documentation would help, at the level needed for the task.

## Code quality and behavior

- Extract long conditional expressions into meaningfully named variables, then check those variables in conditionals so the calling code expresses intent.

- Prefer straightforward, explicit code over clever tricks, dense expressions, or obscure language features when these make the code harder to understand or maintain.
- Keep related data, invariants, and behavior together. Expose cohesive interfaces and hide implementation details; objects and modules are both acceptable.
- Prefer composition. Use inheritance only when the subtype preserves the complete parent behavioral contract.
- Use precise domain names, cohesive functions, consistent abstraction levels, and explicit effects. Write comments for rationale, constraints, and non-obvious decisions.
- Group semantically cohesive blocks of code into clearly named methods or functions when doing so makes the calling code read like clear prose. Choose names that express intent and keep each extracted operation at a consistent level of abstraction. In particular, extract cohesive validation blocks into named methods or functions such as `ensureItemDataIsValid` and `ensureItemPriceIsValid`.
- Keep decisions near the data they govern. Expose useful queries without letting callers bypass invariants.
- Avoid duplicating rules or decisions that must change together. Similar syntax alone does not justify a shared abstraction.
- Keep simple conditionals when clear. Use strategies or polymorphism when real variation warrants them; do not introduce classes merely to eliminate branching.
- Examine boolean arguments that switch between operations; prefer explicit operations or meaningful domain types when clearer.
- Prefer immutable values and pure operations where practical. Avoid hidden side effects and coordinate shared mutable state when concurrency is necessary.
- Keep touched code clear and idiomatic. Include small related cleanup only when low risk; propose broader refactoring separately.

## Errors and logging

- Use identifiable application/domain errors for meaningful failures, following repository conventions. Introduce shared hierarchies only when they help callers distinguish failures.
- Translate vendor-specific failures at infrastructure boundaries, preserving original causes and safe diagnostic context.
- Treat caught values as `unknown` and narrow them before accessing properties.
- Map errors into caller representations at the presentation boundary. Keep infrastructure internals and sensitive data out of client-facing errors.
- Use the existing structured logger with stable messages and dynamic values in metadata. Keep metadata keys consistent across related operations.
- Log enough to explain failures and significant decisions, following the shared security reference's data minimization and redaction requirements.
