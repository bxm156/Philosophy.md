# Rich Hickey: Coding Philosophy

> Creator of Clojure | Simplicity is a Choice

## Overview

Rich Hickey's philosophy centers on the distinction between **simple** and **easy**, emphasizing that developers should choose simplicity even when it's not easy. His work on Clojure demonstrates how functional programming, immutability, and careful design lead to more robust software.

## Core Principles

### 1. Simple vs. Easy

**What**: "Simple" means one braid/fold. "Easy" means near at hand, familiar.

**Why**: We often choose "easy" (familiar, convenient) over "simple" (lack of interleaving/complexity). This creates accidental complexity.

**Hickey's Definition**:
```
Simple ≠ Easy

Simple:
- One role
- One task
- One concept
- About lack of interleaving
- Objective

Easy:
- Near at hand
- Familiar
- In our comfort zone
- Subjective
- Relative to our capabilities
```

**Example**:
```clojure
; Easy but not simple: Mutable state with multiple concerns
(def user (atom {:name "Alice"
                 :email "alice@example.com"
                 :session-token "xyz123"
                 :last-login (now)
                 :preferences {...}}))

; Updating mutates many concerns at once
(swap! user assoc :name "Alice Smith" :last-login (now))

; Simple: Separate concerns, immutable data
(def user-identity {:id 1 :name "Alice" :email "alice@example.com"})
(def user-session {:user-id 1 :token "xyz123" :created-at ...})
(def user-activity {:user-id 1 :last-login ...})
(def user-preferences {:user-id 1 :theme "dark" ...})

; Each is simple - one fold, one concern
; Updates create new values, don't mutate
```

**How to Choose Simple**:
1. Identify what you're complecting (braiding together)
2. Separate concerns
3. Choose tools/approaches that enable simplicity
4. Accept that simple might not be easy initially

**Trade-offs**:
- ✅ Easier to understand and reason about
- ✅ More robust and maintainable
- ✅ Fewer bugs from unexpected interactions
- ⚠️ May require learning new approaches
- ⚠️ Can feel harder initially (not "near at hand")

---

### 2. Complecting: The Enemy of Simplicity

**What**: "Complect" means to braid/weave together. Complecting occurs when you interleave unrelated things.

**Why**: Complected code is harder to understand, change, test, and reason about.

**Common Complecting**:
```
State + Time = Complected
- Mutable objects braid identity and state
- Changes happen in time
- Hard to reason about what value something had

State + Identity = Simple
- Immutable values separate identity from state
- Identity is a series of states over time
- Easy to reason about any point in time

Methods + Namespaces = Complected
- Methods bound to classes
- Can't use method without class instance

Functions + Data = Simple
- Functions separate from data
- Can apply any function to any appropriate data
```

**Example**:
```clojure
; Complected: OOP with mutable state
class BankAccount {
    private double balance;
    private List<Transaction> history;

    public void deposit(double amount) {
        this.balance += amount;  // Complects state + time
        this.history.add(new Transaction(...));  // Side effects
    }

    public double getBalance() {
        return this.balance;  // What balance? When?
    }
}

; Simple: Immutable data, pure functions
(defn deposit [account amount]
  (-> account
      (update :balance + amount)
      (update :transactions conj {:type :deposit :amount amount :time (now)})))

; account is immutable - new value returned
; No complecting of state and time
; Easy to test: (deposit {:balance 100} 50) => {:balance 150 ...}
```

**How to Avoid Complecting**:
- Use immutable data structures
- Separate identity from state
- Separate behavior from data
- Avoid stateful objects
- Prefer pure functions

---

### 3. Values: The Atomic Unit of Fact

**What**: Values are immutable, don't change over time. They represent facts.

**Why**: Values don't change, so you never need to worry about coordination, locks, or temporal coupling.

**Hickey's Insight**:
```
The number 42 never changes.
The string "hello" never changes.
Your data structures shouldn't change either.

Changing values makes no sense:
- Can't make 42 equal to 43
- Can't make "hello" equal to "goodbye"
- Why should {:name "Alice"} become {:name "Bob"}?

Instead: New values represent new facts
```

**Example**:
```clojure
; Values are facts about the world
(def user-v1 {:id 1 :name "Alice" :email "alice@example.com"})
(def user-v2 {:id 1 :name "Alice Smith" :email "alice@newmail.com"})

; Both values exist, represent different points in time
; No mutation, no coordination needed
; Can reason about either independently

; In a mutable world:
user.name = "Alice"
// What is user.name now? Depends when you ask!
// Can't reason about it without understanding time/coordination
```

**Benefits of Values**:
- Thread-safe by default
- Easy to test (just data)
- Can cache/memoize freely
- Represent specific points in time
- Can share without fear

