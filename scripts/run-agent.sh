#!/usr/bin/env bash
# APOS Pipeline — Local Agent Runner
# Invokes specialist review agents via Claude Code CLI
#
# Usage:
#   ./scripts/run-agent.sh arch-review
#   ./scripts/run-agent.sh ios-review
#   ./scripts/run-agent.sh ux-review --usability-notes docs/usability-notes-v1.md
#   ./scripts/run-agent.sh mono-review --context monday_analytics
#   ./scripts/run-agent.sh dist-review --subreddit "r/SomebodyMakeThis"
#   ./scripts/run-agent.sh reality-check --context monday_session

set -euo pipefail

REPO_ROOT="$(cd "$(dirname "$0")/.." && pwd)"
cd "$REPO_ROOT"

AGENT=""
CONTEXT=""
SUBREDDIT=""
USABILITY_NOTES=""

usage() {
  cat <<'USAGE'
APOS Agent Runner — invoke agents locally via Claude Code

Usage: ./scripts/run-agent.sh <agent> [options]

Agents:
  arch-review       Infrastructure gate (8 checklist categories)
  ios-review        Spec gate (AC testability, privacy, entitlements, HIG)
  ux-review         Usability gate (Hook Model, accessibility, D2 retention)
  mono-review       Monetisation advisory (11 flag types)
  dist-review       Distribution advisory (channel selection)
  reality-check     Session framing advisory (momentum, disappointment loops)

Options:
  --context <daily|monday_session|monday_analytics|paywall_spec>
  --subreddit <name>           Target subreddit for dist-review
  --usability-notes <path>     Path to usability notes for ux-review

Examples:
  ./scripts/run-agent.sh arch-review
  ./scripts/run-agent.sh ios-review
  ./scripts/run-agent.sh ux-review --usability-notes docs/usability-notes-v1.md
  ./scripts/run-agent.sh mono-review --context monday_analytics
  ./scripts/run-agent.sh dist-review --subreddit "r/SomebodyMakeThis"
  ./scripts/run-agent.sh reality-check
  ./scripts/run-agent.sh reality-check --context monday_session
USAGE
  exit 1
}

[ $# -lt 1 ] && usage
AGENT="$1"
shift

while [ $# -gt 0 ]; do
  case "$1" in
    --context) CONTEXT="$2"; shift 2 ;;
    --subreddit) SUBREDDIT="$2"; shift 2 ;;
    --usability-notes) USABILITY_NOTES="$2"; shift 2 ;;
    *) echo "Unknown option: $1"; usage ;;
  esac
done

case "$AGENT" in
  arch-review)
    AGENT_FILE=".claude/agents/arch-review-agent.md"
    PROMPT="Run the ARCH-REVIEW infrastructure gate. Check all 8 categories against the current repo state. Write output to approvals/pending/arch-review-output.json."
    ;;
  ios-review)
    SPECS=$(ls specs/*.md 2>/dev/null | head -5 || true)
    if [ -z "$SPECS" ]; then
      echo "No spec files found in specs/. Add a spec file first."
      exit 1
    fi
    AGENT_FILE=".claude/agents/ios-review-agent.md"
    PROMPT="Run the IOS-REVIEW gate on these specs: ${SPECS}. Check AC testability, privacy manifest, entitlement flags, and HIG flags. Write output to approvals/pending/ios-review-output.json."
    ;;
  ux-review)
    if [ -z "$USABILITY_NOTES" ]; then
      echo "Error: --usability-notes <path> is required for ux-review"
      exit 1
    fi
    if [ ! -f "$USABILITY_NOTES" ]; then
      echo "Error: Usability notes file not found: $USABILITY_NOTES"
      exit 1
    fi
    AGENT_FILE=".claude/agents/ux-review-agent.md"
    PROMPT="Run the UX-REVIEW gate using usability notes at: ${USABILITY_NOTES}. Review all 5 areas. Write output to approvals/pending/ux-review-output.json."
    ;;
  mono-review)
    CTX="${CONTEXT:-paywall_spec}"
    AGENT_FILE=".claude/agents/mono-review-agent.md"
    PROMPT="Run MONO-REVIEW in context: ${CTX}. Check for all 11 monetisation flag types. Write output to approvals/pending/mono-review-output.json."
    ;;
  dist-review)
    if [ -z "$SUBREDDIT" ]; then
      echo "Error: --subreddit <name> is required for dist-review"
      exit 1
    fi
    AGENT_FILE=".claude/agents/dist-review-agent.md"
    PROMPT="Run DIST-REVIEW for target subreddit: ${SUBREDDIT}. Read channel rules from agents/config/channel-rules.json and account data from state.json. Write output to approvals/pending/dist-review-output.json."
    ;;
  reality-check)
    CTX="${CONTEXT:-daily}"
    AGENT_FILE=".claude/agents/reality-check-agent.md"
    PROMPT="Run REALITY-CHECK in context: ${CTX}. Read ideas.json and state.json. Write output to approvals/pending/reality-check-output.json."
    ;;
  *)
    echo "Unknown agent: $AGENT"
    usage
    ;;
esac

if [ ! -f "$AGENT_FILE" ]; then
  echo "Error: Agent file not found: $AGENT_FILE"
  exit 1
fi

# Read agent definition and project context into the prompt
AGENT_CONTENT=$(cat "$AGENT_FILE")
CLAUDE_MD_CONTENT=""
if [ -f "CLAUDE.md" ]; then
  CLAUDE_MD_CONTENT=$(cat "CLAUDE.md")
fi

FULL_PROMPT="You are running as an APOS pipeline agent. Follow the agent definition below EXACTLY.

=== PROJECT CONTEXT (CLAUDE.md) ===
${CLAUDE_MD_CONTENT}

=== AGENT DEFINITION ===
${AGENT_CONTENT}

=== TASK ===
${PROMPT}"

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  APOS — Running ${AGENT^^}"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo ""

claude -p "$FULL_PROMPT" --allowedTools "Read,Write,Edit,Glob,Grep,Bash"
