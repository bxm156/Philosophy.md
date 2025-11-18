---
layout: default
title: Clean Code
parent: Methodologies
grand_parent: Philosophies
nav_order: 1
---

# Clean Code: Philosophy

> Code Should Read Like Well-Written Prose | Robert C. Martin (Uncle Bob)

## Overview

Clean Code is a philosophy of software craftsmanship that emphasizes readability, simplicity, and expressiveness. Robert C. Martin's principles focus on writing code that is easy to understand, easy to change, and easy to maintain.

## Core Principles

### 1. Meaningful Names

**Philosophy**: Names should reveal intent. The name should tell you why it exists, what it does, and how it's used.

**Why**: Good names eliminate the need for comments.

```python
# ❌ Bad: Unclear names
d = 42  # elapsed time in days
def f(x):
    return x * 2

# ✅ Good: Intention-revealing names
elapsed_time_in_days = 42
def double_value(number):
    return number * 2

# ❌ Bad: Misleading
accounts_list = {}  # It's a dict, not a list!

# ✅ Good: Accurate
accounts_by_id = {}

# ❌ Bad: Noise words
class UserInfo:  # "Info" adds no meaning
    pass

class UserData:  # "Data" is redundant
    pass

# ✅ Good: Clear and specific
class User:
    pass

# ❌ Bad: Magic numbers
if user.age > 18:
    allow_access()

# ✅ Good: Named constants
LEGAL_AGE = 18
if user.age >= LEGAL_AGE:
    allow_access()
```

**Naming Guidelines**:
- Use pronounceable names (`timestamp` not `tstmp`)
- Use searchable names (not single letters except in tiny scopes)
- Avoid mental mapping (`i`, `j`, `k` are OK in loops only)
- Class names: Nouns or noun phrases (`Customer`, `Account`)
- Method names: Verbs or verb phrases (`delete_page`, `save`)

---

### 2. Functions Should Do One Thing

**Philosophy**: "Functions should do one thing. They should do it well. They should do it only."

**Why**: Single-purpose functions are easier to understand, test, and reuse.

```python
# ❌ Bad: Does multiple things
def process_order(order):
    # Validate
    if not order.items:
        raise ValueError("Empty order")

    # Calculate total
    total = sum(item.price for item in order.items)

    # Apply discount
    if order.customer.is_premium:
        total *= 0.9

    # Save to database
    db.orders.insert(order)

    # Send confirmation email
    send_email(order.customer.email, f"Order confirmed: ${total}")

    # Update inventory
    for item in order.items:
        inventory.decrease(item.id, item.quantity)

    return total

# ✅ Good: Each function does one thing
def process_order(order):
    validate_order(order)
    total = calculate_order_total(order)
    save_order(order, total)
    send_order_confirmation(order, total)
    update_inventory(order)
    return total

def validate_order(order):
    if not order.items:
        raise ValueError("Empty order")

def calculate_order_total(order):
    total = sum(item.price for item in order.items)
    if order.customer.is_premium:
        total = apply_discount(total, 0.1)
    return total

def apply_discount(amount, discount_rate):
    return amount * (1 - discount_rate)

# Each function is simple, testable, reusable
```

**How to Know if a Function Does One Thing**:
- Can you extract another function from it with a name that's not just a restatement?
- If yes, it does more than one thing

---

### 3. Small Functions

**Philosophy**: Functions should be small. Really small. 2-4 lines is ideal. Rarely more than 20.

**Why**: Small functions are easier to understand, test, and name accurately.

```python
# ❌ Bad: Long function (hard to understand)
def render_page(user):
    if user.is_authenticated:
        if user.has_permission('admin'):
            # 50 lines of admin UI rendering
        elif user.has_permission('editor'):
            # 50 lines of editor UI rendering
        else:
            # 50 lines of viewer UI rendering
    else:
        # 20 lines of login UI rendering

# ✅ Good: Small, focused functions
def render_page(user):
    if not user.is_authenticated:
        return render_login_page()

    if user.has_permission('admin'):
        return render_admin_page(user)
    elif user.has_permission('editor'):
        return render_editor_page(user)
    else:
        return render_viewer_page(user)

def render_admin_page(user):
    # Focused on admin UI only
    pass

# Each function is small and single-purpose
```