---

### 4. Identity: A Series of States Over Time

**What**: Identity is a stable logical entity that has different states over time.

**Why**: Separating identity from state removes complecting, makes reasoning easier.

**The Model**:
```
Identity = A succession of states over time

Time:     t0      t1      t2      t3
          |       |       |       |
User:     Alice → Alice → Alice → Alice Smith
          (state0)(state1)(state2)(state3)

Each state is a value (immutable).
Identity is the continuous logical entity.
```

**Implementation in Clojure**:
```clojure
; Atom: A reference type (identity)
(def user (atom {:name "Alice" :email "alice@example.com"}))

; States over time
@user ; => {:name "Alice" :email "alice@example.com"}  (state at t1)

(swap! user assoc :name "Alice Smith")

@user ; => {:name "Alice Smith" :email "alice@example.com"}  (state at t2)

; The atom 'user' is the identity
; Each value it contains is a state
; States are immutable
; Identity changes which state it refers to
```

**Contrast with OOP**:
```java
// OOP: Identity and state complected
class User {
    private String name;  // State is part of identity
    private String email;

    public void setName(String name) {
        this.name = name;  // Mutation - state and identity complected
    }
}

// Can't reason about "what was the user's name at time t1?"
// Object has no memory of previous states
```

---

### 5. Time: A Relative Ordering of Events

**What**: Time is not absolute. It's a relative ordering of causal events.

**Why**: Traditional mutable state conflates state with time, making reasoning difficult.

**Hickey's Approach**:
- States are values (exist outside time)
- Identities refer to states
- Time is the succession of states
- Past states remain accessible

**Example**:
```clojure
; Traditional: Lost history
user.name = "Alice"
user.name = "Alice Smith"
; What was the name before? Gone.

; Hickey's approach: Preserve history
(def user-history (atom []))

(defn update-user [user changes]
  (let [new-state (merge user changes)]
    (swap! user-history conj new-state)
    new-state))

; Now we have time:
; [@user-history 0] => state at t0
; [@user-history 1] => state at t1
; Can reason about any point in time
```

**Application: Event Sourcing**:
```clojure
; Don't store current state
; Store events (facts that happened)
(def events [
  {:type :user-created :id 1 :name "Alice" :timestamp t0}
  {:type :user-renamed :id 1 :name "Alice Smith" :timestamp t1}
  {:type :email-changed :id 1 :email "new@email.com" :timestamp t2}
])

; Current state is derived from events
; Can reconstruct state at any point in time
; Events are immutable facts
```

---

### 6. Information vs. Place

**What**: Information is facts. Places are mutable locations (variables, fields).

**Why**: Places complect facts with locations. Information separates them.

**The Problem with Places**:
```clojure
; Places (mutable locations)
var x = 5;
x = 10;  // What is x? Depends when you ask!

; Information (immutable facts)
(def fact-1 {:x 5 :time t0})
(def fact-2 {:x 10 :time t1})
; Clear what the value of x was at any time
```

**Hickey's Approach**:
- Minimize places (mutable state)
- Maximize information (immutable data)
- When mutation needed, use controlled reference types (atom, ref, agent)
- Most of your program should be pure functions on values

**Example**:
```clojure
; Place-oriented (complected):
class Counter {
    int value = 0;
    void increment() { value++; }
}
// When was value = 5? Can't tell.

; Information-oriented (simple):
(defn increment [counter]
  (update counter :value inc))

(def counter-t0 {:value 0 :timestamp t0})
(def counter-t1 (increment counter-t0))  ; {:value 1 ...}
(def counter-t2 (increment counter-t1))  ; {:value 2 ...}

; All states preserved
; Clear progression
; Can reason about any point
```

---

### 7. Accidental vs. Essential Complexity

**What**: Essential complexity is inherent to the problem. Accidental complexity is introduced by our solutions.

**Why**: Most complexity in software is accidental - we create it through our choices.

**Hickey's Sources of Accidental Complexity**:
- **State** - Mutable state braids location and value
- **Object identity** - Complects identity and state
- **Imperative loops** - Complects what and how
- **Syntax** - Can obscure meaning
- **Frameworks** - Can force complecting

**Reducing Accidental Complexity**:
```clojure
; Accidental: Imperative loop (what + how complected)
total = 0
for (i = 0; i < items.length; i++) {
    total += items[i].price
}

; Essential: What we want (how is abstracted)
(reduce + (map :price items))

; Accidental: Mutable object (state + identity + time complected)
class ShoppingCart {
    items = []
    total = 0

    addItem(item) {
        this.items.push(item)
        this.total += item.price
    }
}

; Essential: Immutable data + pure functions
(defn add-item [cart item]
  (update cart :items conj item))

(defn total [cart]
  (reduce + (map :price (:items cart))))
```

