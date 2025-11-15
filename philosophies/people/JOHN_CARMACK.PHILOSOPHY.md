# John Carmack: Coding Philosophy

> Performance, Deep Understanding, and Relentless Optimization | Creator of Doom, Quake, and id Tech

## Overview

John Carmack's philosophy centers on performance-first development, deep technical understanding, and the belief that fast code enables new experiences. As the lead programmer behind landmark games like Doom and Quake, and pioneer of numerous 3D graphics techniques, Carmack demonstrates that technical excellence creates competitive advantage and revolutionary products.

## Core Principles

### 1. Performance Enables New Experiences

**What**: Fast code isn't just optimization—it enables entirely new possibilities.

**Why**: Performance breakthroughs create new categories of software. Carmack's optimizations made real-time 3D gaming possible on consumer hardware.

**Carmack's Approach**: Every frame matters. 60 FPS isn't a target, it's the minimum.

```c
// Carmack's performance philosophy in action

// ❌ Slow: Naive approach
for (int i = 0; i < num_objects; i++) {
    for (int j = 0; j < num_lights; j++) {
        CalculateLighting(objects[i], lights[j]);  // O(n²)
    }
}

// ✅ Fast: Spatial partitioning (BSP tree invented for Doom)
void RenderBSP(BSPNode* node, ViewFrustum* frustum) {
    if (!IntersectsFrustum(node->bounds, frustum))
        return;  // Cull entire subtree

    if (node->isLeaf) {
        RenderLeaf(node);
    } else {
        // Render front-to-back for early rejection
        if (ViewerInFront(node->plane)) {
            RenderBSP(node->front, frustum);
            RenderBSP(node->back, frustum);
        } else {
            RenderBSP(node->back, frustum);
            RenderBSP(node->front, frustum);
        }
    }
}

// Result: Doom renders complex levels at 35+ FPS on 486 processors
// This wasn't just optimization - it enabled the entire genre
```

**Innovations Enabled by Performance**:
- **Wolfenstein 3D**: Ray casting made FPS possible (1992)
- **Doom**: BSP trees enabled complex 3D environments (1993)
- **Quake**: True 3D with lighting in real-time (1996)
- **Doom 3**: Unified lighting with stencil shadows (2004)

**Philosophy**: "Fast code enables experiences that slower code makes impossible."

---

### 2. Deep Understanding of the System

**What**: Master every layer—from high-level algorithms to assembly to hardware.

**Why**: Optimization requires understanding the full stack. Carmack's deep knowledge of graphics hardware, CPU architecture, and algorithms enabled innovations others couldn't achieve.

```c
// Carmack's famous fast inverse square root (Quake III)
// Deep understanding of IEEE floating point representation
float Q_rsqrt(float number) {
    long i;
    float x2, y;
    const float threehalfs = 1.5F;

    x2 = number * 0.5F;
    y  = number;
    i  = *(long *)&y;                       // Evil floating point bit hack
    i  = 0x5f3759df - (i >> 1);            // What the fuck?
    y  = *(float *)&i;
    y  = y * (threehalfs - (x2 * y * y));  // Newton iteration

    return y;
}

// This works because Carmack understood:
// 1. IEEE 754 floating point representation
// 2. How to manipulate bits for logarithm approximation
// 3. Newton-Raphson for refinement
// 4. Hardware constraints requiring speed over precision

// Deep understanding => creative solutions
```

**Levels of Understanding**:
1. **Algorithm level**: BSP trees, ray casting
2. **Data structure level**: Cache-friendly layouts
3. **Instruction level**: Assembly optimization
4. **Hardware level**: GPU architecture, memory bandwidth

**Carmack's Advice**: "Learn how computers actually work, from the ground up."

---

### 3. Test Everything, Even When You're an Expert

**What**: Thorough testing is for professionals, not weak programmers.

**Why**: "Even the demigod of game programming John Carmack tests his code."

