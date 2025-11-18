---
layout: default
title: Martin Fowler
parent: People
grand_parent: Philosophies
nav_order: 16
---

# Martin Fowler: Coding Philosophy

> Refactoring, Evolutionary Design, and Enterprise Patterns | Principles Over Tools

## Overview

Martin Fowler's philosophy centers on continuous improvement through refactoring, evolutionary design over big upfront design, and patterns as a shared vocabulary. As Chief Scientist at ThoughtWorks and author of seminal works on refactoring and enterprise architecture, Fowler has shaped modern software development practices.

## Core Principles

### 1. Refactoring as Essential Practice

**What**: Refactoring is the disciplined technique of restructuring code without changing its external behavior through small, safe transformations.

**Why**: "Creating software that has a good architecture isn't something that can be done first time; like good prose, it needs regular revisions as programmers learn more about what the product needs to do."

**Fowler's Refactoring Principles**:
- Each refactoring is small and safe
- Refactorings don't alter observable behavior
- Cumulative effect transforms design
- Essential for maintaining code health
- Continuous activity, not a phase

```python
# Before refactoring: Long method with multiple responsibilities
def process_order(order):
    # Validation
    if not order.items:
        raise ValueError("Empty order")
    if not order.customer:
        raise ValueError("No customer")

    # Calculate total
    total = 0
    for item in order.items:
        total += item.price * item.quantity

    # Apply discount
    if order.customer.premium:
        discount = total * 0.1
        total = total - discount

    # Tax calculation
    tax_rate = get_tax_rate(order.customer.state)
    tax = total * tax_rate
    total_with_tax = total + tax

    # Save to database
    db.orders.insert({
        'customer_id': order.customer.id,
        'total': total_with_tax,
        'items': [{'id': i.id, 'qty': i.quantity} for i in order.items]
    })

    # Send confirmation
    email_service.send(
        order.customer.email,
        "Order Confirmed",
        f"Your order total is ${total_with_tax}"
    )

    return total_with_tax

# After refactoring: Extract Method (first refactoring)
def process_order(order):
    validate_order(order)
    total = calculate_total(order)
    total_with_tax = add_tax(total, order.customer.state)
    save_order(order, total_with_tax)
    send_confirmation(order.customer, total_with_tax)
    return total_with_tax

def validate_order(order):
    if not order.items:
        raise ValueError("Empty order")
    if not order.customer:
        raise ValueError("No customer")

def calculate_total(order):
    subtotal = calculate_subtotal(order)
    return apply_discount(subtotal, order.customer)

def calculate_subtotal(order):
    return sum(item.price * item.quantity for item in order.items)

def apply_discount(amount, customer):
    if customer.premium:
        return amount * 0.9
    return amount

def add_tax(amount, state):
    tax_rate = get_tax_rate(state)
    return amount * (1 + tax_rate)

def save_order(order, total):
    db.orders.insert({
        'customer_id': order.customer.id,
        'total': total,
        'items': [{'id': i.id, 'qty': i.quantity} for i in order.items]
    })

def send_confirmation(customer, total):
    email_service.send(
        customer.email,
        "Order Confirmed",
        f"Your order total is ${total}"
    )

# Each function now has one responsibility
# Easy to test each piece
# Easy to reuse
# Easy to understand
```

**When to Refactor**:
- When adding a feature (make change easy, then make easy change)
- When fixing a bug (understand code first)
- During code review (opportunistic refactoring)
- Regularly, in small doses

**Trade-offs**:
- ✅ Improves design continuously
- ✅ Reduces technical debt
- ✅ Makes code easier to understand
- ⚠️ Takes time upfront
- ⚠️ Requires tests for safety

---

### 2. Evolutionary Design

**What**: Design emerges and improves over time rather than being fully specified upfront.

**Why**: Requirements change, understanding deepens, and technology evolves. Design should adapt.

**Fowler's Approach**:
1. Start simple
2. Build incrementally
3. Refactor as you learn
4. Let design evolve with understanding
5. Continuous improvement over big upfront design

