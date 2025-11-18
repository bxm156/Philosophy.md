---
layout: default
title: Brian Kernighan
parent: People
grand_parent: Philosophies
nav_order: 5
---

# Brian Kernighan's Programming Philosophy

> "Controlling complexity is the essence of computer programming."

## Overview

Brian Kernighan is a legendary computer scientist who co-authored "The C Programming Language" (K&R) with Dennis Ritchie, coined the term "Unix," and contributed to AWK. His philosophy emphasizes clarity, simplicity, and the craft of writing programs that are easy to understand and maintain.

**Key Contributions**:
- "The C Programming Language" (K&R)
- AWK programming language
- "The Unix Programming Environment"
- "The Elements of Programming Style"
- Coined "Hello, World!" program

**Core Philosophy**: Write clear code that humans can understand. Programs should be written for people to read first, machines to execute second.

---

## Core Principles

### 1. Write Clearly—Don't Be Too Clever

**Philosophy**: Clever code is hard to understand and maintain. Clear code wins.

```c
// ❌ Clever
a ^= b ^= a ^= b;

// ✅ Clear
int temp = a;
a = b;
b = temp;

// ❌ Clever
return n ? n * f(n-1) : 1;

// ✅ Clear
if (n == 0)
    return 1;
return n * factorial(n - 1);
```

---

### 2. Say What You Mean Simply and Directly

```c
// ❌ Roundabout
if (!(n < 0 || n > 100))
    process(n);

// ✅ Direct
if (n >= 0 && n <= 100)
    process(n);

// ❌ Verbose
if (condition == true)

// ✅ Direct
if (condition)
```

---

### 3. Use Library Functions

**Philosophy**: Don't reinvent what already exists and works.

```c
// ❌ Reinventing
int my_strlen(char *s) {
    int n = 0;
    while (*s++)
        n++;
    return n;
}

// ✅ Use the library
#include <string.h>
int len = strlen(s);
```

---

### 4. Make Sure Comments and Code Agree

```c
// ❌ Misleading comment
// increment i
i = i - 1;

// ✅ Accurate or no comment needed
i--;  // Self-documenting

// ✅ Comment explains why, not what
// Decrement to convert 1-based index to 0-based
i--;
```

---

### 5. Don't Comment Bad Code—Rewrite It

```c
// ❌ Commenting bad code
// This complicated expression calculates...
x = (a ? b : c) + (d < e ? f : g) * (h || i && j);

// ✅ Rewrite clearly
int base = a ? b : c;
int multiplier = (d < e) ? f : g;
int flag = h || (i && j);
x = base + multiplier * flag;
```

---

### 6. Make Sure Input Cannot Violate Limits

```c
// ❌ Unsafe
char buffer[100];
gets(buffer);  // No bounds checking!

// ✅ Safe
char buffer[100];
fgets(buffer, sizeof(buffer), stdin);
```

---

### 7. Test Programs at Their Boundary Conditions

```c
// Test edge cases
void test_factorial() {
    assert(factorial(0) == 1);   // Zero
    assert(factorial(1) == 1);   // One
    assert(factorial(5) == 120); // Normal
    // What about negative? MAX_INT?
}
```

---

### 8. Program Defensively

```c
// Check all assumptions
int divide(int a, int b) {
    if (b == 0) {
        fprintf(stderr, "divide by zero\n");
        return 0;  // Or handle appropriately
    }
    return a / b;
}

// Validate inputs
FILE *open_file(const char *name) {
    if (name == NULL) {
        return NULL;
    }
    return fopen(name, "r");
}
```

---

### 9. Make It Right Before You Make It Fast

```c
// First: correct and clear
int search(int arr[], int n, int target) {
    for (int i = 0; i < n; i++) {
        if (arr[i] == target)
            return i;
    }
    return -1;
}

// Then: optimize if needed (after profiling)
// Binary search, hash table, etc.
```

---

### 10. Keep It Simple

```c
// ❌ Over-engineered
typedef struct {
    int (*compare)(void*, void*);
    void (*swap)(void*, void*);
    int (*partition)(void*, int, int);
} SortStrategy;

// ✅ Simple
void sort(int arr[], int n) {
    qsort(arr, n, sizeof(int), compare_ints);
}
```

---

## The Elements of Programming Style

Key rules from Kernighan's famous book:

1. Write clearly—don't be too clever
2. Say what you mean, simply and directly
3. Use library functions whenever feasible
4. Avoid temporary variables
5. Write clearly—don't sacrifice clarity for efficiency
6. Let the machine do the dirty work
7. Replace repetitive expressions by calls to a common function
8. Parenthesize to avoid ambiguity
9. Choose variable names that won't be confused
10. Avoid unnecessary branches
11. Use the good features of a language; avoid the bad ones
12. Don't use conditional branches as a substitute for a logical expression
13. Use the "telephone test" for readability

---

## Anti-Patterns to Avoid

### ❌ Magic Numbers

```c
// Bad
if (status == 7) { ... }

// Good
#define STATUS_COMPLETE 7
if (status == STATUS_COMPLETE) { ... }
```

### ❌ Deep Nesting

```c
// Bad
if (a) {
    if (b) {
        if (c) {
            if (d) {
                do_thing();
            }
        }
    }
}

// Good
if (!a || !b || !c || !d)
    return;
do_thing();
```

### ❌ Overly Long Functions

```c
// Bad: 500-line function

// Good: Break into meaningful pieces
void process_order() {
    validate_order();
    calculate_total();
    process_payment();
    send_confirmation();
}
```

---

## Quotes

> "Controlling complexity is the essence of computer programming."

> "Debugging is twice as hard as writing the code in the first place. Therefore, if you write the code as cleverly as possible, you are, by definition, not smart enough to debug it."

> "Don't comment bad code—rewrite it."

> "Everyone knows that debugging is twice as hard as writing a program in the first place."

---

## Summary

Brian Kernighan's philosophy centers on **clarity and simplicity**:

1. **Write clearly** - Don't be clever
2. **Be direct** - Say what you mean
3. **Use libraries** - Don't reinvent wheels
4. **Accurate comments** - Or better, self-documenting code
5. **Rewrite bad code** - Don't paper over with comments
6. **Validate input** - Defensive programming
7. **Test boundaries** - Edge cases matter
8. **Program defensively** - Assume things go wrong
9. **Correctness first** - Then optimize
10. **Keep it simple** - Complexity is the enemy

Kernighan's work proves that the best programs are those that humans can read, understand, and maintain. The code that lasts is the code that's clear.

---

## Further Reading

- "The C Programming Language" by Kernighan and Ritchie
- "The Elements of Programming Style" by Kernighan and Plauger
- "The Unix Programming Environment" by Kernighan and Pike
- "The Practice of Programming" by Kernighan and Pike
- "The AWK Programming Language" by Aho, Kernighan, and Weinberger