**Uncle Bob's Guideline**: "The first rule of functions is that they should be small. The second rule is that they should be smaller than that."

---

### 4. One Level of Abstraction

**Philosophy**: All code in a function should be at the same level of abstraction.

**Why**: Mixing levels makes code hard to follow. Functions should read like a TO DO list.

```python
# ❌ Bad: Mixed abstraction levels
def make_coffee():
    grinder.grind_beans()  # High level
    water_temp = 0
    while water_temp < 95:  # Low level (loop details)
        water_temp += heat_rate * time_delta
    brew(ground_coffee, water)  # High level

# ✅ Good: Consistent abstraction level
def make_coffee():
    ground_coffee = grind_beans()
    hot_water = heat_water_to_temperature(95)
    coffee = brew(ground_coffee, hot_water)
    return coffee

def heat_water_to_temperature(target_temp):
    water_temp = 0
    while water_temp < target_temp:
        water_temp += heat_rate * time_delta
    return water_temp

# Top function reads at high level
# Details hidden in lower-level functions
```

**The Stepdown Rule**: Code should read like a newspaper article - high-level summary at top, details below.

---

### 5. Minimize Arguments

**Philosophy**: The ideal number of function arguments is zero. Next is one. Two is okay. Three should be avoided. More than three requires special justification.

**Why**: Arguments add complexity. Hard to test. Hard to understand.

```python
# ❌ Bad: Too many arguments
def create_user(first_name, last_name, email, phone, address, city, state, zip_code):
    # ...

# Calling is error-prone:
create_user("Alice", "Smith", "alice@example.com", "555-1234", "123 Main St", "NYC", "NY", "10001")

# ✅ Good: Use object to group related data
class Address:
    def __init__(self, street, city, state, zip_code):
        self.street = street
        self.city = city
        self.state = state
        self.zip_code = zip_code

class UserRegistration:
    def __init__(self, first_name, last_name, email, phone, address):
        self.first_name = first_name
        self.last_name = last_name
        self.email = email
        self.phone = phone
        self.address = address

def create_user(registration: UserRegistration):
    # ...

# Calling is clear:
address = Address("123 Main St", "NYC", "NY", "10001")
registration = UserRegistration("Alice", "Smith", "alice@example.com", "555-1234", address)
create_user(registration)

# ❌ Bad: Flag arguments (function does two things!)
def render(is_admin):
    if is_admin:
        render_admin_page()
    else:
        render_user_page()

# ✅ Good: Separate functions
def render_admin_page():
    # ...

def render_user_page():
    # ...
```

---

### 6. Avoid Side Effects

**Philosophy**: Functions should either do something (command) or answer something (query), but not both.

**Why**: Side effects create unexpected behavior. Command-Query Separation makes code predictable.

```python
# ❌ Bad: Side effect (modifies state + returns boolean)
def check_password_and_initialize_session(username, password):
    if authenticate(username, password):
        session.initialize(username)  # Side effect!
        return True
    return False

# Caller doesn't expect session initialization from name

# ✅ Good: Separate command and query
def is_password_correct(username, password):
    return authenticate(username, password)

def initialize_session(username):
    session.initialize(username)

# Explicit:
if is_password_correct(username, password):
    initialize_session(username)

# ❌ Bad: Hidden side effect
def get_user_by_email(email):
    user = database.find_user(email)
    user.last_accessed = datetime.now()  # Unexpected modification!
    database.save(user)
    return user

# ✅ Good: Pure query (no side effects)
def get_user_by_email(email):
    return database.find_user(email)

def update_last_accessed(user):
    user.last_accessed = datetime.now()
    database.save(user)
```

---

### 7. Don't Repeat Yourself (DRY)

