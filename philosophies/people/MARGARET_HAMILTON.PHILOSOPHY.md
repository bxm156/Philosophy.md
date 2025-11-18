---
layout: default
title: Margaret Hamilton
parent: People
grand_parent: Philosophies
nav_order: 15
---

# Margaret Hamilton's Programming Philosophy

> "There was no choice but to be pioneers."

## Overview

Margaret Hamilton led the team that developed the onboard flight software for NASA's Apollo missions. She coined the term "software engineering" to give the discipline the respect it deserved. Her philosophy emphasized rigorous error handling, human factors in software design, and treating software development as a true engineering discipline.

**Key Contributions**:
- Apollo Guidance Computer software
- Coined "software engineering"
- Priority-based task scheduling
- Asynchronous software design
- Error detection and recovery systems

**Core Philosophy**: Software is engineering. Anticipate what can go wrong. Design systems that protect against human error.

---

## Core Principles

### 1. Software Engineering is Engineering

**Philosophy**: Software development deserves the same rigor as other engineering disciplines.

```
Hamilton coined "software engineering" because:
- Software was not taken seriously ("just programming")
- Errors could be catastrophic
- It required the same discipline as hardware engineering

"I fought to bring the software legitimacy so that it
 and those building it would be given their due respect."
```

---

### 2. Anticipate Everything That Can Go Wrong

**Philosophy**: Design for failure. Assume everything that can happen will happen.

```c
// Apollo approach: Expect the unexpected

// Priority-based scheduling
// If astronaut entered wrong command during critical phase,
// system would prioritize essential tasks

void schedule_tasks() {
    if (memory_full || cpu_overloaded) {
        // Kill lower-priority tasks
        // Keep essential navigation running
        // This saved Apollo 11 landing
    }
}

// The famous "1202 alarm"
// System detected overload
// Shed non-essential tasks
// Landing continued successfully
```

---

### 3. Design Out Human Error

**Philosophy**: People make mistakes. Systems should prevent or recover from them.

```c
// Hamilton's insight: Anticipate user error

// Before launch, her daughter (playing astronaut)
// selected "launch" during simulation
// This crashed the simulator

// Hamilton wanted to add protection
// NASA said "astronauts won't make that mistake"

// On Apollo 8, astronaut Jim Lovell did exactly that
// Erased navigation data
// Had to upload from ground

// Lesson: Always protect against human error
// Don't assume users won't make mistakes
```

---

### 4. Asynchronous Processing

**Philosophy**: Systems must handle multiple things happening at once.

```c
// Apollo software was asynchronous
// Multiple sensors, inputs, outputs
// Everything happening in parallel

// Not sequential:
read_sensor();
calculate();
display();

// Asynchronous:
// - Sensors updating continuously
// - Calculations running in background
// - Display refreshing
// - User input possible any time
// - All managed by priority scheduler
```

---

### 5. Rigor in Testing

**Philosophy**: Test everything. Simulate every scenario.

```
Apollo software was exhaustively tested:
- Every code path exercised
- Every error condition simulated
- Hardware-in-the-loop testing
- Mission simulations

"We were not allowed to be incomplete in any way."

Testing approach:
1. Desk checking
2. Code review
3. Unit testing
4. Integration testing
5. Full mission simulation
6. With human astronauts in the loop
```

---

### 6. Documentation

**Philosophy**: Document everything. Others must understand your work.

```
Apollo software was fully documented:
- Every module documented
- Design rationale recorded
- Requirements traced
- Test cases documented

Stack of Apollo printouts was taller than Hamilton (5'1")

"The software had to be perfect because people's lives depended on it."
```

---

### 7. Team and Leadership

**Philosophy**: Great software comes from great teams.

```
Hamilton led by:
- Setting high standards
- Trusting team members
- Encouraging innovation
- Taking responsibility

"The culture was to learn from everyone and everything,
 including from one's mistakes."
```

---

### 8. Priority Scheduling

**Philosophy**: When resources are scarce, do the most important things first.

```c
// Apollo's priority system

#define PRIORITY_CRITICAL 1  // Navigation
#define PRIORITY_HIGH     2  // Life support
#define PRIORITY_MEDIUM   3  // Communications
#define PRIORITY_LOW      4  // Display updates

void executive_scheduler() {
    // Always run highest priority task
    // Preempt lower priority if needed
    // This saved Apollo 11 during the "1202 alarm"

    if (current_task.priority > new_task.priority) {
        preempt(current_task);
        run(new_task);
    }
}
```

---

### 9. Redundancy and Recovery

**Philosophy**: Systems must continue operating despite failures.

```c
// Apollo software had multiple recovery mechanisms

void handle_error() {
    // Log the error
    record_error(error_code);

    // Attempt recovery
    if (can_recover()) {
        recover();
        continue_operation();
    } else {
        // Graceful degradation
        switch_to_backup();
        alert_crew();
    }

    // Never just crash
}
```

---

### 10. No Second Chances

**Philosophy**: When failure is not an option, you must get it right.

```
"We had to find a way and do it right the first time.
 There would be no second chance."

Apollo constraints:
- 72 kilobytes of memory
- 2 MHz processor
- Lives at stake
- No patches after launch

This drove:
- Careful design
- Rigorous testing
- Complete documentation
- Defensive programming
```

---

## Anti-Patterns to Avoid

### ❌ "The User Won't Do That"

```c
// Bad: Assuming users are perfect
if (input == expected) {
    process(input);
}
// What if input is wrong?

// Good: Design for human error
if (is_valid(input)) {
    process(input);
} else {
    alert_user();
    request_confirmation();
}
```

### ❌ Untested Error Paths

```c
// Bad: Error handling never tested
try {
    do_operation();
} catch (error) {
    // Never tested this path!
    handle_error();
}

// Good: Test every branch
// Simulate every error condition
```

### ❌ Inadequate Documentation

```
// Bad: Code without context
// "Future me will remember what this does"

// Good: Document the why
// Explain design decisions
// Future maintainers depend on it
```

---

## Quotes

> "There was no choice but to be pioneers."

> "Looking back, we were the luckiest people in the world. There was no choice but to be pioneers."

> "Software during the early days was treated like a stepchild."

> "I began to use the term 'software engineering' to distinguish it from hardware and other kinds of engineering."

---

## Summary

Margaret Hamilton's philosophy centers on **engineering rigor** and **error anticipation**:

1. **Software is engineering** - Treat it with rigor
2. **Anticipate failure** - Expect everything
3. **Design out human error** - People make mistakes
4. **Asynchronous processing** - Handle concurrency
5. **Rigorous testing** - Test every path
6. **Documentation** - Record everything
7. **Team leadership** - Great teams matter
8. **Priority scheduling** - Important first
9. **Redundancy** - Recover from failures
10. **No second chances** - Get it right

Hamilton's work on Apollo proved that software could be as reliable as hardware when developed with engineering discipline. Her principles remain essential for safety-critical systems today.

---

## Further Reading

- "NASA Office of Logic Design: Margaret Hamilton"
- Hamilton's 2016 Presidential Medal of Freedom citation
- "Makers: Women Who Make America" documentary
- IEEE Software article "What the Apollo Program Can Teach Us"
- MIT Instrumentation Laboratory papers
