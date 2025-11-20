---
name: philosophy:install
description: Install a pre-made coding philosophy from legendary developers or methodologies
---

You are helping the user install a coding philosophy to their project.

## Available Philosophies

Browse philosophies in `${CLAUDE_PLUGIN_ROOT}/philosophies/`:

**👤 People Philosophies:**

- people/JOHN_CARMACK.PHILOSOPHY.md
- people/LINUS_TORVALDS.PHILOSOPHY.md
- people/MARTIN_FOWLER.PHILOSOPHY.md
- people/DONALD_KNUTH.PHILOSOPHY.md
- people/RICH_HICKEY.PHILOSOPHY.md
- people/GUIDO_VAN_ROSSUM.PHILOSOPHY.md
- people/YUKIHIRO_MATSUMOTO.PHILOSOPHY.md
- people/DENNIS_RITCHIE.PHILOSOPHY.md
- people/BRIAN_KERNIGHAN.PHILOSOPHY.md
- people/KEN_THOMPSON.PHILOSOPHY.md
- people/ROB_PIKE.PHILOSOPHY.md
- people/LARRY_WALL.PHILOSOPHY.md
- people/BRENDAN_EICH.PHILOSOPHY.md
- people/JAMES_GOSLING.PHILOSOPHY.md
- people/ANDERS_HEJLSBERG.PHILOSOPHY.md
- people/BJARNE_STROUSTRUP.PHILOSOPHY.md
- people/GRACE_HOPPER.PHILOSOPHY.md
- people/ADA_LOVELACE.PHILOSOPHY.md
- people/MARGARET_HAMILTON.PHILOSOPHY.md
- people/TIM_BERNERS_LEE.PHILOSOPHY.md

**📚 Methodology Philosophies:**

- methodologies/TDD.PHILOSOPHY.md
- methodologies/CLEAN_CODE.PHILOSOPHY.md
- methodologies/FUNCTIONAL_PROGRAMMING.PHILOSOPHY.md
- methodologies/CONVENTIONAL_COMMITS.PHILOSOPHY.md

**💻 Language Philosophies:**

- languages/PYTHON.PHILOSOPHY.md
- languages/RUST.PHILOSOPHY.md

## Installation Process

1. **Get Philosophy Name**
   - If $ARGUMENTS provided, use it as the philosophy name
   - Otherwise, ask user: "Which philosophy would you like to install?"
   - Show them the list above or suggest running `/philosophy:list` for details

2. **Validate Selection**
   - Convert name to file path format (e.g., "john_carmack" → "people/JOHN_CARMACK.PHILOSOPHY.md")
   - Check if file exists in `${CLAUDE_PLUGIN_ROOT}/philosophies/`
   - If not found, suggest closest matches or show available philosophies

3. **Read Philosophy File**
   - Read the complete content from `${CLAUDE_PLUGIN_ROOT}/philosophies/[category]/[NAME].PHILOSOPHY.md`

4. **Create PHILOSOPHY.md**
   - Write the philosophy content to user's project root as `PHILOSOPHY.md`
   - Path should be relative to current working directory

5. **Confirm Installation**
   - Show success message: "✅ [Philosophy Name] philosophy installed to PHILOSOPHY.md"
   - Suggest: "Start coding according to these principles, or run `/philosophy:create` to blend multiple philosophies"

## Notes

- Philosophy files remain in the plugin directory
- Only PHILOSOPHY.md is created in user's project
- User can run this command multiple times to switch philosophies
- Previous PHILOSOPHY.md will be overwritten (warn user if it exists)

## Arguments

`$ARGUMENTS` - Optional philosophy name (e.g., "john_carmack", "tdd", "python")

## Examples

```text
/philosophy:install john_carmack
/philosophy:install tdd
/philosophy:install python
```