**Philosophy**: "Every piece of knowledge must have a single, unambiguous, authoritative representation within a system."

**Why**: Duplication means changes in multiple places. Errors. Inconsistency.

```python
# ❌ Bad: Duplication
def calculate_employee_salary(employee):
    salary = employee.base_salary
    if employee.years_of_service > 5:
        salary = salary * 1.1
    if employee.has_dependents:
        salary = salary * 1.05
    return salary

def calculate_contractor_payment(contractor):
    payment = contractor.base_rate * contractor.hours_worked
    if contractor.years_of_service > 5:  # Duplicated logic
        payment = payment * 1.1
    if contractor.has_dependents:  # Duplicated logic
        payment = payment * 1.05
    return payment

# ✅ Good: Extract duplication
def apply_seniority_bonus(amount, years_of_service):
    if years_of_service > 5:
        return amount * 1.1
    return amount

def apply_dependent_bonus(amount, has_dependents):
    if has_dependents:
        return amount * 1.05
    return amount

def calculate_employee_salary(employee):
    salary = employee.base_salary
    salary = apply_seniority_bonus(salary, employee.years_of_service)
    salary = apply_dependent_bonus(salary, employee.has_dependents)
    return salary

def calculate_contractor_payment(contractor):
    payment = contractor.base_rate * contractor.hours_worked
    payment = apply_seniority_bonus(payment, contractor.years_of_service)
    payment = apply_dependent_bonus(payment, contractor.has_dependents)
    return payment
```

---

### 8. Comments Are Usually a Failure

**Philosophy**: Comments are, at best, a necessary evil. Good code mostly documents itself.

**Why**: Comments lie. Code changes, comments don't. Prefer expressive code over comments.

```python
# ❌ Bad: Comment explains bad code
# Check to see if employee is eligible for full benefits
if ((employee.flags & HOURLY_FLAG) && (employee.age > 65))

# ✅ Good: Code explains itself
if employee.is_eligible_for_full_benefits():

# ❌ Bad: Redundant comment
# Increment counter by 1
counter += 1

# ✅ Good: No comment needed
counter += 1

# ❌ Bad: Commented-out code (delete it!)
# def old_implementation():
#     # ... 50 lines of old code
#     pass

# ✅ Good: Delete it (version control remembers)
# (Code simply doesn't exist)

# ✅ Acceptable: Legal or copyright comments
"""
Copyright (C) 2024 Company Name
Licensed under MIT
"""

# ✅ Acceptable: Warning of consequences
def delete_all_data():
    """
    WARNING: This permanently deletes ALL data.
    There is no undo. Use with extreme caution.
    """
    database.drop_all_tables()

# ✅ Acceptable: TODO comments (but prefer issue tracker)
def calculate_tax(amount):
    # TODO: Implement state tax calculation
    return amount * 0.1
```

---

### 9. Error Handling is One Thing

**Philosophy**: Functions that handle errors should do only that. Don't mix error handling with business logic.

**Why**: Error handling is a concern. Keep it separate.

```python
# ❌ Bad: Mixed error handling and logic
def process_user_data(data):
    try:
        user = parse_user(data)
        validate_email(user.email)
        result = calculate_score(user)
        save_to_database(user, result)
        send_notification(user)
        return result
    except ValueError as e:
        log_error(e)
        return None
    except DatabaseError as e:
        log_error(e)
        return None
    except EmailError as e:
        log_error(e)
        return None

# ✅ Good: Separate error handling
def process_user_data(data):
    try:
        return _process_user_data_core(data)
    except (ValueError, DatabaseError, EmailError) as e:
        return handle_processing_error(e)

def _process_user_data_core(data):
    user = parse_user(data)
    validate_email(user.email)
    result = calculate_score(user)
    save_to_database(user, result)
    send_notification(user)
    return result

def handle_processing_error(error):
    log_error(error)
    return None
```

---

### 10. Code Should Read Like Prose

**Philosophy**: Code should read like a well-written magazine article.

**Why**: We read code far more than we write it.

