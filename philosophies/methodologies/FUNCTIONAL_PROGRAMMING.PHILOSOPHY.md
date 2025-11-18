---
layout: default
title: Functional Programming
parent: Methodologies
grand_parent: Philosophies
nav_order: 3
---

# Functional Programming: Philosophy

> Functions, Immutability, Composition | Programming with Mathematical Purity

## Overview

Functional Programming (FP) is a programming paradigm that treats computation as the evaluation of mathematical functions. It emphasizes immutability, pure functions, and function composition, avoiding shared state and side effects.

## Core Principles

### 1. Pure Functions

**Philosophy**: A function is pure if it always produces the same output for the same input and has no side effects.

**Why**: Pure functions are:
- Easy to test (deterministic)
- Easy to reason about
- Easy to parallelize
- Easy to cache (memoization)

```python
# ❌ Impure: Depends on external state
total = 0
def add_to_total(amount):
    global total
    total += amount  # Side effect!
    return total

add_to_total(5)  # Returns 5
add_to_total(5)  # Returns 10 (same input, different output!)

# ✅ Pure: No side effects, deterministic
def add(a, b):
    return a + b

add(5, 3)  # Always returns 8
add(5, 3)  # Always returns 8

# ❌ Impure: Depends on external state
user_database = {"alice": 25}

def get_user_age(name):
    return user_database[name]  # Depends on mutable external state

# ✅ Pure: All inputs explicit
def get_user_age(name, database):
    return database.get(name)

get_user_age("alice", {"alice": 25})  # Always returns 25
```

**Referential Transparency**: A pure function call can be replaced with its result without changing program behavior.

```haskell
-- This
result = sqrt(4) + sqrt(4)

-- Is the same as
result = 2 + 2

-- Because sqrt(4) always equals 2 (pure function)
```

---

### 2. Immutability

**Philosophy**: Data cannot be modified after creation. Instead of changing data, create new data.

**Why**: Immutability eliminates entire categories of bugs:
- No race conditions
- No unintended modifications
- Temporal coupling eliminated
- Easy to track changes

```python
# ❌ Mutable: Changing data in place
def add_item(cart, item):
    cart.append(item)  # Modifies cart!
    return cart

my_cart = [1, 2, 3]
add_item(my_cart, 4)
print(my_cart)  # [1, 2, 3, 4] - original modified!

# ✅ Immutable: Return new data
def add_item(cart, item):
    return cart + [item]  # Creates new list

my_cart = [1, 2, 3]
new_cart = add_item(my_cart, 4)
print(my_cart)      # [1, 2, 3] - original unchanged
print(new_cart)     # [1, 2, 3, 4] - new list

# ✅ Immutable with persistent data structures
from pyrsistent import v

cart = v(1, 2, 3)
new_cart = cart.append(4)
print(cart)      # pvector([1, 2, 3])
print(new_cart)  # pvector([1, 2, 3, 4])

# Structural sharing: Efficient, doesn't copy all data
```

**Benefits in Concurrent Code**:
```python
# Mutable: Needs locks
class Counter:
    def __init__(self):
        self.value = 0
        self.lock = threading.Lock()

    def increment(self):
        with self.lock:  # Synchronization needed
            self.value += 1

# Immutable: No locks needed
class Counter:
    def __init__(self, value=0):
        self.value = value

    def increment(self):
        return Counter(self.value + 1)  # Thread-safe by default

# Multiple threads can increment without coordination
```

---

### 3. First-Class and Higher-Order Functions

**Philosophy**: Functions are values. They can be passed as arguments, returned from functions, and assigned to variables.

**Why**: Enables abstraction, composition, and code reuse.

```python
# Functions as arguments
numbers = [1, 2, 3, 4, 5]

# map: Apply function to each element
squares = map(lambda x: x**2, numbers)  # [1, 4, 9, 16, 25]

# filter: Keep elements matching predicate
evens = filter(lambda x: x % 2 == 0, numbers)  # [2, 4]

# reduce: Combine elements with function
from functools import reduce
total = reduce(lambda acc, x: acc + x, numbers, 0)  # 15

# Functions as return values
def make_multiplier(factor):
    def multiply(x):
        return x * factor
    return multiply

times_two = make_multiplier(2)
times_three = make_multiplier(3)

times_two(5)    # 10
times_three(5)  # 15

# Functions as variables
def add(a, b):
    return a + b

def subtract(a, b):
    return a - b

operations = {
    '+': add,
    '-': subtract,
}

operations['+'](5, 3)  # 8
operations['-'](5, 3)  # 2
```

