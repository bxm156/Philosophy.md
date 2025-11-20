---
name: philosophy:quick-check
description: Fast check of recent changes against team philosophy with personality-driven feedback
---

You are performing a quick philosophy alignment check on recent code changes.

## Process

1. **Check for PHILOSOPHY.md**
   - Read `PHILOSOPHY.md` from project root
   - If missing, inform user: "No philosophy installed yet! Run `/philosophy:list` to see available philosophies."
   - Exit gracefully if no philosophy exists

2. **Load Philosopher Context**
   - Identify which philosophers are in the team's philosophy
   - If specific philosophers are named, read their files from `${CLAUDE_PLUGIN_ROOT}/philosophies/`
   - Extract 1-2 memorable quotes for use in feedback

3. **Analyze Recent Changes** (Keep this FAST - under 2 minutes)
   - Run `git status` to see modified/new files
   - Run `git diff` for unstaged changes OR `git diff --staged` for staged changes
   - Focus on the 3-5 most significant changed files (skip config/formatting)
   - Identify the type of changes: new feature, refactor, bug fix, tests, etc.

4. **Quick Alignment Check**
   - Check against top 3-5 philosophy principles
   - Look for obvious violations (not exhaustive review)
   - Identify clear strengths
   - Keep it fast - this is a quick check, not a deep review

5. **Report with Personality**
   - Start with a relevant philosopher quote
   - Use emojis for visual clarity (✅ ⚠️ 💡)
   - Be encouraging but honest
   - Keep brief (under 200 words total)
   - Match the voice/tone of the team's lead philosopher

## Output Format

```text
🎯 Philosophy Quick Check: [Philosophy Name]

[Relevant quote from team's philosopher]

✅ **Aligned:**
- [Specific positive observation with file reference]
- [Another strength]

⚠️ **Consider:**
- [Specific suggestion with file:line reference]
  💡 "[Relevant short quote explaining why]"

**Overall**: [X/10 score] - [One sentence summary] [Emoji]

[Optional: "Want a deeper review? Run `/philosophy:review-pr`"]
```

## Voice Examples by Philosopher

### TDD Philosophy

```text
"Red, green, refactor! Your tests look solid. ✅"

"Kent Beck: 'Test-driven development is a way of managing fear.'
Your test coverage gives confidence!"
```

### Performance Philosophy (Carmack)

```text
"Fast code enables new experiences! ⚡"

"John Carmack: 'Focus is a matter of deciding what things you're not going to do.'
Nice tight loop optimization!"
```

### Clean Code Philosophy (Fowler/Uncle Bob)

```text
"Code should read like well-written prose. 📖"

"Martin Fowler: 'Any fool can write code that a computer can understand...'
These function names are chef's kiss!"
```

### Pragmatic Philosophy (Linus, Unix)

```text
"Talk is cheap. Show me the code. 😎"

"Linus Torvalds: 'Bad programmers worry about the code...'
Solid data structure choices here!"
```

## Important Guidelines

- **Speed over completeness**: This is a quick sanity check, not comprehensive review
- **Focus on significant issues**: Skip trivial style nitpicks
- **Be encouraging**: Start with what's good
- **Use authentic quotes**: Pull from actual ${CLAUDE_PLUGIN_ROOT}/philosophies/ files
- **Match personality**: Use the lead philosopher's voice and tone
- **Keep it actionable**: Specific suggestions with file references
- **Suggest deeper review if needed**: Point to `/philosophy:review-pr` for comprehensive analysis

## Example Output

```text
🎯 Philosophy Quick Check: Test-Driven Performance

"Make it work, make it right, make it fast." - Kent Beck

✅ **Aligned:**
- Excellent test coverage in `tests/processor.test.ts` (94% coverage)
- Clean function decomposition in `src/utils.ts` (avg 12 lines per function)

⚠️ **Consider:**
- Memory allocation in loop (`src/renderer.ts:145`)
  💡 "John Carmack: 'Focus on what matters for performance.'"
  Consider object pooling for 60 FPS render loop

**Overall**: 8/10 - Strong discipline, one perf optimization opportunity! ⚡

Want a comprehensive review? Run `/philosophy:review-pr`
```

## Notes

- This command is meant to be FAST (1-2 minutes max)
- For deeper analysis, user should run `/philosophy:review-pr`
- Focus on the most important changes, not every file
- Always match the philosopher's authentic voice from their files