```c
// Carmack's testing approach

// Automated regression tests
void RunTests() {
    TestRenderer();
    TestPhysics();
    TestNetworking();
    TestAI();

    if (all_tests_pass) {
        printf("Build validated\n");
    } else {
        printf("TESTS FAILED - DO NOT COMMIT\n");
        exit(1);
    }
}

// Visual validation
void VisualTest() {
    // Render test scenes
    // Compare against known-good screenshots
    // Flag visual regressions
}

// Performance tests
void PerformanceTest() {
    int64_t start = GetMicroseconds();
    RenderFrame();
    int64_t end = GetMicroseconds();

    int fps = 1000000 / (end - start);
    assert(fps >= 60);  // Never ship slow code
}

// Even with decades of experience, Carmack tests rigorously
// Testing isn't weakness - it's professionalism
```

**Testing Philosophy**:
- Automated tests catch regressions
- Performance tests prevent slowdowns
- Visual tests catch rendering bugs
- Manual testing validates experience

---

### 4. Simple Code Has Fewer Bugs

**What**: KISS (Keep It Simple, Stupid) and YAGNI (You Aren't Gonna Need It).

**Why**: Complex code breeds bugs. Simple code is maintainable, debuggable, and less error-prone.

```c
// ❌ Complex: Over-engineered particle system
class AbstractParticleFactory {
    virtual Particle* CreateParticle(ParticleType type) = 0;
};

class ConcreteParticleFactoryA : public AbstractParticleFactory {
    // 500 lines of abstraction
};

// ✅ Simple: Direct approach
struct Particle {
    vec3 position;
    vec3 velocity;
    float life;
};

Particle particles[MAX_PARTICLES];
int num_particles = 0;

void AddParticle(vec3 pos, vec3 vel) {
    if (num_particles < MAX_PARTICLES) {
        particles[num_particles++] = (Particle){pos, vel, 1.0f};
    }
}

void UpdateParticles(float dt) {
    for (int i = 0; i < num_particles; i++) {
        particles[i].position += particles[i].velocity * dt;
        particles[i].life -= dt;

        if (particles[i].life <= 0) {
            particles[i] = particles[--num_particles];  // Swap with last
            i--;  // Reprocess this index
        }
    }
}

// Simple, cache-friendly, fast, no bugs
// Carmack's approach: Solve the problem directly
```

**Carmack's YAGNI**:
- Don't build features you might need
- Build features you need now
- Refactor when requirements actually change

---

### 5. Invest Heavily in Tools

**What**: "Great tools help make great games. Spend as much time on tools as possible."

**Why**: Good tools multiply productivity across entire team and project lifetime.

**id Software Tool Investment**:
```c
// Level Editor (e.g., DoomEd, Radiant)
// - Real-time preview
// - Immediate feedback
// - Artist-friendly
// Result: Faster iteration, better levels

// Asset Pipeline
// - Automated texture conversion
// - Model optimization
// - Sound processing
// Result: Artists work in native formats, tools optimize

// Build System
// - Fast incremental builds
// - Automated testing
// - One-click deployment
// Result: Iterate quickly, ship confidently

// Debugging Tools
// - In-game console
// - Real-time profiler
// - Memory visualizers
// Result: Fix bugs faster, optimize smartly
```

**Tool Philosophy**:
- Tools should be **faster** than manual processes
- Tools should provide **immediate feedback**
- Tools should be **easy to use** (even for non-programmers)
- Tools should **evolve with project**

**ROI**: Time spent on tools pays back 10x in productivity.

---

### 6. Always Maintain Shippable Code

**What**: Code should always be in shippable state. No "integration hell" phases.

**Why**: Reduces risk, enables quick releases, maintains quality, catches problems early.

**id Software Practices**:
```c
// Daily practices
1. All code compiles cleanly
2. All tests pass
3. Game runs without crashes
4. Performance targets met
5. No known critical bugs

// Integration discipline
void IntegrateChange() {
    // 1. Full build
    make clean && make

    // 2. Run tests
    ./run_tests

    // 3. Play game
    PlayTestLevel();

    // 4. If all pass, commit
    if (AllTestsPass() && GameRuns() && PerformanceGood()) {
        git commit -m "Feature X implemented and validated"
    }
}

// Ship any day
```

**Benefits**:
- Can release at any time
- No "stabilization" periods
- Problems caught immediately
- Low-stress releases

---

### 7. Profile Before Optimizing

**What**: Measure, don't guess. Optimize the actual bottlenecks.

**Why**: "Premature optimization is the root of all evil" (Knuth, endorsed by Carmack). But measured optimization is essential.

```c
// Carmack's optimization process

// Step 1: Profile
void ProfileFrame() {
    START_PROFILE("Total Frame");

    START_PROFILE("AI");
    UpdateAI();
    END_PROFILE("AI");  // 2ms

    START_PROFILE("Physics");
    UpdatePhysics();
    END_PROFILE("Physics");  // 3ms

    START_PROFILE("Rendering");
    RenderFrame();
    END_PROFILE("Rendering");  // 12ms ← BOTTLENECK

    END_PROFILE("Total Frame");  // 17ms total
}

// Step 2: Optimize bottleneck (rendering)
void OptimizeRendering() {
    // Before: 12ms
    // - Frustum culling: saved 3ms
    // - Occlusion culling: saved 4ms
    // - Batch drawing: saved 2ms
    // After: 3ms

    // Now physics is bottleneck
}

// Step 3: Repeat

// DON'T optimize AI (already fast)
// DO optimize rendering (actual bottleneck)
```

**Carmack's Rule**: 90% of time is spent in 10% of code. Find that 10%.

---

### 8. Functional Programming for Complex Systems

**What**: Use functional style (immutability, pure functions) for complex, concurrent code.

**Why**: Reduces bugs in complex systems. Easier to reason about.

```c
// Carmack on functional programming (later in career)

// ❌ Mutable, error-prone
void UpdateGameState() {
    player.health -= damage;  // Side effect
    if (enemy.ai_state == ATTACKING) {
        enemy.position += velocity;  // Side effect
        if (collision_detected) {
            player.health -= 10;  // Side effect
        }
    }
    // Hard to reason about, order-dependent, bugs hide here
}

// ✅ Functional approach
GameState CalculateNextState(GameState current, Input input) {
    GameState next = current;  // Copy

    next.player = UpdatePlayer(current.player, input);
    next.enemies = UpdateEnemies(current.enemies, next.player);
    next.physics = ResolvePhysics(next);

    return next;  // Pure function, no side effects
}

// Benefits:
// - Can rollback/replay
// - Easy to test
// - Parallel-friendly
// - Easier to debug
```

**Carmack's Evolution**: Started with C-style imperative, evolved to appreciate functional benefits for complex systems.

---

### 9. Open Source Philosophy

**What**: "All of science and technology and culture and learning and academics is built upon using the work that others have done before."

**Why**: Knowledge should be shared, built upon, not locked away behind patents or secrecy.

**Carmack's Open Source Releases**:
- Wolfenstein 3D engine
- Doom engine
- Quake engine
- Quake II engine
- Quake III engine
- Subsequent id Tech engines

```c
// Impact of open-source releases

// Direct benefits:
- Educational: Thousands learned from source
- Modding: Community created content
- Ports: Games run on every platform
- Innovation: New ideas built on engines

// Indirect benefits:
- Industry advancement
- Goodwill and reputation
- Longer game lifespan
- Inspiration for others

// Carmack's philosophy: Rising tide lifts all boats
```

**Stance on Patents**: Strongly opposed. Ideas should be free to extend and build upon.

---

### 10. Relentless Focus and Deep Work

**What**: Intense, focused work produces exceptional results.

**Why**: Complex problems require sustained, deep concentration.

**Carmack's Practice**:
- Regularly worked 80-hour weeks
- Deep focus sessions
- Minimized distractions
- Complete immersion in problem

```c
// Carmack's work sessions
void DeepWorkSession() {
    // 1. Eliminate distractions
    CloseEmail();
    DisableNotifications();
    SetPhoneToSilent();

    // 2. Define clear goal
    Goal goal = "Implement stencil shadows";

    // 3. Work intensely
    for (hours = 0; hours < 8; hours++) {
        Code(goal);
        Test(goal);
        Iterate(goal);
    }

    // 4. Review progress
    EvaluateResults();

    // Result: Breakthrough innovations
}

// "Devotion to the machine borders on fanatical"
// This intensity isn't for everyone, but it worked for Carmack
```

**Note**: This extreme intensity reflects Carmack's passion, not a universal requirement. The principle is focused, deep work—duration varies.

---

## Carmack's Innovation Process

### 1. Identify Constraint
```
Problem: Can't render complex 3D on 486
Constraint: CPU too slow for brute force
```

### 2. Deep Analysis
```
Study: How does rendering actually work?
Research: Graphics algorithms, hardware
Understand: Bottlenecks and opportunities
```

### 3. Creative Solution
```
Invention: BSP trees for spatial partitioning
Result: Only render what's visible
Impact: Doom runs smoothly
```

### 4. Iterate and Optimize
```
Profile: Find remaining bottlenecks
Optimize: Assembly, cache, algorithms
Test: Validate performance
```

### 5. Share Knowledge
```
Release: Doom source code
Impact: Industry learns and builds
```

---

## Applying Carmack's Philosophy

### For Game Developers

**Practices**:
- Performance budgets (target FPS)
- Profile every frame
- Invest in level editors
- Test on target hardware
- Support modding community

**Mindset**:
- Performance enables gameplay
- Tools multiply productivity
- Shipping matters more than perfection
- Learn from every layer of the stack

### For Performance-Critical Software

**Approaches**:
- Measure before optimizing
- Understand hardware deeply
- Simple, cache-friendly data structures
- Profile-guided optimization
- Test performance continuously

**Examples**:
- High-frequency trading
- Real-time systems
- Mobile apps (battery)
- Web performance

### For Any Developer

**Universal Lessons**:
1. **Test your code** - Even experts test
2. **Keep it simple** - Fewer bugs, easier maintenance
3. **Invest in tools** - Productivity multiplier
4. **Maintain shippability** - Always ready to release
5. **Deep understanding** - Know your stack
6. **Share knowledge** - Open source helps everyone

---

## Key Carmack Innovations

### Graphics Techniques
- **Adaptive tile refresh** - Smooth scrolling (Commander Keen)
- **Ray casting** - Fast 3D (Wolfenstein 3D)
- **BSP trees** - Visible surface determination (Doom)
- **Surface caching** - Texture optimization (Quake)
- **Carmack's Reverse** - Stencil shadows (Doom 3)
- **MegaTexture** - Unique texturing (id Tech 5)

### Architectural Patterns
- **Immediate mode** - Direct rendering, no retained state
- **Component systems** - Data-oriented design
- **Fixed timestep** - Deterministic physics
- **Networking** - Client-server architecture for multiplayer

---

## Anti-Patterns to Avoid

### ❌ Premature Abstraction
```c
// Don't build "flexible" systems before you need them
// Start simple, refactor when requirements clarify
```

### ❌ Optimization Without Measurement
```c
// Don't guess what's slow
// Profile, find real bottleneck, optimize that
```

### ❌ Complexity for Complexity's Sake
```c
// Don't use design patterns to show off
// Solve the problem directly
```

### ❌ Tool Neglect
```c
// Don't work around bad tools
// Invest time to improve tools
```

---

## Key Resources

### Carmack's Code
- **Doom source** - github.com/id-Software/DOOM
- **Quake source** - github.com/id-Software/Quake
- Study these to learn from a master

### Writings
- **Carmack's .plan files** - Historical development notes
- **QuakeCon keynotes** - Technical talks

### Books About
- **Masters of Doom** - David Kushner (id Software history)

---

## Summary

John Carmack's philosophy emphasizes:

1. **Performance Enables** - Fast code creates new possibilities
2. **Deep Understanding** - Master every layer of the stack
3. **Test Everything** - Even experts test rigorously
4. **Keep It Simple** - Simple code has fewer bugs
5. **Invest in Tools** - Tools multiply productivity
6. **Always Shippable** - Maintain releasable code
7. **Profile First** - Measure, then optimize bottlenecks
8. **Functional Benefits** - Pure functions for complex systems
9. **Open Source** - Share knowledge freely
10. **Relentless Focus** - Deep work produces results

**Core Belief**: Technical excellence and performance optimization enable experiences that would otherwise be impossible. Master the fundamentals, measure everything, and never stop learning.

---

*"The speed of light is actually one foot per nanosecond."* - John Carmack (on why low-latency matters)

*"Focused, hard work is the real key to success. Keep your eyes on the goal, and just keep taking the next step towards completing it."* - John Carmack