---

### 4. Function Composition

**Philosophy**: Build complex functions by composing simple functions.

**Why**: Small, focused functions combined create powerful abstractions.

```python
# Composing functions
def double(x):
    return x * 2

def increment(x):
    return x + 1

def square(x):
    return x ** 2

# Manual composition
result = square(increment(double(5)))  # (5 * 2 + 1)^2 = 121

# Compose utility
def compose(*functions):
    def composed(x):
        result = x
        for func in reversed(functions):
            result = func(result)
        return result
    return composed

# Pipe utility (left-to-right)
def pipe(*functions):
    def piped(x):
        result = x
        for func in functions:
            result = func(result)
        return result
    return piped

# Usage
transform = pipe(double, increment, square)
result = transform(5)  # (5 * 2 + 1)^2 = 121

# Or point-free style
transform = compose(square, increment, double)
result = transform(5)  # Same result

# Real-world example
def parse_json(text):
    return json.loads(text)

def extract_users(data):
    return data['users']

def filter_active(users):
    return [u for u in users if u['active']]

def get_emails(users):
    return [u['email'] for u in users]

# Composed pipeline
get_active_user_emails = pipe(
    parse_json,
    extract_users,
    filter_active,
    get_emails
)

emails = get_active_user_emails(api_response)
```

---

### 5. Recursion Over Iteration

**Philosophy**: Use recursion instead of loops. No mutable loop variables.

**Why**: Recursion eliminates mutable state (loop counters). Clearer expression of algorithmic intent.

```python
# ❌ Imperative: Mutable state
def factorial_iterative(n):
    result = 1
    for i in range(1, n + 1):
        result *= i  # Mutation
    return result

# ✅ Functional: Recursion
def factorial(n):
    if n <= 1:
        return 1
    return n * factorial(n - 1)

# With tail call optimization (not in Python, but conceptually):
def factorial_tail(n, accumulator=1):
    if n <= 1:
        return accumulator
    return factorial_tail(n - 1, n * accumulator)

# ❌ Imperative: Process list with loop
def sum_list(numbers):
    total = 0
    for num in numbers:
        total += num  # Mutation
    return total

# ✅ Functional: Recursion
def sum_list(numbers):
    if not numbers:
        return 0
    return numbers[0] + sum_list(numbers[1:])

# Or use reduce (fold)
from functools import reduce
sum_list = lambda numbers: reduce(lambda acc, x: acc + x, numbers, 0)
```

**Note**: Python doesn't optimize tail recursion. Use loops or `functools.reduce` in practice. Concept still valuable.

---

### 6. Declarative Over Imperative

**Philosophy**: Describe what you want, not how to get it.

**Why**: Clearer intent. Less boilerplate. More maintainable.

```python
# ❌ Imperative: How to do it
evens = []
for num in numbers:
    if num % 2 == 0:
        evens.append(num)

# ✅ Declarative: What we want
evens = [num for num in numbers if num % 2 == 0]
evens = filter(lambda x: x % 2 == 0, numbers)

# ❌ Imperative: How to transform
result = []
for user in users:
    if user.active:
        result.append(user.email.upper())

# ✅ Declarative: What we want
result = [user.email.upper() for user in users if user.active]
result = map(
    lambda u: u.email.upper(),
    filter(lambda u: u.active, users)
)

# SQL is declarative
SELECT email FROM users WHERE active = true;

# vs. imperative:
# for row in table:
#     if row.active:
#         results.append(row.email)
```

---

### 7. Lazy Evaluation

**Philosophy**: Compute values only when needed. Don't evaluate until required.

**Why**: Efficiency. Enables infinite data structures. Separates concerns.

