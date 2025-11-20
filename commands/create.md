---
name: Create Custom Philosophy
description: Create a custom philosophy by blending multiple existing philosophies through guided interview
---

You are helping the user create a custom coding philosophy by blending multiple existing philosophies.

This is an interactive, multi-phase process. Take your time and guide the user through each step.

## Phase 1: Philosophy Selection

List available philosophies from `${CLAUDE_PLUGIN_ROOT}/philosophies/` grouped by category:

```text
# Create Your Custom Philosophy

Select 2-4 philosophies to blend together:

## 👤 People Philosophies
1. John Carmack - Performance & Deep Understanding
2. Linus Torvalds - Pragmatic Systems Programming
3. Martin Fowler - Clean Code & Refactoring
4. Donald Knuth - Literate Programming & Correctness
5. Rich Hickey - Simplicity & Functional Design
[... list all ...]

## 📚 Methodology Philosophies
1. TDD - Test-Driven Development
2. Clean Code - Readability & Maintainability
3. Functional Programming - Immutability & Pure Functions
4. Conventional Commits - Clear Commit Messages

## 💻 Language Philosophies
1. Python - Zen of Python
2. Rust - Safety & Performance

Select 2-4 by name (e.g., "John Carmack, TDD, Python"):
```

Wait for user's selection.

## Phase 2: Analyze Selected Philosophies

For each selected philosophy:

1. Read the file from `${CLAUDE_PLUGIN_ROOT}/philosophies/`
2. Extract key dimensions:
   - Testing approach (TDD, test-after, minimal)
   - Performance focus (optimize early, profile-then-optimize, simplicity-first)
   - Code style (pragmatic, academic, craftsman-like)
   - Simplicity (YAGNI, extensible, pattern-heavy)

## Phase 3: Dynamic Interview

Based on detected dimensions, ask relevant questions. Ask one question at a time, wait for answer before proceeding.

### Testing Questions (if TDD or testing-focused philosophy selected)

**Question**: "How do you prefer to test code?"

- a) Write tests first (TDD - test drives design)
- b) Write tests after implementation
- c) Focus on integration/E2E tests
- d) Test critical paths only

### Performance Questions (if Carmack, systems programming, or performance philosophy selected)

**Question**: "When there's a tradeoff between performance and simplicity:"

- a) Performance first - optimize early
- b) Balanced - profile then optimize bottlenecks
- c) Simplicity first - optimize only when needed

### Simplicity Questions (if applicable)

**Question**: "Your approach to code design:"

- a) YAGNI - build only what's needed now
- b) Plan for future extensibility
- c) Use design patterns proactively

### Style Questions (always ask)

**Question**: "Which best describes your coding style?"

- a) Fast iteration, break things, learn quickly
- b) Careful design, polished code, attention to detail
- c) Ship working software, iterate based on feedback
- d) Correctness first, well-researched solutions

### Additional Questions (based on selections)

- Architecture preferences
- Documentation approach
- Refactoring philosophy
- Tool investment mindset

## Phase 4: Calculate Weights

Based on answers, assign weights to each selected philosophy:

- Start with equal weights (e.g., 3 philosophies = 33% each)
- Adjust based on answers:
  - If user chose "tests first" → boost TDD weight by 20%
  - If user chose "performance first" → boost Carmack/systems weight by 20%
  - If user chose "simplicity first" → boost Python/minimalist weight by 20%
  - If user chose "pragmatic" style → boost Torvalds/practical philosophy weight

Normalize weights to sum to 100%.

## Phase 5: Blend Philosophies

Create a new philosophy by:

1. **Generate Title**: "Custom Philosophy: [Blend Description]"
   - Example: "Custom Philosophy: Test-Driven Performance with Pragmatic Python"

2. **Generate Tagline**: Combine taglines from selected philosophies
   - Example: "Red-Green-Refactor meets Performance-First Development"

3. **Write Overview**: Explain the blend

   ```markdown
   This custom philosophy blends:
   - 40% Test-Driven Development (TDD)
   - 35% John Carmack's Performance Philosophy
   - 25% Python's Zen

   It emphasizes writing tests first to drive design, while maintaining
   performance awareness and Python's principle of explicit, readable code.
   ```

4. **Select Top Principles**: From each philosophy, extract principles weighted by percentage
   - Read principles from each source file
   - Rank by weight
   - Select top 8-10 principles
   - Cite sources for each principle

5. **Format Principles**: For each principle, create a blended version:

   ```markdown
   ### 1. Test-Driven Performance

   **What**: Write tests first, but profile and optimize bottlenecks ruthlessly

   **Why**: TDD drives better design (from TDD philosophy), while performance
   awareness ensures code is production-ready (from Carmack philosophy).

   **Example**: [Code example showing TDD with performance profiling]

   *Blended from: TDD Philosophy (40%) + John Carmack Philosophy (35%)*
   ```

6. **Include Anti-Patterns**: Merge anti-patterns from all sources

7. **Add Attribution Footer**:

   ```markdown
   ---

   *This custom philosophy was created by blending:*
   - *[Philosophy 1 Name] ([Weight]%)*
   - *[Philosophy 2 Name] ([Weight]%)*
   - *[Philosophy 3 Name] ([Weight]%)*

   *Created with Philosophy.md Plugin: https://github.com/bxm156/Philosophy.md*
   ```

## Phase 6: Generate Final File

Write the complete blended philosophy to `PHILOSOPHY.md` in the user's project root.

## Phase 7: Confirm Completion

Show success message:

```text
✅ Custom philosophy created and saved to PHILOSOPHY.md!

Your philosophy blends:
- [Philosophy 1]: [Weight]%
- [Philosophy 2]: [Weight]%
- [Philosophy 3]: [Weight]%

Start coding according to your custom principles!
```

## Important Notes

- Take your time with each phase
- Only ask ONE question at a time
- Wait for user responses
- Be conversational and encouraging
- The blended output should feel cohesive, not like stitched-together parts
- Cite sources but don't make it feel mechanical
- Adjust weights thoughtfully based on user's answers
- Make sure the final philosophy is actionable and clear

## Arguments

None - this is a fully interactive command