```python
# Evolution of a payment system design

# Version 1: Simple start
class PaymentProcessor:
    def process(self, amount):
        # Direct credit card processing
        stripe.charge(amount)

# Version 2: Refactor when adding PayPal (Extract Method)
class PaymentProcessor:
    def process(self, amount, method):
        if method == 'credit_card':
            self.process_credit_card(amount)
        elif method == 'paypal':
            self.process_paypal(amount)

    def process_credit_card(self, amount):
        stripe.charge(amount)

    def process_paypal(self, amount):
        paypal.charge(amount)

# Version 3: Refactor when adding more methods (Strategy Pattern)
class PaymentStrategy:
    def charge(self, amount):
        raise NotImplementedError

class CreditCardStrategy(PaymentStrategy):
    def charge(self, amount):
        stripe.charge(amount)

class PayPalStrategy(PaymentStrategy):
    def charge(self, amount):
        paypal.charge(amount)

class BitcoinStrategy(PaymentStrategy):
    def charge(self, amount):
        bitcoin.charge(amount)

class PaymentProcessor:
    def __init__(self, strategy: PaymentStrategy):
        self.strategy = strategy

    def process(self, amount):
        self.strategy.charge(amount)

# Design evolved through refactoring as needs became clear
# Didn't need Strategy pattern on day 1
# Pattern emerged when it solved real problem
```

**Contrast with Waterfall**:
```
Big Upfront Design (BDUF):
- Design everything first
- Then implement
- Hard to change
- Requirements often wrong

Evolutionary Design:
- Design enough to start
- Implement and learn
- Refactor continuously
- Adapt to real requirements
```

---

### 3. Principles Over Tools

**What**: Focus on underlying principles rather than specific tools or technologies.

**Why**: "His focus on principles over tools equips developers to navigate uncertainty with confidence."

**Fowler's Insight**: Technologies change rapidly. Principles endure. Understanding why something works enables adapting to new contexts.

```python
# Principle: Separation of Concerns
# Tool 1: Django (Python)
# views.py
def user_list(request):
    users = User.objects.all()
    return render(request, 'users.html', {'users': users})

# models.py
class User(models.Model):
    name = models.CharField(max_length=100)
    email = models.EmailField()

# Tool 2: Express (JavaScript)
// routes.js
app.get('/users', async (req, res) => {
    const users = await User.findAll();
    res.render('users', { users });
});

// models.js
class User extends Model {}

# Tool 3: ASP.NET (C#)
// Controllers/UserController.cs
public IActionResult Index() {
    var users = _userRepository.GetAll();
    return View(users);
}

# Same principle (MVC, separation of concerns) in different tools
# Understanding principle enables using any tool
```

**Fowler's Pattern Catalog**: Documented patterns in Smalltalk (1990s), then Java, then JavaScript - same patterns, different languages. Principles transcend tools.

---

### 4. Patterns as Shared Vocabulary

**What**: Design patterns create a shared language for discussing software design.

**Why**: Improves team communication, makes design discussions precise, enables knowledge transfer.

**Fowler's Patterns**:

```python
# Repository Pattern (Data Access)
class UserRepository:
    """Mediates between domain and data mapping layers."""

    def find_by_id(self, user_id):
        row = db.query("SELECT * FROM users WHERE id = ?", user_id)
        return User.from_row(row)

    def save(self, user):
        if user.id:
            db.execute("UPDATE users SET name=?, email=? WHERE id=?",
                      user.name, user.email, user.id)
        else:
            user.id = db.execute("INSERT INTO users (name, email) VALUES (?, ?)",
                                user.name, user.email)

# Using the pattern:
# "We need a Repository for Users"
# Team instantly understands: abstraction over data access

# Unit of Work Pattern (Transaction Management)
class UnitOfWork:
    """Maintains list of objects affected by transaction."""

    def __init__(self):
        self.new_objects = []
        self.dirty_objects = []
        self.removed_objects = []

    def register_new(self, obj):
        self.new_objects.append(obj)

    def register_dirty(self, obj):
        if obj not in self.dirty_objects:
            self.dirty_objects.append(obj)

    def register_removed(self, obj):
        self.removed_objects.append(obj)

    def commit(self):
        with db.transaction():
            for obj in self.new_objects:
                db.insert(obj)
            for obj in self.dirty_objects:
                db.update(obj)
            for obj in self.removed_objects:
                db.delete(obj)
        self.clear()

# Service Layer Pattern (Business Logic)
class OrderService:
    """Defines application's boundary and operations."""

    def __init__(self, order_repo, inventory_service):
        self.order_repo = order_repo
        self.inventory_service = inventory_service

    def place_order(self, customer_id, items):
        # Business logic coordinated here
        order = Order(customer_id, items)
        self.inventory_service.reserve(items)
        self.order_repo.save(order)
        return order

# Team communication:
# "Let's put that logic in the Service Layer"
# "We need a Repository to access that data"
# "Use Unit of Work to manage this transaction"
# Patterns provide shared vocabulary
```

**Fowler's Warning**: "Don't use patterns for pattern's sake."