```python
# Lazy: Generators
def fibonacci():
    a, b = 0, 1
    while True:
        yield a
        a, b = b, a + b

# Infinite sequence, but doesn't compute until needed
fib = fibonacci()

# Take only what you need
first_10 = [next(fib) for _ in range(10)]

# Lazy map/filter (Python 3 default)
numbers = range(1000000)  # Lazy range
squared = map(lambda x: x**2, numbers)  # Lazy map
evens = filter(lambda x: x % 2 == 0, squared)  # Lazy filter

# None of these compute yet!
# Only when you consume:
result = list(evens)  # Now computation happens

# Lazy list comprehensions with generators
evens = (x for x in range(1000000) if x % 2 == 0)  # Generator

# Benefits: Memory efficient, computes on demand
```

---

### 8. Currying and Partial Application

**Philosophy**: Transform multi-argument functions into chains of single-argument functions.

**Why**: Enables function specialization and composition.

```python
# Regular function
def add(a, b):
    return a + b

add(2, 3)  # 5

# Curried version
def add_curried(a):
    def inner(b):
        return a + b
    return inner

add_curried(2)(3)  # 5

# Partial application
from functools import partial

# Create specialized functions
add_five = partial(add, 5)
add_five(3)  # 8

multiply = lambda a, b: a * b
double = partial(multiply, 2)
triple = partial(multiply, 3)

double(5)  # 10
triple(5)  # 15

# Real-world example
def log(level, message):
    print(f"[{level}] {message}")

# Specialized loggers
log_error = partial(log, "ERROR")
log_info = partial(log, "INFO")

log_error("Database connection failed")  # [ERROR] Database connection failed
log_info("Server started")               # [INFO] Server started

# Currying for configuration
def configure_api(base_url):
    def with_auth(api_key):
        def make_request(endpoint):
            return f"{base_url}/{endpoint}?key={api_key}"
        return make_request
    return with_auth

# Build up configuration
api = configure_api("https://api.example.com")
authed_api = api("secret-key")
result = authed_api("users")  # https://api.example.com/users?key=secret-key
```

---

### 9. Algebraic Data Types and Pattern Matching

**Philosophy**: Model data with types. Handle all cases explicitly.

**Why**: Compiler ensures exhaustive handling. Impossible states unrepresentable.

```python
# Algebraic data types (using classes)
from dataclasses import dataclass
from typing import Union

@dataclass
class Circle:
    radius: float

@dataclass
class Rectangle:
    width: float
    height: float

@dataclass
class Triangle:
    base: float
    height: float

Shape = Union[Circle, Rectangle, Triangle]

# Pattern matching (Python 3.10+)
def area(shape: Shape) -> float:
    match shape:
        case Circle(radius):
            return 3.14 * radius ** 2
        case Rectangle(width, height):
            return width * height
        case Triangle(base, height):
            return 0.5 * base * height

# Compiler ensures all cases handled

# Option type (explicit absence)
from typing import Optional

def find_user(id: int) -> Optional[User]:
    # Returns User or None
    pass

user = find_user(123)
if user is not None:
    print(user.name)  # Type checker knows user is not None here

# Result type (explicit errors)
from typing import Union

@dataclass
class Success:
    value: any

@dataclass
class Error:
    message: str

Result = Union[Success, Error]

def divide(a, b) -> Result:
    if b == 0:
        return Error("Division by zero")
    return Success(a / b)

result = divide(10, 2)
match result:
    case Success(value):
        print(f"Result: {value}")
    case Error(message):
        print(f"Error: {message}")
```

---

### 10. Functors, Applicatives, Monads

**Philosophy**: Patterns for working with values in contexts (Maybe, List, IO, etc.).

**Why**: Composable abstractions for common patterns.