---

### 8. Functional Programming: Not About Functions

**What**: FP is about programming with values, not with mutable state.

**Why**: Values + pure functions = simple, composable, testable systems.

**Hickey's FP Principles**:
- **Immutability** - Values don't change
- **Pure functions** - Same input → same output, no side effects
- **Composition** - Build complex from simple
- **First-class functions** - Functions as values

**Example**:
```clojure
; Pure functions are simple
(defn discount [price rate]
  (* price (- 1 rate)))

(discount 100 0.1)  ; => 90
(discount 100 0.1)  ; => 90 (always)

; Easy to test
(assert (= 90 (discount 100 0.1)))

; Easy to compose
(defn apply-discounts [price & rates]
  (reduce discount price rates))

(apply-discounts 100 0.1 0.05)  ; => 85.5

; No state, no time, no complexity
```

**vs. OOP Approach**:
```java
class DiscountCalculator {
    private double baseRate = 0.0;
    private boolean hasApplied = false;

    public double apply(double price, double rate) {
        if (hasApplied) {
            rate = rate + baseRate;  // Stateful behavior
        }
        hasApplied = true;
        return price * (1 - rate);
    }
}

// Complex: State, mutation, temporal coupling
// Hard to test: Depends on internal state
// Hard to compose: Stateful side effects
```

---

### 9. Design is About Taking Things Apart

**What**: Good design separates concerns. Bad design tangles them.

**Why**: Tangled concerns are hard to understand, change, and reuse.

**Hickey's Approach**:
```
Design is not about putting things together.
Design is about taking things apart.

Separate:
- Policy from mechanism
- What from how
- Data from behavior
- Logic from effects
- Queries from commands
```

**Example**:
```clojure
; Tangled: HTTP, business logic, database all mixed
(defn create-user-endpoint [request]
  (let [params (:params request)
        user {:name (:name params)
              :email (:email params)}]
    (jdbc/insert! db :users user)  ; Database
    (send-welcome-email user)      ; Side effect
    {:status 200 :body "User created"}))  ; HTTP

; Separated: Each concern is simple
(defn validate-user [user]
  (if (valid-email? (:email user))
    {:valid true :user user}
    {:valid false :error "Invalid email"}))

(defn create-user [user]
  ; Just the logic, returns a value
  (assoc user :created-at (now)))

(defn save-user [db user]
  ; Just the persistence
  (jdbc/insert! db :users user))

(defn create-user-endpoint [request]
  ; Orchestrates, but each piece is simple
  (let [user (-> request :params (select-keys [:name :email]))
        validation (validate-user user)]
    (if (:valid validation)
      (let [new-user (create-user (:user validation))]
        (save-user db new-user)
        (queue-email {:type :welcome :user new-user})
        {:status 200 :body "User created"})
      {:status 400 :body (:error validation)})))
```

---

### 10. Simplicity is a Choice

**What**: Simplicity doesn't happen accidentally. You have to choose it.

**Why**: Teams often choose "easy" (familiar tools, patterns) over "simple" (well-designed solutions).

**Hickey's Challenge**:
```
"We can choose to make things simple or complex.
We can choose to make things easy or hard.
Simple and easy are not the same thing.
Choose simple, even when it's not easy."
```

**How to Choose Simple**:
1. **Learn** - Invest time in understanding simple approaches
2. **Question** - Challenge familiar but complex patterns
3. **Resist** - Don't default to "easy" just because it's comfortable
4. **Design** - Take time to separate concerns properly
5. **Value** - Prioritize simplicity in your team's values

**Example Choices**:
```
Complex (but easy/familiar):
- OOP with mutable state
- Frameworks that do everything
- Magic/implicit behavior
- Inheritance hierarchies

Simple (but may require learning):
- Pure functions + immutable data
- Libraries (not frameworks)
- Explicit over implicit
- Composition over inheritance
```

---

## Hickey's Design Process

### "Hammock-Driven Development"

**What**: Take time to think deeply about problems before coding.

**Process**:
1. **Identify Problem** - What are you really solving?
2. **Understand Context** - What are the constraints?
3. **Gather Information** - Research existing solutions
4. **Think** - Step away from computer, think deeply
5. **Let it Simmer** - Sleep on it, subconscious processes
6. **Return** - Come back with clearer understanding
7. **Design** - Sketch out simple solution
8. **Implement** - Now write code

**Key Insight**: "The most important design work happens away from the keyboard."

---

## Clojure: Philosophy in Practice

