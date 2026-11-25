# Production code worked examples

These examples illustrate `engineering.md`. Read the relevant examples before
implementing production code. Follow `security.md` for detailed security controls
and `testing.md` for verification. Repository inspection, convention approval,
public contracts, and scope requirements still apply.

TypeScript syntax, names, paths, supported values, and business rules below are
illustrative. Match the target repository's language, formatting, error types,
dependency injection, and file placement. Excerpts may refer to existing types or
collaborators whose definitions are omitted. Do not introduce all these patterns
for every task or treat an example's business rule as a production requirement.

## Organize code by business capability

When establishing a new structure, make the business capabilities visible:

```text
src/
  types/
    ReturnLabel.ts
    Refund.ts
  returns/
    use-cases/fetch-return-label.use-case.ts
    http/controllers/fetch-return-label.controller.ts
    http/dto/fetch-return-label-request.dto.ts
    http/dto/fetch-return-label-response.dto.ts
    cli/fetch-return-label.command.ts
    persistence/return-label.repository.ts
    persistence/implementation/mongo-return-label.repository.ts
    persistence/implementation/return-label.schema.ts
  refunds/
    use-cases/issue-refund.use-case.ts
    http/controllers/issue-refund.controller.ts
  infrastructure/
    logging/
  bootstrap/
```

This groups each capability's behavior and adapters together. A carrier adapter
used only by returns belongs with returns even though it performs HTTP calls.
Application composition can know the concrete implementations; domain code must
not import bootstrap, HTTP, database, or framework details.

For a focused change in an existing repository, use its established placement.
Do not reorganize top-level `controllers`, `services`, or `repositories` folders
as incidental cleanup. If a required boundary conflicts with the existing
pattern, explain the conflict and obtain the required decision before proceeding.

## Convert external values into validated domain concepts

Avoid aliases that allow any string and casts that bypass validation:

```typescript
type Tenant = string;
const tenant = body.tenant as Tenant;
```

Prefer one validated construction path and one source of supported values:

```typescript
const supportedTenants = ['at', 'be', 'com'] as const;
type TenantCode = (typeof supportedTenants)[number];
declare const tenantBrand: unique symbol;
export type Tenant = TenantCode & { readonly [tenantBrand]: true };

export class InvalidTenantError extends Error {
  public constructor() {
    super('Unsupported tenant');
  }
}

export function tenantFrom(value: unknown): Tenant {
  const isSupportedTenant =
    typeof value === 'string' &&
    supportedTenants.some(tenant => tenant === value);

  if (!isSupportedTenant) {
    throw new InvalidTenantError();
  }

  return value as Tenant;
}
```

The assertion is confined to the validating factory. Callers use `tenantFrom`;
they do not cast arbitrary strings to `Tenant`. A class value object is equally
appropriate when that is the repository convention. A brand provides compile-time
distinction, while the factory supplies runtime validation; neither authenticates
the caller or proves their right to access a tenant.

Use the actual supported set and accepted representation. Do not silently trim,
lowercase, or choose a default unless the contract requires it. Do not maintain a
second independently written tenant allowlist elsewhere.

## Establish invariants at construction and preserve them through operations

Suppose a quantity must be a positive safe integer. Avoid mutating or repairing
it in a getter:

```typescript
public asNumber(): number {
  this.value = Math.floor(this.value);
  return this.value;
}
```

Prefer construction that rejects invalid values and operations that return valid
new values:

```typescript
export class InvalidQuantityError extends Error {
  public constructor() {
    super('Quantity must be a positive safe integer');
  }
}

export class Quantity {
  private constructor(private readonly value: number) {}

  public static from(value: unknown): Quantity {
    const isValidQuantity =
      typeof value === 'number' &&
      Number.isSafeInteger(value) &&
      value > 0;

    if (!isValidQuantity) {
      throw new InvalidQuantityError();
    }

    return new Quantity(value);
  }

  public add(other: Quantity): Quantity {
    return Quantity.from(this.value + other.value);
  }

  public asNumber(): number {
    return this.value;
  }
}
```

