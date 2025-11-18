---
layout: default
title: Bjarne Stroustrup
parent: People
grand_parent: Philosophies
nav_order: 3
---

# Bjarne Stroustrup's Programming Philosophy

> "C++ is designed to allow you to express ideas, but if you don't have ideas or don't have any clue about how to express them, C++ doesn't offer much help."

## Overview

Bjarne Stroustrup is the creator of C++, one of the most widely used programming languages in history. His philosophy centers on zero-overhead abstractions, multi-paradigm programming, and compatibility with C while adding powerful abstraction mechanisms. C++ is designed to be a "light-weight abstraction programming language."

**Key Contributions**:
- C++ programming language
- "The C++ Programming Language" book
- C++ Core Guidelines
- ISO C++ standardization

**Core Philosophy**: Don't sacrifice efficiency for abstraction. Provide powerful mechanisms that experts can use correctly. Maintain compatibility with C. Enable multiple programming paradigms.

---

## Core Principles

### 1. Zero-Overhead Abstraction

**Philosophy**: You shouldn't pay for what you don't use. Abstractions should compile to optimal code.

```cpp
// C++ abstractions have no overhead compared to manual code

// Class with encapsulation
class Point {
    int x, y;
public:
    int getX() const { return x; }
    int getY() const { return y; }
};

// Compiles to same code as:
struct Point {
    int x, y;
};

// The getX() call is inlined - zero overhead

// Templates generate optimal code
template<typename T>
T max(T a, T b) {
    return (a > b) ? a : b;
}

// max<int>(3, 5) generates optimal int comparison
// No virtual dispatch, no runtime type checks
```

---

### 2. What You Don't Use, You Don't Pay For

**Philosophy**: Features should have no cost unless you use them.

```cpp
// Don't use exceptions? No exception handling overhead
// Don't use RTTI? No runtime type information
// Don't use virtual functions? No vtable

class Simple {
    int value;
public:
    int get() const { return value; }  // No overhead
};

class WithVirtual {
    int value;
public:
    virtual int get() const { return value; }  // vtable added
};

// Simple has sizeof == sizeof(int)
// WithVirtual has sizeof == sizeof(int) + sizeof(void*)

// You choose your trade-offs
```

---

### 3. Multi-Paradigm Support

**Philosophy**: No single paradigm fits all problems. C++ supports procedural, object-oriented, generic, and functional programming.

```cpp
// Procedural
int square(int x) { return x * x; }

// Object-oriented
class Shape {
public:
    virtual double area() const = 0;
};

// Generic
template<typename Container>
auto sum(const Container& c) {
    return std::accumulate(c.begin(), c.end(), 0);
}

// Functional
auto squares = numbers | std::views::transform([](int x) { return x * x; });

// Use what fits the problem
```

---

### 4. Direct Hardware Access

**Philosophy**: Systems programming requires working close to the hardware. C++ allows this while providing abstractions.

```cpp
// Memory-mapped I/O
volatile uint32_t* GPIO = reinterpret_cast<uint32_t*>(0x40020000);
*GPIO = 0xFF;  // Direct hardware access

// Placement new for memory control
char buffer[sizeof(Object)];
Object* obj = new (buffer) Object();

// Bit manipulation
uint32_t flags = 0;
flags |= (1 << 3);   // Set bit 3
flags &= ~(1 << 5);  // Clear bit 5
```

---

### 5. Type Safety with Escape Hatches

**Philosophy**: Strong type safety by default, but provide ways to bypass when necessary.

```cpp
// Type-safe
std::vector<int> numbers;
numbers.push_back(42);
// numbers.push_back("string");  // Compile error

// Escape hatch when needed
void legacy_api(void* data, size_t size);
int value = 42;
legacy_api(&value, sizeof(value));  // Type-unsafe but possible

// Modern: type-safe generic code
template<typename T>
void process(T&& value) {
    // Works with any type
}
```

---

### 6. RAII (Resource Acquisition Is Initialization)

**Philosophy**: Bind resource lifetime to object lifetime. Constructors acquire, destructors release.