### Language Design Choices

**Immutability by Default**:
```clojure
(def v [1 2 3])
(conj v 4)  ; => [1 2 3 4]
v  ; => [1 2 3]  (unchanged)

; Mutation requires explicit reference types
(def a (atom [1 2 3]))
(swap! a conj 4)
@a  ; => [1 2 3 4]
```

**Data as Code**:
```clojure
; Code is data (homoiconicity)
'(defn hello [name]
   (str "Hello, " name))

; Data is code
(eval '(+ 1 2))  ; => 3

; Macros manipulate code as data
(defmacro when-not [test & body]
  `(if (not ~test)
     (do ~@body)))
```

**Simplicity in Syntax**:
```clojure
; Minimal syntax - everything is (fn arg1 arg2 ...)
(+ 1 2)
(map inc [1 2 3])
(defn hello [name] (str "Hello " name))

; vs. Java's varied syntax:
1 + 2
list.map(x -> x + 1)
public String hello(String name) { return "Hello " + name; }
```

---

## Applying Hickey's Philosophy

### For Individual Developers

**Mindset Shifts**:
- Choose simple over easy/familiar
- Separate concerns ruthlessly
- Use values and pure functions
- Accept that simple requires learning

**Daily Practices**:
- Design before coding (hammock time)
- Identify what you're complecting
- Prefer immutable data
- Write pure functions
- Test with data, not mocks

### For Teams

**Cultural Values**:
- Value simplicity over convenience
- Invest in learning simple approaches
- Take design time seriously
- Prefer composition to frameworks
- Explicit over implicit

**Code Review Focus**:
- Are concerns separated?
- Is state minimized?
- Are functions pure?
- Is the design simple?
- What's being complected?

### For Projects

**Architecture Choices**:
- Immutable data structures
- Pure business logic
- Controlled effects at boundaries
- Event sourcing for temporal needs
- Functional core, imperative shell

---

## Anti-Patterns to Avoid

### ❌ Conflating Easy with Simple

```
Don't choose:
- Familiar but complex patterns
- Convenient but tangled designs
- Easy now but hard later

Do choose:
- Simple even if unfamiliar
- Separated even if more pieces
- Hard now (learning) but easy later
```

### ❌ Premature Abstraction

```clojure
; Don't abstract before you understand
(defprotocol Saveable
  (save [this db])
  (update [this db]))

; Do: Use data and functions
(defn save-entity [db entity-type entity]
  (jdbc/insert! db entity-type entity))
```

### ❌ Stateful Objects

```clojure
; Avoid: Mutable objects
(deftype Counter [^:unsynchronized-mutable count]
  (inc! [this] (set! count (+ count 1))))

; Prefer: Immutable data + pure functions
(defn increment [counter]
  (update counter :count inc))
```

---

## Key Talks and References

### Essential Viewing

1. **"Simple Made Easy"** (Strange Loop 2011)
   - Defines simple vs. easy
   - Core philosophy talk
   - Required watching

2. **"The Value of Values"** (JaxConf 2012)
   - Why immutability matters
   - Values vs. places
   - Programming with facts

3. **"Hammock Driven Development"** (Clojure/conj 2010)
   - Design process
   - Thinking before coding
   - Problem solving approach

4. **"Are We There Yet?"** (JVM Language Summit 2009)
   - Time, identity, and state
   - Why OOP fails at concurrency
   - How to think about change

5. **"Design, Composition, and Performance"** (2013)
   - Taking things apart
   - Building simple systems
   - Performance without complexity

### Books

- **"Clojure for the Brave and True"** - Daniel Higginbotham
- **"The Joy of Clojure"** - Michael Fogus & Chris Houser
- **"Clojure Applied"** - Ben Vandgrift & Alex Miller

---

## Summary

Rich Hickey's philosophy emphasizes:

1. **Simple ≠ Easy** - Choose simplicity even when it's not convenient
2. **Avoid Complecting** - Don't braid together unrelated concerns
3. **Values** - Use immutable data as the foundation
4. **Separation** - Identity, state, time, and behavior are separate
5. **Information > Places** - Favor facts over mutable locations
6. **Essential Only** - Avoid accidental complexity
7. **Pure Functions** - Most code should be pure transformations
8. **Design First** - Think deeply before coding
9. **Take Apart** - Design is about separating, not combining
10. **Choose Simplicity** - It's a deliberate choice, not an accident

**Core Belief**: "Simplicity is prerequisite for reliability." - Edsger W. Dijkstra (quoted by Hickey)

---

*"We can make the same exact software we are making today with dramatically simpler stuff — dramatically simpler languages, tools, techniques — and we should." - Rich Hickey*
