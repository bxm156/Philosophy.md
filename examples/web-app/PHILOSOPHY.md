# Project Philosophy: E-Commerce SaaS Platform

> A Next.js/React e-commerce platform demonstrating practical application of coding philosophies

## Overview

This document defines the coding philosophy for our e-commerce SaaS platform. It synthesizes principles from established software philosophies and adapts them to our specific context: a customer-facing web application that prioritizes user experience, reliability, and developer velocity.

**Tech Stack**: Next.js 14, React, TypeScript, PostgreSQL, Prisma, TailwindCSS, Vercel

**Team Size**: 5 engineers

**Business Context**: B2B SaaS with 1,000+ stores, 100k+ transactions/day

---

## Our Core Philosophy

We blend principles from multiple philosophies to create a pragmatic approach:

- **[Clean Code](../../philosophies/methodologies/CLEAN_CODE.PHILOSOPHY.md)** - For maintainability and readability
- **[Test-Driven Development](../../philosophies/methodologies/TDD.PHILOSOPHY.md)** - For critical business logic
- **[Functional Programming](../../philosophies/methodologies/FUNCTIONAL_PROGRAMMING.PHILOSOPHY.md)** - For predictability and testing
- **[Martin Fowler's Refactoring](../../philosophies/people/MARTIN_FOWLER.PHILOSOPHY.md)** - For evolutionary design
- **[Rust's Explicitness](../../philosophies/languages/RUST.PHILOSOPHY.md)** - Adapted for TypeScript

**Our Philosophy Statement**: *"We write code that humans read first, computers execute second. We test rigorously what matters, refactor continuously what doesn't work, and ship incrementally what users need."*

---

## 1. TypeScript: Explicit Over Implicit

**Why**: Inspired by Rust's philosophy of making costs and behaviors visible. TypeScript enables compile-time safety for JavaScript.

### Our Rules

```typescript
// ❌ Implicit any - forbidden
function processOrder(order) {  // Implicit any
  return order.total * 1.1;
}

// ✅ Explicit types - required
interface Order {
  id: string;
  items: OrderItem[];
  subtotal: number;
  tax: number;
  total: number;
}

function calculateTotal(order: Order): number {
  return order.subtotal + order.tax;
}

// ✅ Explicit error handling - use Result type
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function createOrder(
  items: CartItem[]
): Promise<Result<Order>> {
  try {
    // Validation
    if (items.length === 0) {
      return {
        success: false,
        error: new Error("Cart is empty")
      };
    }

    // Business logic
    const order = await db.order.create({
      data: {
        items: items.map(item => ({
          productId: item.productId,
          quantity: item.quantity,
          price: item.price
        }))
      }
    });

    return { success: true, data: order };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error : new Error("Unknown error")
    };
  }
}

// Usage: Explicit error handling
const result = await createOrder(cartItems);
if (!result.success) {
  console.error("Order creation failed:", result.error);
  return;
}
const order = result.data;
```

**Reference**: [Rust Language Philosophy](../../philosophies/languages/RUST.PHILOSOPHY.md#4-explicit-over-implicit)

---

## 2. Component Design: Pure and Testable

**Why**: Influenced by functional programming principles - pure functions are predictable and easy to test.

### Our Rules

```typescript
// ❌ Impure component with side effects
function ProductCard({ productId }: { productId: string }) {
  const [product, setProduct] = useState<Product | null>(null);

  useEffect(() => {
    // Side effect inside component
    fetch(`/api/products/${productId}`)
      .then(res => res.json())
      .then(setProduct);
  }, [productId]);

  if (!product) return <div>Loading...</div>;

  return <div>{product.name}</div>;
}

// ✅ Pure component with dependencies injected
interface ProductCardProps {
  product: Product;
  onAddToCart: (product: Product) => void;
}

function ProductCard({ product, onAddToCart }: ProductCardProps) {
  return (
    <div className="product-card">
      <h3>{product.name}</h3>
      <p className="price">${product.price.toFixed(2)}</p>
      <button onClick={() => onAddToCart(product)}>
        Add to Cart
      </button>
    </div>
  );
}

// Container handles side effects
function ProductCardContainer({ productId }: { productId: string }) {
  const { data: product, isLoading } = useQuery(
    ['product', productId],
    () => fetchProduct(productId)
  );
  const { mutate: addToCart } = useMutation(addProductToCart);

  if (isLoading) return <ProductCardSkeleton />;
  if (!product) return <ProductNotFound />;

  return <ProductCard product={product} onAddToCart={addToCart} />;
}
```

**Benefits**:
- Pure components are trivial to test (no mocking needed)
- Easy to reason about (no hidden dependencies)
- Reusable (not tied to data fetching)

**Reference**: [Functional Programming Philosophy](../../philosophies/methodologies/FUNCTIONAL_PROGRAMMING.PHILOSOPHY.md#1-pure-functions)

---

## 3. Test Strategy: Pragmatic TDD

**Why**: Following Kent Beck's TDD philosophy, but adapted for web development realities.

### What We Test

```typescript
// ✅ ALWAYS test: Business logic and calculations
describe('Order calculations', () => {
  it('calculates total with tax correctly', () => {
    const order = {
      subtotal: 100,
      taxRate: 0.08
    };

    expect(calculateOrderTotal(order)).toBe(108);
  });

  it('applies discount before calculating tax', () => {
    const order = {
      subtotal: 100,
      discount: 10,
      taxRate: 0.08
    };

    // (100 - 10) * 1.08 = 97.20
    expect(calculateOrderTotal(order)).toBe(97.20);
  });
});

// ✅ ALWAYS test: Data transformations
describe('formatOrderForAPI', () => {
  it('converts cart items to API format', () => {
    const cartItems: CartItem[] = [
      { productId: 'p1', quantity: 2, price: 10 }
    ];

    const apiFormat = formatOrderForAPI(cartItems);

    expect(apiFormat).toEqual({
      items: [{ product_id: 'p1', qty: 2, unit_price: 10 }]
    });
  });
});

// ✅ TEST: Critical user flows (integration tests)
describe('Checkout flow', () => {
  it('creates order and charges customer', async () => {
    // Arrange
    const cart = await createTestCart();
    const customer = await createTestCustomer();

    // Act
    const result = await checkout(cart, customer);

    // Assert
    expect(result.success).toBe(true);
    expect(result.order.status).toBe('paid');

    // Verify side effects
    const dbOrder = await db.order.findUnique({
      where: { id: result.order.id }
    });
    expect(dbOrder).toBeDefined();
  });
});

// ❌ DON'T test: Simple React components (use visual testing instead)
// We use Storybook for component testing, not Jest

// ❌ DON'T test: Third-party library behavior
// Trust that Stripe, Prisma, etc. test their own code

// ⚠️ MOCK: External services only
jest.mock('@/lib/stripe', () => ({
  createPaymentIntent: jest.fn().mockResolvedValue({
    id: 'pi_test',
    status: 'succeeded'
  })
}));
```

**Our TDD Approach**:
1. **Business logic**: Write tests first (strict TDD)
2. **API endpoints**: Write tests alongside implementation (test-driven)
3. **UI components**: Write tests after (test-supported)
4. **Prototypes**: No tests until proven valuable

**Reference**: [TDD Philosophy](../../philosophies/methodologies/TDD.PHILOSOPHY.md)

---

## 4. Refactoring: Continuous Improvement

**Why**: Martin Fowler's philosophy - refactor continuously in small steps.

### Our Refactoring Rhythm

```typescript
// Week 1: Working but messy
function processCheckout(cart, customer, paymentMethod) {
  // 150 lines of mixed validation, calculation, and side effects
  // Works but hard to test and understand
}

// Week 2: Extract validation
function validateCheckout(cart, customer, paymentMethod) {
  if (cart.items.length === 0) throw new Error("Empty cart");
  if (!customer.email) throw new Error("No email");
  // ... more validation
}

function processCheckout(cart, customer, paymentMethod) {
  validateCheckout(cart, customer, paymentMethod);
  // 130 lines - slightly better
}

// Week 3: Extract calculation
function calculateOrderTotals(cart) {
  const subtotal = cart.items.reduce((sum, item) =>
    sum + (item.price * item.quantity), 0
  );
  const tax = subtotal * cart.taxRate;
  const total = subtotal + tax;
  return { subtotal, tax, total };
}

// Week 4: Extract side effects
async function createOrderRecord(cart, customer, totals) {
  return await db.order.create({
    data: {
      customerId: customer.id,
      ...totals,
      items: { create: cart.items }
    }
  });
}

async function chargeCustomer(paymentMethod, amount) {
  return await stripe.paymentIntents.create({
    amount: Math.round(amount * 100),
    currency: 'usd',
    payment_method: paymentMethod
  });
}

// Final: Orchestration function
async function processCheckout(
  cart: Cart,
  customer: Customer,
  paymentMethod: string
): Promise<Result<Order>> {
  // Validate
  validateCheckout(cart, customer, paymentMethod);

  // Calculate
  const totals = calculateOrderTotals(cart);

  // Process payment
  const payment = await chargeCustomer(paymentMethod, totals.total);
  if (!payment.success) {
    return { success: false, error: payment.error };
  }

  // Create order
  const order = await createOrderRecord(cart, customer, totals);

  return { success: true, data: order };
}
```

**Refactoring Rules**:
1. **Red-Green-Refactor**: Tests pass before and after
2. **Small steps**: One refactoring at a time
3. **Continuous**: Don't wait for "refactoring week"
4. **Boy Scout Rule**: Leave code cleaner than you found it

**Reference**: [Martin Fowler Philosophy](../../philosophies/people/MARTIN_FOWLER.PHILOSOPHY.md#1-refactoring-is-essential)

---

## 5. Performance: Measure First, Optimize Second

**Why**: Donald Knuth's wisdom - "Premature optimization is the root of all evil."

### Our Performance Approach

```typescript
// ❌ Premature optimization
function ProductList({ products }: { products: Product[] }) {
  // Don't optimize before measuring!
  const memoizedProducts = useMemo(() => {
    return products.map(p => ({
      ...p,
      displayPrice: formatPrice(p.price)
    }));
  }, [products]);

  // Unnecessary complexity for likely no benefit
}

// ✅ Start simple
function ProductList({ products }: { products: Product[] }) {
  return (
    <div className="grid grid-cols-3 gap-4">
      {products.map(product => (
        <ProductCard key={product.id} product={product} />
      ))}
    </div>
  );
}

// ✅ Measure with real data
// User complaint: "Product page loads slowly with 1000+ products"

// Step 1: Add performance monitoring
function ProductList({ products }: { products: Product[] }) {
  useEffect(() => {
    performance.mark('product-list-render-start');
    return () => {
      performance.mark('product-list-render-end');
      performance.measure(
        'product-list-render',
        'product-list-render-start',
        'product-list-render-end'
      );
    };
  }, [products]);

  // ... rest of component
}

// Step 2: Identify bottleneck
// Result: Rendering 1000 ProductCard components takes 2.3s

// Step 3: Optimize the critical path
import { Virtuoso } from 'react-virtuoso';

function ProductList({ products }: { products: Product[] }) {
  return (
    <Virtuoso
      data={products}
      itemContent={(index, product) => (
        <ProductCard key={product.id} product={product} />
      )}
      style={{ height: '100vh' }}
    />
  );
}

// Result: Now renders only visible items (~20), time reduced to 0.1s
```

**Our Performance Budget**:
- **First Contentful Paint**: < 1.5s
- **Largest Contentful Paint**: < 2.5s
- **Time to Interactive**: < 3.5s
- **API Response Time**: < 200ms (p95)

**When We Optimize**:
1. **After** measuring shows a problem
2. **When** users complain
3. **If** metrics exceed budget

**Reference**: [Donald Knuth Philosophy](../../philosophies/people/DONALD_KNUTH.PHILOSOPHY.md#2-premature-optimization)

---

## 6. Code Organization: Layered Architecture

**Why**: Martin Fowler's enterprise patterns - separation of concerns for maintainability.

### Our Layer Structure

```
src/
├── app/                    # Next.js App Router (Presentation Layer)
│   ├── (shop)/
│   │   ├── products/
│   │   │   └── [id]/
│   │   │       └── page.tsx
│   │   └── checkout/
│   │       └── page.tsx
│   └── api/                # API Routes (Controller Layer)
│       └── orders/
│           └── route.ts
├── components/             # UI Components (Presentation)
│   ├── ProductCard.tsx
│   └── CheckoutForm.tsx
├── lib/                    # Business Logic (Domain Layer)
│   ├── orders/
│   │   ├── orderService.ts
│   │   ├── orderCalculations.ts
│   │   └── orderValidation.ts
│   └── payments/
│       └── paymentService.ts
└── db/                     # Data Access (Persistence Layer)
    ├── repositories/
    │   ├── orderRepository.ts
    │   └── productRepository.ts
    └── schema.prisma
```

### Layer Rules

```typescript
// ❌ BAD: Business logic in React component
function CheckoutPage() {
  const [cart, setCart] = useState<Cart>();

  const handleCheckout = async () => {
    // Don't put business logic here!
    const subtotal = cart.items.reduce((sum, item) =>
      sum + item.price * item.quantity, 0
    );
    const tax = subtotal * 0.08;

    await fetch('/api/orders', {
      method: 'POST',
      body: JSON.stringify({ cart, subtotal, tax })
    });
  };

  return <button onClick={handleCheckout}>Checkout</button>;
}

// ✅ GOOD: Layered architecture

// Domain Layer (lib/orders/orderService.ts)
export async function processOrder(
  cart: Cart,
  customer: Customer
): Promise<Result<Order>> {
  // All business logic here
  const validation = validateOrder(cart, customer);
  if (!validation.success) return validation;

  const totals = calculateOrderTotals(cart);
  const order = await createOrder(cart, customer, totals);

  return { success: true, data: order };
}

// Controller Layer (app/api/orders/route.ts)
export async function POST(request: Request) {
  const { cartId, customerId } = await request.json();

  // Fetch data
  const cart = await getCart(cartId);
  const customer = await getCustomer(customerId);

  // Call service
  const result = await processOrder(cart, customer);

  if (!result.success) {
    return NextResponse.json(
      { error: result.error.message },
      { status: 400 }
    );
  }

  return NextResponse.json(result.data);
}

// Presentation Layer (app/checkout/page.tsx)
function CheckoutPage() {
  const { mutate: checkout, isLoading } = useMutation(
    async () => {
      const response = await fetch('/api/orders', {
        method: 'POST',
        body: JSON.stringify({
          cartId: cart.id,
          customerId: user.id
        })
      });

      if (!response.ok) throw new Error('Checkout failed');
      return response.json();
    }
  );

  return (
    <button onClick={() => checkout()} disabled={isLoading}>
      {isLoading ? 'Processing...' : 'Complete Order'}
    </button>
  );
}
```

**Benefits**:
- Business logic testable without HTTP or React
- Components are simple and focused
- Easy to change persistence layer
- Clear dependencies between layers

**Reference**: [Martin Fowler Philosophy](../../philosophies/people/MARTIN_FOWLER.PHILOSOPHY.md#5-layered-architecture)

---

## 7. Error Handling: Make Errors Explicit

**Why**: Rust's philosophy of explicit error handling prevents silent failures.

### Our Error Strategy

```typescript
// ❌ Hidden errors
async function getProduct(id: string) {
  try {
    const product = await db.product.findUnique({ where: { id } });
    return product;  // Returns null if not found - easy to miss!
  } catch (error) {
    console.error(error);  // Swallowed error
    return null;
  }
}

// ✅ Explicit errors with Result type
type Result<T, E = Error> =
  | { success: true; data: T }
  | { success: false; error: E };

async function getProduct(id: string): Promise<Result<Product>> {
  try {
    const product = await db.product.findUnique({ where: { id } });

    if (!product) {
      return {
        success: false,
        error: new Error(`Product ${id} not found`)
      };
    }

    return { success: true, data: product };
  } catch (error) {
    return {
      success: false,
      error: error instanceof Error ? error : new Error('Database error')
    };
  }
}

// Usage forces error handling
const result = await getProduct(productId);

if (!result.success) {
  // Must handle error
  console.error(result.error);
  return <ProductNotFound />;
}

// TypeScript knows result.data is Product
const product = result.data;
```

### Custom Error Types

```typescript
// Define domain errors
class OrderError extends Error {
  constructor(
    message: string,
    public code: 'EMPTY_CART' | 'INVALID_PAYMENT' | 'OUT_OF_STOCK'
  ) {
    super(message);
    this.name = 'OrderError';
  }
}

// Use in business logic
function validateCart(cart: Cart): Result<void, OrderError> {
  if (cart.items.length === 0) {
    return {
      success: false,
      error: new OrderError('Cart is empty', 'EMPTY_CART')
    };
  }

  const outOfStock = cart.items.find(item => item.quantity > item.stock);
  if (outOfStock) {
    return {
      success: false,
      error: new OrderError(
        `${outOfStock.name} is out of stock`,
        'OUT_OF_STOCK'
      )
    };
  }

  return { success: true, data: undefined };
}

// Handle errors specifically
const validation = validateCart(cart);
if (!validation.success) {
  switch (validation.error.code) {
    case 'EMPTY_CART':
      return <EmptyCartMessage />;
    case 'OUT_OF_STOCK':
      return <OutOfStockError product={outOfStock} />;
    default:
      return <GenericError />;
  }
}
```

**Reference**: [Rust Language Philosophy](../../philosophies/languages/RUST.PHILOSOPHY.md#4-explicit-over-implicit)

---

## 8. Documentation: Why, Not What

**Why**: Donald Knuth's principle - document reasoning, not mechanics.

### Our Documentation Style

```typescript
// ❌ BAD: Comments repeat code
// Get the user
const user = await getUser(userId);

// Check if user exists
if (!user) {
  // Return error
  return { error: 'User not found' };
}

// ✅ GOOD: Comments explain why
// We fetch user here (not in middleware) because checkout
// requires fresh user data to verify email and payment methods.
// Middleware caches user for 5min, which is too stale.
const user = await getUser(userId);

if (!user) {
  // This shouldn't happen if auth middleware is working,
  // but we check anyway because checkout is a critical path
  // and we want to fail safely.
  logger.error('Authenticated user not found in database', { userId });
  return { error: 'User not found' };
}

// ✅ GOOD: Explain tricky business rules
function calculateShipping(order: Order): number {
  // Free shipping for orders over $50, except for:
  // 1. Alaska/Hawaii (always $15 due to carrier costs)
  // 2. Heavy items over 50lbs (actual weight-based pricing)
  // 3. Marketplace items (seller sets shipping)

  if (order.subtotal >= 50 && !hasExceptions(order)) {
    return 0;
  }

  if (isAlaskaOrHawaii(order.shippingAddress)) {
    return 15;
  }

  // ... rest of logic
}

// ✅ GOOD: Document architectural decisions
/**
 * We use optimistic locking for order updates to prevent race conditions.
 *
 * Race condition scenario:
 * 1. Admin views order (status: pending, version: 1)
 * 2. Customer cancels order (status: cancelled, version: 2)
 * 3. Admin approves order (status: approved, version: 2) ❌
 *
 * With version checking, step 3 would fail because version mismatch,
 * forcing admin to refresh and see current state.
 */
async function updateOrder(
  orderId: string,
  updates: Partial<Order>,
  expectedVersion: number
): Promise<Result<Order>> {
  const order = await db.order.findUnique({ where: { id: orderId } });

  if (order.version !== expectedVersion) {
    return {
      success: false,
      error: new Error('Order was modified by another user')
    };
  }

  return db.order.update({
    where: { id: orderId, version: expectedVersion },
    data: { ...updates, version: expectedVersion + 1 }
  });
}
```

**Reference**: [Donald Knuth Philosophy](../../philosophies/people/DONALD_KNUTH.PHILOSOPHY.md#6-document-the-why)

---

## 9. Naming: Reveal Intent

**Why**: Clean Code principle - names should reveal intent without comments.

### Our Naming Conventions

```typescript
// ❌ BAD: Unclear names
const d = new Date();
const t = calculateTotal(o);
function proc(data) { }
const flag = checkUser(u);

// ✅ GOOD: Self-documenting names
const orderCreatedAt = new Date();
const orderTotalWithTax = calculateTotal(order);
function processPayment(paymentIntent: PaymentIntent) { }
const isUserEligibleForDiscount = checkUserDiscountEligibility(user);

// ✅ GOOD: Meaningful variable names
// Before
const x = products.filter(p => p.price < 20);

// After
const affordableProducts = products.filter(
  product => product.price < BUDGET_THRESHOLD
);

// ✅ GOOD: Function names describe what they do
// Before
function check(order) {
  return order.items.length > 0 && order.total > 0;
}

// After
function isValidOrder(order: Order): boolean {
  return order.items.length > 0 && order.total > 0;
}

// ✅ GOOD: Boolean names are questions
const isUserLoggedIn = !!user;
const hasActiveSubscription = subscription?.status === 'active';
const canUserCheckout = isUserLoggedIn && hasActiveSubscription;
const shouldShowDiscount = canUserCheckout && isEligibleForDiscount;
```

**Naming Rules**:
- Variables: Nouns (`user`, `orderTotal`)
- Functions: Verbs (`calculateTotal`, `validateOrder`)
- Booleans: Questions (`isValid`, `hasPermission`, `canAccess`)
- Constants: SCREAMING_SNAKE_CASE (`MAX_CART_ITEMS`)
- Types/Interfaces: PascalCase (`Order`, `PaymentIntent`)

**Reference**: [Clean Code Philosophy](../../philosophies/methodologies/CLEAN_CODE.PHILOSOPHY.md)

---

## 10. Git Workflow: Ship Small, Ship Often

**Why**: Continuous integration philosophy - small changes reduce risk.

### Our Commit Strategy

```bash
# ❌ BAD: Monolithic commits
git commit -m "Updated checkout"
# Changes: 47 files, +2,341 −1,893 lines

# ✅ GOOD: Atomic commits
git commit -m "feat(checkout): Add order validation"
# Changes: 2 files, +34 −0 lines

git commit -m "feat(checkout): Extract tax calculation logic"
# Changes: 3 files, +45 −12 lines

git commit -m "feat(checkout): Integrate Stripe payment"
# Changes: 4 files, +89 −3 lines

git commit -m "test(checkout): Add checkout flow integration tests"
# Changes: 1 file, +156 −0 lines

git commit -m "docs(checkout): Document payment error handling"
# Changes: 2 files, +78 −5 lines
```

### Branch Strategy

```bash
# Feature branches
main                          # Production-ready code
  └── staging                 # Pre-production testing
      └── feat/add-wishlist   # Feature branch (short-lived)
      └── fix/cart-bug        # Bug fix branch

# Workflow
1. Create branch: git checkout -b feat/add-wishlist
2. Make small commits (multiple per day)
3. Push frequently: git push origin feat/add-wishlist
4. Open PR when ready (even if WIP)
5. Deploy to preview: https://feat-add-wishlist.vercel.app
6. Review, iterate, merge to staging
7. Test on staging
8. Merge to main → auto-deploy to production
```

### Pull Request Size

```
✅ GOOD PR:
- 1-3 files changed
- +150 -50 lines
- Single concern
- Easy to review in 10 minutes

⚠️ ACCEPTABLE PR:
- 5-10 files changed
- +500 -200 lines
- Related changes
- Reviewable in 30 minutes

❌ TOO LARGE:
- 20+ files changed
- +1000 lines
- Multiple concerns
- Needs to be split
```

**Reference**: [Martin Fowler Philosophy](../../philosophies/people/MARTIN_FOWLER.PHILOSOPHY.md#6-continuous-integration)

---

## Trade-offs and Pragmatism

### When We Break Our Rules

**1. Prototypes and Experiments**
```typescript
// It's OK to skip tests and types for throwaway prototypes
// Just label them clearly and don't merge to main

// prototype/new-ui-idea/page.tsx
// ⚠️ PROTOTYPE CODE - NOT PRODUCTION READY
// TODO: Add types, tests, error handling before merging
```

**2. Tight Deadlines**
```typescript
// It's OK to accumulate tech debt for critical launches
// Just track it and pay it back within 2 weeks

// TODO(tech-debt): Refactor this after launch
// This is a quick fix for the Black Friday sale.
// Proper solution tracked in JIRA-1234
function applyBlackFridayDiscount(order: any) {
  // Hacky logic here
}
```

**3. Third-Party Limitations**
```typescript
// Sometimes external APIs force us to compromise
// Document why and isolate the mess

// Stripe webhooks use snake_case, we use camelCase
// We transform at the boundary to keep our domain clean
function handleStripeWebhook(event: Stripe.Event) {
  const order = transformStripeEventToOrder(event);
  return processOrder(order);
}
```

---

## AI Assistant Integration

This philosophy document integrates with AI coding assistants:

### .cursor/rules/typescript.md
```markdown
# TypeScript Rules

Follow the patterns in /PHILOSOPHY.md:
- Use explicit Result types for error handling
- Make all functions pure when possible
- Extract business logic from React components
- Follow layered architecture
```

### AGENTS.md
```markdown
# Coding Agents Configuration

When generating code:
1. Read /PHILOSOPHY.md first
2. Follow our testing strategy (TDD for business logic)
3. Use our naming conventions
4. Structure code according to our layers
```

---

## Continuous Learning

### Philosophy Evolution

This document is living and evolving:

**v1.0** (Initial) - Basic TypeScript and React patterns
**v1.1** (Month 2) - Added Result type pattern after too many uncaught errors
**v1.2** (Month 4) - Added performance budgets after slow checkout complaints
**v1.3** (Month 6) - Refined testing strategy based on what actually caught bugs
**v2.0** (Month 12) - Current version with layered architecture

### Team Feedback Loop

**Monthly Philosophy Review**:
1. What worked well?
2. What patterns caused problems?
3. What should we change?
4. What should we add?

**Recent Changes**:
- ✅ Added Result type (reduced production errors by 40%)
- ✅ Extracted business logic from components (doubled test coverage)
- ❌ Removed strict JSDoc requirement (too much overhead, TypeScript is enough)
- ⏳ Evaluating: Server Components vs Client Components strategy

---

## Summary Checklist

Before shipping any feature, verify:

- [ ] Business logic extracted to `lib/` layer
- [ ] Critical paths have tests
- [ ] Errors use Result type (no uncaught exceptions)
- [ ] TypeScript strict mode passing (no `any`, no `@ts-ignore`)
- [ ] Components are pure (side effects in containers)
- [ ] Performance measured (Lighthouse score > 90)
- [ ] Error handling explicit (no silent failures)
- [ ] Names reveal intent (readable without comments)
- [ ] PR is small (<500 lines)
- [ ] Why documented (complex logic explained)

---

## Further Reading

### Internal References
- [Clean Code Methodology](../../philosophies/methodologies/CLEAN_CODE.PHILOSOPHY.md)
- [Test-Driven Development](../../philosophies/methodologies/TDD.PHILOSOPHY.md)
- [Functional Programming Principles](../../philosophies/methodologies/FUNCTIONAL_PROGRAMMING.PHILOSOPHY.md)
- [Martin Fowler's Refactoring](../../philosophies/people/MARTIN_FOWLER.PHILOSOPHY.md)
- [Donald Knuth on Optimization](../../philosophies/people/DONALD_KNUTH.PHILOSOPHY.md)
- [Rust Language Philosophy](../../philosophies/languages/RUST.PHILOSOPHY.md)

### External Resources
- [Next.js Best Practices](https://nextjs.org/docs)
- [TypeScript Handbook](https://www.typescriptlang.org/docs/)
- [React Server Components](https://react.dev/blog/2023/03/22/react-labs-what-we-have-been-working-on-march-2023#react-server-components)
- [Kent C. Dodds - Testing Library](https://testing-library.com/docs/guiding-principles/)

---

**Last Updated**: 2025-11-15
**Next Review**: 2025-12-15
**Maintainers**: Engineering Team
**Feedback**: #engineering-practices Slack channel