```python
# ❌ Bad: Cryptic
def p(u, o):
    if u.a and o.i:
        t = sum([i.p for i in o.i])
        if u.p:
            t *= 0.9
        db.i(o)
        e(u.e, t)
        return t

# ✅ Good: Reads like prose
def process_order(user, order):
    """Process an order for an authenticated user."""
    validate_user_and_order(user, order)

    total = calculate_order_total(order)
    total = apply_premium_discount_if_applicable(user, total)

    save_order_to_database(order)
    send_confirmation_email(user, total)

    return total

def validate_user_and_order(user, order):
    if not user.is_authenticated:
        raise AuthenticationError("User must be authenticated")
    if not order.items:
        raise ValueError("Order must contain items")

def calculate_order_total(order):
    return sum(item.price for item in order.items)

def apply_premium_discount_if_applicable(user, total):
    if user.is_premium:
        return apply_discount(total, rate=0.1)
    return total

# Reading this code tells a story
```

---

## SOLID Principles

### S - Single Responsibility Principle (SRP)

**Philosophy**: A class should have only one reason to change.

```python
# ❌ Bad: Multiple responsibilities
class User:
    def __init__(self, name, email):
        self.name = name
        self.email = email

    def save(self):
        db.save(self)  # Persistence responsibility

    def send_email(self, subject, body):
        email.send(self.email, subject, body)  # Email responsibility

    def generate_report(self):
        return f"User: {self.name}"  # Reporting responsibility

# ✅ Good: Single responsibility per class
class User:
    def __init__(self, name, email):
        self.name = name
        self.email = email

class UserRepository:
    def save(self, user):
        db.save(user)

class EmailService:
    def send_to_user(self, user, subject, body):
        email.send(user.email, subject, body)

class UserReportGenerator:
    def generate(self, user):
        return f"User: {user.name}"
```

### O - Open/Closed Principle

**Philosophy**: Classes should be open for extension, closed for modification.

```python
# ❌ Bad: Must modify class to add new shape
class AreaCalculator:
    def calculate(self, shape):
        if shape.type == "circle":
            return 3.14 * shape.radius ** 2
        elif shape.type == "rectangle":
            return shape.width * shape.height
        # Adding triangle requires modifying this class

# ✅ Good: Extend by adding new classes
class Shape:
    def area(self):
        raise NotImplementedError

class Circle(Shape):
    def __init__(self, radius):
        self.radius = radius

    def area(self):
        return 3.14 * self.radius ** 2

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

class Triangle(Shape):  # Extension, not modification
    def __init__(self, base, height):
        self.base = base
        self.height = height

    def area(self):
        return 0.5 * self.base * self.height

# AreaCalculator doesn't need to change
def calculate_total_area(shapes):
    return sum(shape.area() for shape in shapes)
```

### L - Liskov Substitution Principle

**Philosophy**: Subtypes must be substitutable for their base types.

```python
# ❌ Bad: Violates LSP
class Rectangle:
    def set_width(self, width):
        self.width = width

    def set_height(self, height):
        self.height = height

class Square(Rectangle):  # Violates LSP
    def set_width(self, width):
        self.width = width
        self.height = width  # Side effect!

    def set_height(self, height):
        self.width = height
        self.height = height

# This breaks:
def test_area(rectangle):
    rectangle.set_width(5)
    rectangle.set_height(4)
    assert rectangle.width * rectangle.height == 20  # Fails for Square!

# ✅ Good: Correct hierarchy
class Shape:
    def area(self):
        raise NotImplementedError

class Rectangle(Shape):
    def __init__(self, width, height):
        self.width = width
        self.height = height

    def area(self):
        return self.width * self.height

class Square(Shape):
    def __init__(self, size):
        self.size = size

    def area(self):
        return self.size ** 2

# No inheritance relationship, no LSP violation
```

### I - Interface Segregation Principle

**Philosophy**: Clients shouldn't be forced to depend on interfaces they don't use.