```cpp
// RAII for memory
class Buffer {
    std::unique_ptr<char[]> data;
public:
    Buffer(size_t size) : data(std::make_unique<char[]>(size)) {}
    // Destructor automatically frees memory
};

// RAII for files
class File {
    FILE* handle;
public:
    File(const char* name) : handle(fopen(name, "r")) {
        if (!handle) throw std::runtime_error("Cannot open file");
    }
    ~File() { if (handle) fclose(handle); }
};

// RAII for locks
{
    std::lock_guard<std::mutex> lock(mutex);
    // Critical section
}  // Lock released automatically
```

---

### 7. Compile-Time Computation

**Philosophy**: Move computation from runtime to compile time for efficiency.

```cpp
// constexpr for compile-time evaluation
constexpr int factorial(int n) {
    return (n <= 1) ? 1 : n * factorial(n - 1);
}

constexpr int fact5 = factorial(5);  // Computed at compile time

// Template metaprogramming
template<int N>
struct Fibonacci {
    static constexpr int value = Fibonacci<N-1>::value + Fibonacci<N-2>::value;
};

template<> struct Fibonacci<0> { static constexpr int value = 0; };
template<> struct Fibonacci<1> { static constexpr int value = 1; };

int fib10 = Fibonacci<10>::value;  // Computed at compile time
```

---

### 8. Backward Compatibility

**Philosophy**: Don't break existing code. C++ code from decades ago still compiles.

```cpp
// C code works in C++
extern "C" {
    int legacy_function(int x);
}

// Old C++ code still works
class OldStyle {
    int data;
public:
    OldStyle() : data(0) {}  // C++98 syntax still valid
};

// New features are additions, not replacements
// auto, lambdas, move semantics - all additions
```

---

### 9. Expressiveness Over Safety

**Philosophy**: Trust expert programmers. Provide power even if it can be misused.

```cpp
// Raw pointers for when you need them
int* p = new int(42);
*p = 100;
delete p;

// Pointer arithmetic
int arr[10];
int* p = arr;
*(p + 5) = 42;

// Type casting
double d = 3.14;
int i = static_cast<int>(d);
void* v = reinterpret_cast<void*>(p);

// Power tools for experts
```

---

### 10. The Language Must Be Efficient

**Philosophy**: C++ must be competitive with C and assembly for performance-critical code.

```cpp
// Inline functions
inline int square(int x) { return x * x; }

// Move semantics avoid copies
std::vector<int> create() {
    std::vector<int> v = {1, 2, 3};
    return v;  // Moved, not copied
}

// Small object optimization
std::string short_str = "hi";  // No heap allocation

// Cache-friendly data structures
std::vector<int> data;  // Contiguous memory
```

---

## Anti-Patterns to Avoid

### ❌ Raw Memory Management

```cpp
// Bad: Manual memory management
int* p = new int(42);
// ... might forget delete or exception thrown
delete p;

// Good: RAII with smart pointers
auto p = std::make_unique<int>(42);
// Automatically deleted
```

### ❌ Naked new/delete

```cpp
// Bad
Widget* w = new Widget();
// ...
delete w;

// Good
auto w = std::make_unique<Widget>();
// Or
auto w = std::make_shared<Widget>();
```

### ❌ C-style Casts

```cpp
// Bad
int* p = (int*)malloc(sizeof(int));

// Good
int* p = static_cast<int*>(malloc(sizeof(int)));
// Or better: avoid malloc in C++
auto p = std::make_unique<int>();
```

---

## Summary

Bjarne Stroustrup's philosophy centers on **efficiency without sacrificing abstraction**:

1. **Zero-overhead abstraction** - Abstractions as efficient as manual code
2. **Don't pay for unused features** - No hidden costs
3. **Multi-paradigm** - Right tool for each problem
4. **Hardware access** - Systems programming capability
5. **Type safety with escape hatches** - Safe but flexible
6. **RAII** - Resource safety through object lifetime
7. **Compile-time computation** - Move work to compilation
8. **Backward compatibility** - Protect existing code
9. **Expressiveness** - Power for experts
10. **Efficiency** - Competitive with C/assembly

C++ proves that high-level abstractions don't require sacrificing performance. The language gives you enough rope to hang yourself—but also enough to build bridges.

---

## Further Reading

- "The C++ Programming Language" by Bjarne Stroustrup
- "A Tour of C++" by Bjarne Stroustrup
- "C++ Core Guidelines" - isocpp.github.io/CppCoreGuidelines
- "Design and Evolution of C++" by Bjarne Stroustrup