```python
# ❌ Bad: Premature pattern application
# Day 1 of project: "We need Abstract Factory!"
class AbstractUserFactory:
    def create_user(self):
        raise NotImplementedError

class ConcreteUserFactoryA(AbstractUserFactory):
    def create_user(self):
        return UserTypeA()

# Over-engineered for simple needs

# ✅ Good: Refactor to patterns when needed
# Start simple:
def create_user(name, email):
    return User(name, email)

# When complexity demands it, refactor to pattern:
# (e.g., when you need multiple user types, different creation logic, etc.)
```

---

### 5. Layered Architecture

**What**: Organize code in logical layers with clear dependencies.

**Why**: Separation of concerns, independent testing, technology substitution.

**Fowler's Classic Layers**:
```
┌─────────────────────────┐
│  Presentation Layer     │  UI, Controllers, Views
├─────────────────────────┤
│  Domain/Business Layer  │  Business Logic, Entities
├─────────────────────────┤
│  Data Source Layer      │  Database, External APIs
└─────────────────────────┘

Dependencies flow downward
Each layer depends only on layers below
```

**Implementation**:
```python
# Presentation Layer (Controllers)
class UserController:
    def __init__(self, user_service):
        self.user_service = user_service

    def create(self, request):
        name = request.form['name']
        email = request.form['email']
        user = self.user_service.create_user(name, email)
        return render('user_created.html', user=user)

# Domain Layer (Business Logic)
class UserService:
    def __init__(self, user_repository, email_service):
        self.user_repository = user_repository
        self.email_service = email_service

    def create_user(self, name, email):
        # Business rules here
        if not self.is_valid_email(email):
            raise InvalidEmailError()

        user = User(name, email)
        self.user_repository.save(user)
        self.email_service.send_welcome(user)
        return user

    def is_valid_email(self, email):
        # Business rule: email validation
        return '@' in email and '.' in email

# Data Source Layer (Repositories)
class UserRepository:
    def save(self, user):
        db.execute("INSERT INTO users (name, email) VALUES (?, ?)",
                  user.name, user.email)

    def find_by_email(self, email):
        row = db.query("SELECT * FROM users WHERE email = ?", email)
        return User.from_row(row) if row else None

# Benefits:
# - Change database without touching business logic
# - Change UI framework without touching domain
# - Test business logic without database
# - Clear separation of concerns
```

---

### 6. Continuous Integration

**What**: Integrate code frequently (at least daily) with automated builds and tests.

**Why**: Catch integration problems early, maintain always-releasable codebase.

**Fowler's CI Practices**:
1. Maintain single source repository
2. Automate the build
3. Make build self-testing
4. Everyone commits daily
5. Every commit triggers build
6. Fix broken builds immediately
7. Keep build fast
8. Test in production-like environment
9. Make it easy to get latest deliverable
10. Everyone can see results

```bash
# CI Pipeline (Fowler's principles applied)

# 1. Developer commits
git commit -m "Add user email validation"
git push origin main

# 2. CI server detects commit
# 3. Automated build
npm install
npm run build

# 4. Automated tests
npm test
npm run lint
npm run integration-test

# 5. If tests pass, deploy to staging
deploy-to-staging.sh

# 6. If tests fail, notify team immediately
# Everyone stops to fix build

# Benefits:
# - Integration problems found in minutes, not days
# - Always have working version
# - Reduced integration risk
# - Faster feedback
```

**Fowler's Key Insight**: "The longer code sits unintegrated, the more painful integration becomes."

---

### 7. Test-Driven Development Support

**What**: Write tests before code, let tests guide design.

**Why**: Tests enable refactoring, document behavior, improve design.

**Fowler's View**: TDD + Refactoring = Sustainable Pace

```python
# TDD enables refactoring with confidence

# Step 1: Write test
def test_calculate_total_with_discount():
    order = Order(items=[Item(price=100), Item(price=50)])
    order.customer = Customer(premium=True)

    total = calculate_total(order)

    assert total == 135  # 150 with 10% discount

# Step 2: Implement minimally
def calculate_total(order):
    subtotal = sum(item.price for item in order.items)
    if order.customer.premium:
        subtotal *= 0.9
    return subtotal

# Tests pass

# Step 3: Refactor with confidence (Extract Method)
def calculate_total(order):
    subtotal = calculate_subtotal(order)
    return apply_discount(subtotal, order.customer)

def calculate_subtotal(order):
    return sum(item.price for item in order.items)

def apply_discount(amount, customer):
    if customer.premium:
        return amount * 0.9
    return amount

# Tests still pass - refactoring was safe!

# Without tests, refactoring is risky
# With tests, refactoring is routine
```