`Quantity.from(2.5)`, zero, negative numbers, `NaN`, and infinity are rejected.
Addition also checks its new result, including overflow beyond safe integers.
This preserves an invariant; it does not repeat validation of either trusted
operand. Reading the value never changes later calculations, and adding returns
a new value without changing either operand.

Use the actual quantity contract. Money additionally needs explicit units,
currency, precision, and rounding rules; do not copy this numeric representation
into monetary arithmetic without resolving those requirements. Immutable local
values do not by themselves prevent concurrent database updates from being lost.

## Keep business decisions with the data they govern

Suppose an active label can be cancelled, repeat cancellation is idempotent, and
an expired label cannot be cancelled. Avoid making callers assemble this rule
from getters and unrestricted setters:

```typescript
if (label.getStatus() === 'expired') {
  throw new ExpiredLabelError();
}
label.setStatus('cancelled');
```

Prefer a domain operation that owns the transition:

```typescript
type LabelStatus = 'active' | 'cancelled' | 'expired';

class ReturnLabel {
  // Construction and persistence reconstitution validate their own inputs.
  private constructor(private status: LabelStatus) {}

  public cancel(): void {
    if (this.status === 'cancelled') {
      return;
    }
    if (this.status === 'expired') {
      throw new ExpiredLabelError();
    }
    this.status = 'cancelled';
  }
}

// Inside the application use case:
label.cancel();
await this.labels.save(label);
```

The use case orchestrates persistence while the entity owns its transition.
Domain queries are still useful; do not replace every getter with a command or
forbid plain DTOs and persistence records. Keep those external representations
separate from domain behavior. Follow the actual lifecycle and duplicate-handling
contract, including any concurrency controls required by persistence.

## Keep use cases independent of HTTP and persistence formats

Avoid passing request/response objects into use cases or exposing database
records from their dependencies:

```typescript
async execute(req: Request, res: Response): Promise<void> {
  const record = await this.mongoCollection.findOne({ _id: req.params.id });
  res.status(200).json(record);
}
```

Prefer application inputs, a consumer-owned persistence interface, and mapping
at the external boundaries. In this excerpt, ID types are validated domain
values, the actor comes from trusted authentication context, and the
repository's `findForCustomer` contract scopes the lookup by all three IDs:

```typescript
// Domain-facing port: no MongoDB types or HTTP response shapes.
interface ReturnLabelRepository {
  findForCustomer(
    tenant: Tenant,
    customerId: CustomerId,
    labelId: LabelId,
  ): Promise<ReturnLabel | null>;
}

interface FetchLabelQuery {
  tenant: Tenant;
  customerId: CustomerId;
  labelId: LabelId;
}

class FetchReturnLabel {
  public constructor(private readonly labels: ReturnLabelRepository) {}

  public async execute(query: FetchLabelQuery): Promise<ReturnLabel> {
    const label = await this.labels.findForCustomer(
      query.tenant,
      query.customerId,
      query.labelId,
    );
    if (label === null) {
      throw new LabelNotFoundError();
    }
    return label;
  }
}

// HTTP adapter excerpt, after authentication and request validation:
const label = await this.fetchReturnLabel.execute({
  tenant: actor.tenant,
  customerId: actor.customerId,
  labelId: LabelId.from(params.labelId),
});
return this.labelResponseMapper.toBody(label);
```

The persistence adapter constructs its filter from the validated IDs and maps
records into domain objects. It must honor the scoped lookup; a method name alone
does not enforce authorization. Never obtain the actor's identity or tenant from
arbitrary request-body fields or spread a raw request into a database query.

The controller or established presenter/filter maps errors and HTTP status codes.
A presenter is optional when a simple controller mapping suffices. Instantiate
and inject adapters in the repository's composition root; do not import concrete
MongoDB repositories into domain code or add a parallel DI mechanism.

## Name cohesive validation steps and complex decisions

Avoid mixing orchestration with several low-level checks:

```typescript
if (!item.productId || item.quantity <= 0 || !Number.isSafeInteger(item.quantity)) {
  throw new InvalidItemDataError();
}
if (item.priceInCents < 0 || !Number.isSafeInteger(item.priceInCents)) {
  throw new InvalidItemPriceError();
}
```

For a hypothetical external item schema, group the checks into named operations
in its boundary validator:

```typescript
function ensureItemIsValid(item: ItemInput): void {
  ensureItemDataIsValid(item);
  ensureItemPriceIsValid(item);
}

function ensureItemDataIsValid(item: ItemInput): void {
  const hasInvalidItemData =
    item.productId.length === 0 ||
    !Number.isSafeInteger(item.quantity) ||
    item.quantity <= 0;

  if (hasInvalidItemData) {
    throw new InvalidItemDataError();
  }
}

function ensureItemPriceIsValid(item: ItemInput): void {
  const hasInvalidPrice =
    !Number.isSafeInteger(item.priceInCents) || item.priceInCents < 0;

  if (hasInvalidPrice) {
    throw new InvalidItemPriceError();
  }
}
```

Here `ItemInput` has already passed runtime shape and size validation; TypeScript
annotations alone do not establish that. Reuse the relevant value-object factory
for invariants it already owns rather than duplicating those rules in a real
validator. A boundary validator can coordinate those factories and checks across
fields, then return validated application/domain inputs.

Extract cohesive blocks that clarify intent. Keep a simple check such as
`if (label === null)` inline. Do not add trivial forwarding functions or wrappers
around every line to achieve an arbitrary function length.

## Make distinct operations explicit

Avoid a boolean flag that hides which operation will happen:

```typescript
await labelService.process(labelId, true);
```

Prefer names that expose the operation:

```typescript
await labelService.cancel(labelId);
await labelService.regenerate(labelId);
```

Each call represents an alternative caller intent; this is not an instruction to
invoke both. Share cohesive internal steps where useful. A boolean describing
actual domain state, such as `hasVoucher`, is not automatically a design defect.
Keep clear conditionals for small decisions; introduce strategies for existing
behavioral variation, rather than eliminating every `if`.

## Compose narrow dependencies and centralize real provider variation

When several carriers really use interchangeable implementations, avoid repeating
carrier branches across creation, error handling, and metrics. Define the
operations needed by the consumer:

```typescript
interface CarrierMetrics {
  labelCreated(): void;
  labelCreationFailed(): void;
}

class CarrierMetricsSelector {
  public constructor(
    private readonly dhl: CarrierMetrics,
    private readonly bpost: CarrierMetrics,
  ) {}

  public forCarrier(carrier: CarrierId): CarrierMetrics {
    if (carrier.isDhl()) {
      return this.dhl;
    }
    if (carrier.isBpost()) {
      return this.bpost;
    }
    throw new UnsupportedCarrierError();
  }
}

// Application orchestration excerpt. Metrics operations here are non-throwing.
const metrics = this.metricsSelector.forCarrier(command.carrierId);
let label: ReturnLabel;
try {
  label = await this.carrier.createLabel(command);
} catch (cause: unknown) {
  metrics.labelCreationFailed();
  throw cause;
}
metrics.labelCreated();
return label;
```

Selection happens once; unsupported carriers are rejected before the provider
call, and `metrics` is available in both success and failure paths. The concrete
provider translates its own vendor errors at the infrastructure boundary.
Keep the catch scoped to label creation so unrelated failures are not counted
as carrier failures. Honor the real observability failure policy; do not let a
throwing metric mask the original failure or turn completed work into an unsafe
retry.

The composition root supplies the concrete metrics implementations. A single
implementation with a carrier label may be simpler if only metric metadata
differs. A fetch-label consumer needing only `labelFetchFailed()` should receive
that narrow capability rather than an interface exposing broker, upload, and
every carrier's metrics. An implementation may satisfy several focused ports.

Use composition to reuse collaborators. Do not subclass a return item as an
external-provider record merely because their fields look similar; use an
explicit mapper or a containing object. Inheritance is appropriate only when
every inherited operation preserves the parent's behavioral contract.

