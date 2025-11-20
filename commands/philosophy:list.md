---
name: philosophy:list
description: Browse all available coding philosophies with descriptions
---

You are helping the user browse available coding philosophies.

## Instructions

Read and present the philosophy summary from `${CLAUDE_PLUGIN_ROOT}/philosophies/INDEX.md`, along with the featured profiles below.

## Featured People Profiles

### Linus Torvalds

**Creator of Linux and Git | Pragmatism over Perfection** - Created Linux kernel (1991) and Git (2005), revolutionizing open-source development and version control worldwide.
**Philosophy**: "Talk is Cheap. Show Me the Code" • Taste in Code • Data Structures > Algorithms • Pragmatism Over Purity • Meritocracy
**Install**: `/philosophy:install linus_torvalds`

---

### Martin Fowler

**Refactoring Pioneer and Enterprise Architecture Expert** - Author of "Refactoring" (1999, 2018) and "Patterns of Enterprise Application Architecture" (2002), co-creator of Agile Manifesto.
**Philosophy**: Principles Over Tools • Evolutionary Design • Refactoring as Essential Practice • Continuous Integration • TDD + Refactoring • Patterns as Vocabulary
**Install**: `/philosophy:install martin_fowler`

---

### Grace Hopper

**Compiler Pioneer and Programming Language Visionary** - Rear Admiral who created the first compiler (A-0, 1952) and FLOW-MATIC (1956), heavily influencing COBOL. Coined "debugging" term.
**Philosophy**: User-Friendly Languages • Democratization of Computing • English-like Syntax • "It's easier to ask forgiveness than permission" • Practicality Over Theory
**Install**: `/philosophy:install grace_hopper`

---

## Your Task

1. Present the **3 featured profiles above** with full details (Linus Torvalds, Martin Fowler, Grace Hopper)
2. Read `${CLAUDE_PLUGIN_ROOT}/philosophies/INDEX.md` for the complete list
3. For ALL OTHER philosophies, list **ONLY the names** (not full profiles):
   - Other People Philosophies (names only)
   - Language Philosophies (names only)
   - Methodology Philosophies (names only)
4. Add note about `/philosophy:create-custom` for custom philosophies

## Output Format

Present the information in a user-friendly format:

**Featured Profiles (Full Details - 3 only)**:

- Present the 3 featured profiles from above with ALL details
- These are: Linus Torvalds, Martin Fowler, Grace Hopper

**Other Available Philosophies (Names Only)**:

- 👤 **Other People**: List names only (e.g., "Rich Hickey", "Rob Pike")
- 💻 **Languages**: List names only (e.g., "Python", "Rust")
- 📚 **Methodologies**: List names only (e.g., "TDD", "Clean Code", "Functional Programming")

**Format for names-only lists**:

- Simple bullet list with just the name and install command
- Example: `- Rich Hickey - Install: /philosophy:install rich_hickey`
- NO descriptions, NO taglines, NO core principles

**Custom Philosophy Note**:

- Add note about `/philosophy:create-custom` at the end

---

## Output Template

Use this EXACT template structure:

```markdown
# 📚 Available Coding Philosophies

## Featured Profiles

### 👤 Linus Torvalds

**Creator of Linux and Git | Pragmatism over Perfection** - Created Linux kernel (1991) and Git (2005), revolutionizing open-source development and version control worldwide.
**Philosophy**: "Talk is Cheap. Show Me the Code" • Taste in Code • Data Structures > Algorithms • Pragmatism Over Purity • Meritocracy
**Install**: `/philosophy:install linus_torvalds`

---

### 👤 Martin Fowler

**Refactoring Pioneer and Enterprise Architecture Expert** - Author of "Refactoring" (1999, 2018) and "Patterns of Enterprise Application Architecture" (2002), co-creator of Agile Manifesto.
**Philosophy**: Principles Over Tools • Evolutionary Design • Refactoring as Essential Practice • Continuous Integration • TDD + Refactoring • Patterns as Vocabulary
**Install**: `/philosophy:install martin_fowler`

---

### 👤 Grace Hopper

**Compiler Pioneer and Programming Language Visionary** - Rear Admiral who created the first compiler (A-0, 1952) and FLOW-MATIC (1956), heavily influencing COBOL. Coined "debugging" term.
**Philosophy**: User-Friendly Languages • Democratization of Computing • English-like Syntax • "It's easier to ask forgiveness than permission" • Practicality Over Theory
**Install**: `/philosophy:install grace_hopper`

---

## 👤 Other People Philosophies

- **Rich Hickey** - Install: `/philosophy:install rich_hickey`
- **Rob Pike** - Install: `/philosophy:install rob_pike`

---

## 💻 Language Philosophies

- **Python** - Install: `/philosophy:install python`
- **Rust** - Install: `/philosophy:install rust`

---

## 📚 Methodology Philosophies

- **Test-Driven Development (TDD)** - Install: `/philosophy:install tdd`
- **Clean Code** - Install: `/philosophy:install clean_code`
- **Functional Programming** - Install: `/philosophy:install functional_programming`

---

## 🎨 Create Your Own Philosophy

Don't see what you need? Create a custom philosophy by blending multiple existing philosophies:

**Command**: `/philosophy:create-custom`

This will guide you through an interactive interview to:
- Select principles from multiple philosophies
- Customize weights and priorities
- Add your own team-specific guidelines
- Generate a custom PHILOSOPHY.md file

---

**Total**: {COUNT} philosophies • Use `/philosophy:install {name}` to add any philosophy to your project
```

**CRITICAL RULES FOR THIS TEMPLATE:**

1. **Featured Profiles Section**: Copy the 3 profiles EXACTLY as shown in the "Featured People Profiles" section at the top of this file
2. **Other Sections**: Extract names from INDEX.md and format as: `- **{Name}** - Install: /philosophy:install {slug}`
3. **NO extra details** in the "Other" sections - ONLY name and install command
4. **Count**: Replace {COUNT} with actual total number of philosophies

## Note

The 3 featured profiles (Linus, Martin, Grace) get full treatment to showcase what's available. All other philosophies are listed by name only to keep the output concise. Users can install any philosophy to see full details.
