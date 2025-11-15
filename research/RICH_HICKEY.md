# Rich Hickey: Creator of Clojure and Advocate for Simplicity

## Background

**Full Name**: Rich Hickey
**Born**: 1958 (approximate)
**Nationality**: American
**Famous For**:
- Creator of Clojure programming language
- Creator of Datomic database
- "Simple Made Easy" philosophy
- Functional programming advocate

## Major Contributions

### Clojure (2007)

Rich Hickey created Clojure, a modern Lisp dialect for the JVM:
- Functional programming language
- Emphasizes immutability
- Runs on JVM, CLR, and JavaScript (ClojureScript)
- Designed for concurrent programming

**Development**: Spent about 2½ years working on Clojure, much without external funding, before releasing in 2007

**Impact**: Brought functional programming and immutability to mainstream through JVM ecosystem

**Sources**:
- [Wikipedia - Rich Hickey](https://en.wikipedia.org/wiki/Rich_Hickey)
- [Eric Normand - Rich Hickey Profile](https://ericnormand.me/programmer-profiles/rich-hickey)

### Datomic (2012)

Created Datomic, a distributed database with novel architecture:
- Immutable database
- Temporal data model
- Bitemporal record keeping
- Separates reads from writes

**Philosophy**: Treat database as immutable sequence of facts that accumulate through time

**Impact**: Demonstrated practical applications of immutability at database level

**Source**: [InfoQ - Rich Hickey on Datomic](https://www.infoq.com/interviews/hickey-datomic-functional/)

### "Simple Made Easy" Talk (2011)

Delivered influential talk at QCon 2011 distinguishing simple from easy:
- Viral impact on software community
- Fundamental rethinking of complexity
- Widely referenced in technical discussions

**Impact**: Changed how developers think about software architecture and design

**Source**: [InfoQ - Simple Made Easy](https://www.infoq.com/presentations/Simple-Made-Easy/)

## Programming Philosophy

### Simple vs. Easy

**Core distinction**:
- **Simple**: Not tangled with other structures (one role, one task, one concept)
- **Easy**: Familiar or close to what we already know

**Key insight**: "Simplicity is objective; ease is relative."

**Problem**: Many choose easiness but end up with complexity

**Solution**: Choose easiness along the simplicity path

**Quote**: "Simplicity is not about counting things, it's about lack of interleaving."

**Sources**:
- [DEV Community - Simple Made Easy](https://dev.to/ruthmoog/on-simple-made-easy-by-rich-hickey-2olo)
- [Medium - Simple vs. Easy](https://kiksdium.medium.com/simple-vs-easy-bfd897ab293c)

### Composing Simple Components

**Philosophy**: Build robust software by composing simple components

**Approach**:
- Identify simple parts
- Keep them separate
- Compose them clearly
- Avoid tangling

**Benefit**: Simple components are:
- Easier to understand
- Easier to test
- Easier to change
- Easier to reuse

**Quote**: "Composing simple components is the key to robust software."

### Immutability

**Core principle**: Immutable data structures are fundamental

**Benefits**:
- Safer concurrent programming
- More predictable code
- Easier to reason about
- Time-based queries possible

**Opposition**: "Rich Hickey evangelizes the use of immutable values instead of mutable objects. He opposes the fundamental idea of Object Oriented Programming, which is to couple data with functionality."

**Source**: [InfoQ - Rich Hickey on Datomic](https://www.infoq.com/interviews/hickey-datomic-functional/)

### Place-Oriented Programming (PLOP)

**Critique**: Traditional programming focuses on "places" (variables) that change

**Problem**: Mutable state makes programs hard to understand

**Alternative**: Value-oriented programming
- Values don't change
- New values created instead
- Time becomes explicit
- State transitions trackable

**Datomic example**: Database as accumulation of immutable facts over time

## Clojure Design Philosophy

### Simplicity First

**Motivation**: Create language emphasizing simplicity, immutability, and functional paradigms

**Goal**: Facilitate concurrent programming in multi-core processor era

**Features**:
- Immutable data structures by default
- First-class functions
- Lisp syntax (minimal syntax)
- Hosted on JVM (practical interop)

### Functional Programming

**Philosophy**: Functions as primary abstraction

**Principles**:
- Pure functions preferred
- Immutable data structures
- First-class functions
- Composition over inheritance

**Benefit**: More predictable, testable, maintainable code

### Practical Lisp

**Goal**: Bring Lisp benefits to mainstream

**Compromises**:
- Run on JVM (access to libraries, tooling)
- Practical concurrency primitives
- Good Java interop
- Modern development experience

## Influence and Impact

### Changing How Developers Think

Hickey's talks and work influenced:
- Renewed interest in functional programming
- Immutability adoption in mainstream languages
- Rethinking complexity and simplicity
- Database design patterns

### Language Influence

Clojure concepts influenced:
- JavaScript (immutable.js)
- Python (functional features)
- Java (streams, optionals)
- Database design (event sourcing)

### Conference Talks

Hickey's talks are widely studied:
- "Simple Made Easy"
- "The Value of Values"
- "Spec-ulation"
- "Maybe Not"

**Impact**: Shaped technical discourse, widely referenced in design discussions

**Source**: [GitHub - Rich Hickey fanclub](https://github.com/tallesl/Rich-Hickey-fanclub)

## Development Approach

### Think Before Coding

**Philosophy**: Hammock-driven development

**Approach**:
- Think deeply about problem
- Let ideas percolate
- Don't rush to code
- Design in your mind first

**Quote from community**: "Every time I watch one of his talks I feel like someone has gone in and organized my brain."

### Long-Term Thinking

**Practice**: Spent 2½ years developing Clojure before release

**Philosophy**: Take time to get design right

**Benefit**: Well-thought-out designs last longer, need less revision

## Key Quotes

1. **On simplicity**: "Simplicity is not about counting things, it's about lack of interleaving."

2. **On simple vs. easy**: "Simple contrasts with complex while easy contrasts with hard."

3. **On composition**: "Composing simple components is the key to robust software."

4. **On immutability**: Evangelizes "immutable values instead of mutable objects."

5. **On thinking**: Advocates "hammock-driven development" - think before coding.

## Lessons from Rich Hickey

### For Software Architects

1. **Simple over easy**: Choose simplicity even when harder initially
2. **Avoid interleaving**: Keep concerns separate
3. **Compose components**: Build from simple, focused parts
4. **Think deeply**: Spend time designing before coding
5. **Question assumptions**: Challenge place-oriented programming

### For Developers

1. **Embrace immutability**: Immutable data simplifies reasoning
2. **Functional programming**: Pure functions are easier to test and understand
3. **Avoid complexity**: Complexity comes from interleaving, not size
4. **Value simplicity**: Simple is objective, not subjective
5. **Learn deeply**: Watch talks, think about principles

### For Language Designers

1. **Simplicity in syntax**: Minimal syntax reduces learning curve (Lisp)
2. **Immutability default**: Make immutable the easy path
3. **Practical concerns**: JVM hosting made Clojure practical
4. **Functional first**: First-class functions enable composition
5. **Time matters**: Make time explicit in design

## Legacy

Rich Hickey's contributions:
- Clojure brought functional programming to JVM
- Datomic demonstrated immutable databases
- "Simple Made Easy" changed design discussions
- Influenced multiple programming languages
- Elevated discourse on software complexity

His emphasis on simplicity, immutability, and deep thinking continues influencing how developers approach software design.

## References

1. Wikipedia. "Rich Hickey." https://en.wikipedia.org/wiki/Rich_Hickey
2. Eric Normand. "Rich Hickey." https://ericnormand.me/programmer-profiles/rich-hickey
3. InfoQ. "Simple Made Easy." https://www.infoq.com/presentations/Simple-Made-Easy/
4. DEV Community. "On 'Simple Made Easy' by Rich Hickey." https://dev.to/ruthmoog/on-simple-made-easy-by-rich-hickey-2olo
5. InfoQ. "Rich Hickey on Datomic, Data Storage, Functional Programming and Immutability." https://www.infoq.com/interviews/hickey-datomic-functional/
6. Medium. "Simple vs. Easy." https://kiksdium.medium.com/simple-vs-easy-bfd897ab293c
7. GitHub. "Rich Hickey fanclub." https://github.com/tallesl/Rich-Hickey-fanclub