## Translate failures at adapters and keep logging safe

Avoid leaking vendor errors into caller responses or serializing arbitrary
caught values into logs. Translate a dependency failure in the adapter:

```typescript
class LabelLookupFailedError extends Error {
  public constructor(cause: unknown) {
    super('Return label lookup failed', { cause });
  }
}

// Persistence adapter excerpt; mapping occurs outside this catch.
let record: LabelRecord | null;
try {
  record = await this.collection.findOne(filter);
} catch (cause: unknown) {
  throw new LabelLookupFailedError(cause);
}
return record === null ? null : this.mapper.toDomain(record);
```

This example uses standard `Error` cause support where available; use the
repository's equivalent otherwise. Preserve a thrown value as an internal cause
without assuming it is an `Error`. Narrow `unknown` before accessing properties.
Distinguish a successful lookup with no record from an unavailable database.
Use an existing identifiable error type where it fits; do not create a universal
base-error hierarchy just for this example or translate every programming defect
into a business failure.

At the presentation boundary, map the known failure to the established safe
response. At the established logging boundary, use a stable message and minimal,
consistent metadata through the existing logger:

```typescript
this.logger.error({
  message: 'Return label lookup failed',
  reason: 'label_lookup_failed',
  correlationId,
});
```

Use a safe, bounded correlation identifier supplied by established request
context. Do not interpolate dynamic IDs into the message or add raw requests,
authorization headers, customer objects, or arbitrary error causes as metadata.
Retain diagnostic causes internally; emit further diagnostic fields only through
the existing redaction and safe error-serialization policy. Avoid duplicate
logging at every layer.

## Share rules that change together and keep cleanup proportional

| Situation | Appropriate decision |
| --- | --- |
| A tenant enum and a separately handwritten validation list represent the same supported set | Derive validation and types from one source, as in the tenant example. |
| An HTTP item, a domain return item, and an external-provider record happen to have similar fields | Keep their contracts separate and map explicitly; do not make them inherit from one shared model solely to remove matching fields. |
| A touched function contains an unclear variable name | Improve it locally when this matches conventions and preserves behavior. |
| A small defect exposes a possible repository-wide folder or error-hierarchy redesign | Complete the bounded fix and propose the broader change separately. |
| An example uses classes but nearby production code uses cohesive modules and factories | Preserve the established style while applying the same boundary and invariant rules. |

Similarity of syntax does not establish one responsibility or one reason to
change. Neither the examples nor the boy scout rule authorize unrelated cleanup
or a convention departure.

## Source mapping and adaptations

| Examples | Source sections |
| --- | --- |
| Business capability organization and application boundaries | Architecture: Screaming Architecture, Layers separation, controller/presenter/interactor options, and The main component; Principles: Dependency inversion. |
| Validated domain types and immutable values | Coding: Primitive obsession and Avoid side effects; Principles: High cohesion and DRY. |
| Domain transitions and named validation steps | Coding: Data class, Tell don't ask, and Comments explaining the code; Principles: Don't mix different levels of abstraction. |
| Explicit operations, narrow ports, provider variation, and composition | Coding: Flag argument, Prefer polymorphism, and Prefer composition; Principles: Open/Closed, Interface segregation, and Liskov substitution. |
| Error translation and structured logging | Coding: Error handling and Logging, qualified by the current security and engineering standards. |
| Proportional cleanup and shared rules | Principles: DRY and Boy scout rule, qualified by current scope and convention requirements. |

The numeric example uses quantities to avoid the source money examples' unclear
units and conversions. The lifecycle example replaces the source's inconsistent
Money comparison and subtraction signatures. The metrics example fixes the
source's variable scope across `try` and `catch`. These are adaptations, not
verbatim source implementations.

The current standards govern choices where the PDFs are broader: prototypes
retain security obligations; cleanup stays within scope; clear conditionals are
allowed; domain/use-case outputs stay independent of HTTP view models; detailed
security controls remain in `security.md`.