```python
# Functor: map over context
# List is a functor
numbers = [1, 2, 3]
doubled = map(lambda x: x * 2, numbers)  # [2, 4, 6]

# Maybe/Option is a functor
class Maybe:
    @staticmethod
    def just(value):
        return Just(value)

    @staticmethod
    def nothing():
        return Nothing()

class Just(Maybe):
    def __init__(self, value):
        self.value = value

    def map(self, func):
        return Just(func(self.value))

class Nothing(Maybe):
    def map(self, func):
        return self  # Short-circuit

# Usage
result = Maybe.just(5).map(lambda x: x * 2).map(lambda x: x + 1)
# Just(11)

result = Maybe.nothing().map(lambda x: x * 2).map(lambda x: x + 1)
# Nothing() - no computation happened

# Monad: flatMap/bind for chaining operations
class Just(Maybe):
    def flat_map(self, func):
        return func(self.value)  # func returns Maybe

class Nothing(Maybe):
    def flat_map(self, func):
        return self

def safe_divide(a, b):
    if b == 0:
        return Maybe.nothing()
    return Maybe.just(a / b)

# Chain operations that might fail
result = (Maybe.just(10)
    .flat_map(lambda x: safe_divide(x, 2))
    .flat_map(lambda x: safe_divide(x, 0))  # Fails here
    .map(lambda x: x + 1))                  # Never executes

# result is Nothing()

# IO Monad: Pure functions for side effects
class IO:
    def __init__(self, effect):
        self.effect = effect

    def run(self):
        return self.effect()

    def map(self, func):
        return IO(lambda: func(self.effect()))

    def flat_map(self, func):
        return IO(lambda: func(self.effect()).run())

# Build up IO operations (pure!)
def get_input():
    return IO(lambda: input("Enter name: "))

def greet(name):
    return IO(lambda: print(f"Hello, {name}!"))

# Compose IO operations
program = get_input().flat_map(greet)

# Nothing has executed yet - pure!
# Run when ready:
program.run()
```

---

## Functional Programming in Practice

### Benefits

**Easier to Test**:
```python
# Pure functions: No setup needed
assert add(2, 3) == 5
assert multiply(4, 5) == 20

# Impure functions: Complex setup
database.connect()
user_service = UserService(database)
user = user_service.create("alice@example.com")
assert user.email == "alice@example.com"
```

**Easier to Parallelize**:
```python
# Pure functions: Trivial parallelization
from multiprocessing import Pool

def expensive_computation(x):
    return x ** 2  # Pure, no shared state

with Pool(4) as pool:
    results = pool.map(expensive_computation, range(1000))

# No locks, no synchronization needed!
```

**Easier to Reason About**:
```python
# Pure function: Local reasoning
def calculate_discount(price, rate):
    return price * (1 - rate)

# I know everything about this function by reading it
# No hidden state, no global variables, no side effects

# Impure function: Global reasoning required
discount_rate = 0.1  # Global state

def calculate_discount(price):
    global discount_rate
    if user.is_premium:  # Where does 'user' come from?
        discount_rate += 0.05  # Modifies global state!
    return price * (1 - discount_rate)

# Must understand entire codebase to understand this function
```

---

## FP Anti-Patterns

### ❌ Hidden Mutation

```python
# Looks functional, but mutates
def add_item(cart, item):
    new_cart = cart.copy()
    new_cart.append(item)  # Mutation (even if on copy)
    return new_cart

# Better: Truly immutable
def add_item(cart, item):
    return cart + [item]  # No mutation anywhere
```

### ❌ Side Effects in "Pure" Functions

```python
# Looks pure, but has side effects
def calculate_total(items):
    total = sum(item.price for item in items)
    log.info(f"Calculated total: {total}")  # Side effect!
    return total

# Better: Separate pure calculation from side effects
def calculate_total(items):
    return sum(item.price for item in items)

def calculate_and_log_total(items):
    total = calculate_total(items)
    log.info(f"Calculated total: {total}")
    return total
```

---

## Key Resources

### Books
- **"Structure and Interpretation of Computer Programs"** (SICP)
- **"Functional Programming in Python"** - David Mertz
- **"Functional Programming in Scala"** - Paul Chiusano & Rúnar Bjarnason

### Languages
- **Haskell**: Pure functional
- **Clojure**: Functional + immutable data
- **F#**: Functional-first .NET
- **Elixir**: Functional, concurrent

---

## Summary

Functional Programming emphasizes:

1. **Pure Functions** - Same input → same output, no side effects
2. **Immutability** - Data doesn't change
3. **First-Class Functions** - Functions as values
4. **Composition** - Build complex from simple
5. **Recursion** - Instead of loops
6. **Declarative** - What, not how
7. **Lazy Evaluation** - Compute when needed
8. **Currying** - Specialize functions
9. **ADTs** - Model data with types
10. **Monads** - Composable abstractions

**Core Belief**: "Programs should be built from small, composable, pure functions that are easy to understand, test, and reason about."

---

*"Object-oriented programming makes code understandable by encapsulating moving parts. Functional programming makes code understandable by minimizing moving parts." - Michael Feathers*
