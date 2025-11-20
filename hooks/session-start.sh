#!/usr/bin/env bash
# Philosophy Plugin - Session Start Hook
# This script loads the team's philosophy and injects instructions into Claude's context

# Check if PHILOSOPHY.md exists
if [ -f "${CLAUDE_PROJECT_DIR}/PHILOSOPHY.md" ]; then
  # Philosophy file exists - provide full instructions
  cat <<'EOF'
CRITICAL INSTRUCTIONS - Philosophy Plugin Active:

1. LOAD TEAM PHILOSOPHY:
   - Read PHILOSOPHY.md in the project root to understand the team's coding philosophy
   - This contains the principles, values, and coding standards for this project

2. ACTIVATE PHILOSOPHY SKILLS:
   Throughout this session, actively use these Skills:
   - Use Skill(philosophy:philosophy-guardian) when writing or editing code for real-time guidance
   - Use Skill(philosophy:philosophy-reviewer) when reviewing code or doing PR reviews

   IMPORTANT: These skills activate automatically based on context. Use them proactively.

3. PERSONALITY-DRIVEN GUIDANCE:
   - When providing philosophy guidance, use the authentic voice of the philosophers referenced in PHILOSOPHY.md
   - Match their tone and style (some are direct, others academic, others motivational)
   - Provide encouraging, energizing guidance aligned with their principles

4. WELCOME:
   💡 Philosophy.md plugin active! Your team has chosen a specific coding philosophy.
   Let's write code that embodies these principles.
EOF
else
  # No philosophy file yet - brief welcome
  cat <<'EOF'
💡 Philosophy.md plugin active!

Run /philosophy:list to see available philosophies, or /philosophy:create to build your own.
Once installed, your chosen philosophy will guide coding decisions throughout your sessions.
EOF
fi

# Exit with 0 to inject this output as context
exit 0