---

### 8. Domain-Driven Design Support

**What**: Model the business domain in code. Use ubiquitous language.

**Why**: Software should reflect the business, making it easier to understand and evolve.

**Fowler's Patterns Support DDD**:

```python
# Domain Model (Entity)
class Order:
    """
    Represents a customer's order.
    Uses domain language: 'Order', not 'OrderDTO' or 'OrderEntity'
    """
    def __init__(self, customer):
        self.customer = customer
        self.items = []
        self.status = OrderStatus.DRAFT

    def add_item(self, product, quantity):
        """Add item using domain language."""
        item = OrderItem(product, quantity)
        self.items.append(item)

    def submit(self):
        """Business operation in domain language."""
        if not self.items:
            raise EmptyOrderError()
        self.status = OrderStatus.SUBMITTED

    def total(self):
        """Business calculation."""
        return sum(item.subtotal() for item in self.items)

# Repository (abstracts persistence)
class OrderRepository:
    """Persistence using domain language."""

    def save(self, order: Order):
        # Persistence details hidden from domain
        pass

    def find_by_customer(self, customer: Customer) -> List[Order]:
        # Returns domain objects
        pass

# Service Layer (orchestrates domain operations)
class OrderService:
    """Application operations using domain language."""

    def place_order(self, customer_id, items):
        customer = self.customer_repo.find(customer_id)
        order = Order(customer)

        for item in items:
            product = self.product_repo.find(item['product_id'])
            order.add_item(product, item['quantity'])

        order.submit()
        self.order_repo.save(order)

        return order

# Code speaks business language
# Easy for domain experts to read
# Changes in business logic clear to make
```

---

### 9. Pragmatic Problem-Solving

**What**: "Adopt a mindset of continuous improvement and pragmatic problem-solving."

**Why**: Software development requires balancing ideals with reality.

**Fowler's Approach**:
1. Understand the problem deeply
2. Apply appropriate patterns
3. Refactor to improve design
4. Test to maintain confidence
5. Ship and learn
6. Iterate

```python
# Pragmatic evolution of a solution

# Problem: Need to export orders in multiple formats

# First iteration: Just CSV (simplest solution)
def export_orders_csv(orders):
    lines = ["Order ID,Customer,Total"]
    for order in orders:
        lines.append(f"{order.id},{order.customer.name},{order.total}")
    return "\n".join(lines)

# Second iteration: Add JSON (duplicated code, but works)
def export_orders_json(orders):
    return json.dumps([{
        'id': o.id,
        'customer': o.customer.name,
        'total': o.total
    } for o in orders])

# Third iteration: Refactor when adding XML (extract common logic)
class OrderExporter:
    def export(self, orders, format):
        data = self.prepare_data(orders)
        if format == 'csv':
            return self.to_csv(data)
        elif format == 'json':
            return self.to_json(data)
        elif format == 'xml':
            return self.to_xml(data)

    def prepare_data(self, orders):
        return [{'id': o.id, 'customer': o.customer.name, 'total': o.total}
                for o in orders]

# Fourth iteration: Strategy pattern when complexity warrants
class ExportStrategy:
    def export(self, data):
        raise NotImplementedError

class CSVExporter(ExportStrategy):
    def export(self, data):
        # CSV implementation
        pass

class JSONExporter(ExportStrategy):
    def export(self, data):
        return json.dumps(data)

class OrderExportService:
    def __init__(self, strategy: ExportStrategy):
        self.strategy = strategy

    def export_orders(self, orders):
        data = [{'id': o.id, 'customer': o.customer.name, 'total': o.total}
                for o in orders]
        return self.strategy.export(data)

# Pragmatic progression:
# - Started simple (CSV function)
# - Added features as needed
# - Refactored when duplication emerged
# - Applied pattern when complexity demanded it
# Didn't over-engineer on day 1
```

---

### 10. Technology Agnosticism

**What**: Principles transcend specific technologies.

**Why**: Technologies change. Principles endure.

**Fowler's Patterns Apply Across**:
- Languages: Smalltalk → Java → C# → JavaScript → Python
- Frameworks: Struts → Spring → Rails → Express → Django
- Databases: Oracle → MySQL → PostgreSQL → MongoDB
- Platforms: Mainframe → Client/Server → Web → Cloud → Mobile