```python
# ❌ Bad: Fat interface
class Worker:
    def work(self):
        raise NotImplementedError

    def eat(self):
        raise NotImplementedError

    def sleep(self):
        raise NotImplementedError

class Robot(Worker):  # Problem: Robots don't eat or sleep
    def work(self):
        return "Working"

    def eat(self):
        raise NotImplementedError  # Forced to implement!

    def sleep(self):
        raise NotImplementedError  # Forced to implement!

# ✅ Good: Segregated interfaces
class Workable:
    def work(self):
        raise NotImplementedError

class Eatable:
    def eat(self):
        raise NotImplementedError

class Sleepable:
    def sleep(self):
        raise NotImplementedError

class Human(Workable, Eatable, Sleepable):
    def work(self):
        return "Working"

    def eat(self):
        return "Eating"

    def sleep(self):
        return "Sleeping"

class Robot(Workable):  # Only implements what it needs
    def work(self):
        return "Working"
```

### D - Dependency Inversion Principle

**Philosophy**: Depend on abstractions, not concretions.

```python
# ❌ Bad: Depends on concrete implementation
class EmailService:
    def send(self, to, subject, body):
        # Email-specific implementation
        pass

class NotificationService:
    def __init__(self):
        self.email_service = EmailService()  # Concrete dependency

    def notify(self, user, message):
        self.email_service.send(user.email, "Notification", message)

# Can't easily switch to SMS or push notifications

# ✅ Good: Depends on abstraction
class MessageSender:
    def send(self, recipient, message):
        raise NotImplementedError

class EmailSender(MessageSender):
    def send(self, recipient, message):
        # Email implementation
        pass

class SMSSender(MessageSender):
    def send(self, recipient, message):
        # SMS implementation
        pass

class NotificationService:
    def __init__(self, sender: MessageSender):
        self.sender = sender  # Abstract dependency

    def notify(self, user, message):
        self.sender.send(user.contact, message)

# Easy to switch implementations
email_notifier = NotificationService(EmailSender())
sms_notifier = NotificationService(SMSSender())
```

---

## Clean Code Checklist

**For every function**:
- [ ] Does it have a clear, descriptive name?
- [ ] Does it do one thing?
- [ ] Is it small (< 20 lines)?
- [ ] Does it have minimal arguments (0-2)?
- [ ] Is it at one level of abstraction?
- [ ] Are side effects avoided or clearly documented?
- [ ] Does it read like prose?

**For every class**:
- [ ] Does it have a single responsibility?
- [ ] Is it open for extension, closed for modification?
- [ ] Does it follow SOLID principles?
- [ ] Are dependencies injected (not created internally)?

**For every code change**:
- [ ] Did I leave the code cleaner than I found it?
- [ ] Did I remove any duplication?
- [ ] Are names clear and intention-revealing?
- [ ] Can I extract any functions?
- [ ] Can I simplify any logic?

---

## Key Resources

### Books
- **"Clean Code"** - Robert C. Martin
- **"The Clean Coder"** - Robert C. Martin
- **"Refactoring"** - Martin Fowler
- **"Code Complete"** - Steve McConnell

### Talks
- **Clean Code - Uncle Bob** (multiple conference talks)
- **SOLID Principles** - Uncle Bob

---

## Summary

Clean Code principles:

1. **Meaningful Names** - Reveal intent
2. **Small Functions** - Do one thing
3. **One Abstraction Level** - Per function
4. **Minimal Arguments** - 0-2 ideal
5. **No Side Effects** - Pure when possible
6. **DRY** - Don't repeat yourself
7. **Comments = Failure** - Prefer expressive code
8. **Separate Concerns** - Error handling separate from logic
9. **SOLID** - Five principles of OOP
10. **Prose** - Code reads like well-written prose

**Core Belief**: "Clean code always looks like it was written by someone who cares."

---

*"Indeed, the ratio of time spent reading versus writing is well over 10 to 1. We are constantly reading old code as part of the effort to write new code. Making it easy to read makes it easier to write." - Robert C. Martin*