```python
# Repository Pattern in different technologies

# Python + SQLAlchemy
class UserRepository:
    def find_by_id(self, user_id):
        return db.session.query(User).filter_by(id=user_id).first()

# Java + Hibernate
public class UserRepository {
    public User findById(Long id) {
        return session.get(User.class, id);
    }
}

# C# + Entity Framework
public class UserRepository {
    public User FindById(int id) {
        return context.Users.Find(id);
    }
}

# JavaScript + Mongoose
class UserRepository {
    async findById(id) {
        return await User.findById(id);
    }
}

# Same pattern, different technology
# Understanding pattern enables implementation in any tech stack
```

---

## Fowler's Refactoring Catalog (Selected)

### Extract Method
```python
# Before
def print_owing(outstanding):
    print_banner()

    # print details
    print(f"name: {name}")
    print(f"amount: {outstanding}")

# After
def print_owing(outstanding):
    print_banner()
    print_details(outstanding)

def print_details(outstanding):
    print(f"name: {name}")
    print(f"amount: {outstanding}")
```

### Replace Conditional with Polymorphism
```python
# Before
def get_speed(bird_type):
    if bird_type == "EUROPEAN":
        return get_base_speed()
    elif bird_type == "AFRICAN":
        return get_base_speed() - get_load_factor()
    elif bird_type == "NORWEGIAN_BLUE":
        return 0 if is_nailed else get_base_speed()

# After
class Bird:
    def get_speed(self):
        raise NotImplementedError

class European(Bird):
    def get_speed(self):
        return self.get_base_speed()

class African(Bird):
    def get_speed(self):
        return self.get_base_speed() - self.get_load_factor()

class NorwegianBlue(Bird):
    def get_speed(self):
        return 0 if self.is_nailed else self.get_base_speed()
```

### Introduce Parameter Object
```python
# Before
def amount_invoiced(start_date, end_date):
    pass

def amount_received(start_date, end_date):
    pass

def amount_overdue(start_date, end_date):
    pass

# After
class DateRange:
    def __init__(self, start, end):
        self.start = start
        self.end = end

def amount_invoiced(date_range: DateRange):
    pass

def amount_received(date_range: DateRange):
    pass

def amount_overdue(date_range: DateRange):
    pass
```

---

## Applying Fowler's Philosophy

### For Individual Developers

**Daily Practices**:
- Refactor opportunistically (when touching code)
- Learn one refactoring per week
- Read pattern catalog regularly
- Test before refactoring
- Commit after each refactoring

**Mindset**:
- Code quality is continuous
- Design evolves, doesn't emerge fully formed
- Principles > Tools
- Patterns solve problems, not showcase knowledge

### For Teams

**Team Practices**:
- Shared pattern vocabulary
- Continuous integration (daily commits)
- Collective code ownership
- Refactoring time in estimates
- Code reviews check for refactoring opportunities

**Culture**:
- Technical excellence valued
- Refactoring is normal, not special
- Quality is everyone's responsibility
- Learning organization (continuous improvement)

### For Organizations

**Strategic Approaches**:
- Invest in automated testing
- Support evolutionary architecture
- Value technical practices
- Enable continuous integration/delivery
- Promote knowledge sharing (Fowler-style)

---

## Key Resources

### Fowler's Books
- **"Refactoring: Improving the Design of Existing Code"** (1999, 2018)
- **"Patterns of Enterprise Application Architecture"** (2002)
- **"UML Distilled"** (1997)
- **"Domain-Specific Languages"** (2010)

### Online Resources
- **martinfowler.com** - Blog and pattern catalog (free!)
- **Refactoring.com** - Refactoring resources

### Talks
- Numerous conference keynotes on refactoring, agile, and architecture

---

## Summary

Martin Fowler's philosophy emphasizes:

1. **Refactoring** - Continuous improvement through small, safe changes
2. **Evolutionary Design** - Design emerges, doesn't precede
3. **Principles Over Tools** - Focus on enduring principles
4. **Patterns as Vocabulary** - Shared language for design
5. **Layered Architecture** - Separation of concerns
6. **Continuous Integration** - Integrate frequently
7. **TDD Support** - Tests enable refactoring
8. **DDD Support** - Model the domain
9. **Pragmatism** - Balance ideals with reality
10. **Technology Agnosticism** - Principles transcend tools

**Core Belief**: "Creating software that has a good architecture isn't something that can be done first time; like good prose, it needs regular revisions."

Software quality comes from continuous improvement, not perfect initial design.

---

*"Any fool can write code that a computer can understand. Good programmers write code that humans can understand." - Martin Fowler*

*"When you feel the need to write a comment, first try to refactor the code so that any comment becomes superfluous." - Martin Fowler*
