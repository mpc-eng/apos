#!/bin/bash
# APOS Review Lint — mechanical pre-check before [REVIEW] agent
# Catches pattern-matchable violations that don't need LLM judgment.
# Exit code 0 = clean, 1 = violations found (non-blocking, advisory)
# Usage: tools/review-lint.sh <path-to-swift-files-dir>

set -euo pipefail

DIR="${1:-.}"
VIOLATIONS=0
VIOLATION_LOG=""

log_violation() {
  local file="$1" line="$2" rule="$3" detail="$4"
  VIOLATION_LOG="${VIOLATION_LOG}  ${rule} | ${file}:${line} | ${detail}\n"
  VIOLATIONS=$((VIOLATIONS + 1))
}

# Find all Swift files in the target directory
SWIFT_FILES=$(find "$DIR" -name "*.swift" -not -path "*/Tests/*" -not -path "*/.build/*" 2>/dev/null || true)

if [ -z "$SWIFT_FILES" ]; then
  echo "[REVIEW-LINT] No Swift files found in $DIR"
  exit 0
fi

for file in $SWIFT_FILES; do
  line_num=0
  while IFS= read -r line || [ -n "$line" ]; do
    line_num=$((line_num + 1))

    # Rule 1: Design system import — view files must import APOSDesignSystem
    # (Check once per file, not per line)
    if [ "$line_num" -eq 1 ]; then
      if echo "$file" | grep -qE "(View|Screen|Page|Sheet|Card|Cell)\.swift$"; then
        if ! grep -q "import APOSDesignSystem" "$file" 2>/dev/null; then
          log_violation "$file" "1" "design_system_import" "View file missing 'import APOSDesignSystem'"
        fi
      fi
    fi

    # Rule 2: No hardcoded hex colours
    if echo "$line" | grep -qE 'Color\(.*#[0-9a-fA-F]' 2>/dev/null; then
      log_violation "$file" "$line_num" "hardcoded_colour" "Hardcoded hex colour — use theme tokens"
    fi
    if echo "$line" | grep -qE 'Color\(red:|Color\(hex:' 2>/dev/null; then
      log_violation "$file" "$line_num" "hardcoded_colour" "Literal colour constructor — use theme tokens"
    fi

    # Rule 3: No raw font sizes
    if echo "$line" | grep -qE '\.font\(\.system\(size:' 2>/dev/null; then
      log_violation "$file" "$line_num" "raw_font_size" ".font(.system(size:)) — use theme font tokens or AppText"
    fi

    # Rule 4: No raw spacing values in padding
    if echo "$line" | grep -qE '\.padding\([0-9]' 2>/dev/null; then
      log_violation "$file" "$line_num" "raw_spacing" "Raw numeric padding — use Spacing.* tokens"
    fi

    # Rule 5: No raw corner radius
    if echo "$line" | grep -qE 'cornerRadius:\s*[0-9]' 2>/dev/null; then
      log_violation "$file" "$line_num" "raw_radius" "Raw numeric cornerRadius — use Radius.* tokens"
    fi

    # Rule 6: ignoresSafeArea on non-background layers
    if echo "$line" | grep -qE '\.ignoresSafeArea\(\)' 2>/dev/null; then
      # Flag for manual review — can't determine context statically
      log_violation "$file" "$line_num" "safe_area_review" ".ignoresSafeArea() detected — verify it's on background/media layer only"
    fi

    # Rule 7: Button without accessibilityLabel (heuristic — catches Button { } without .accessibilityLabel nearby)
    if echo "$line" | grep -qE '^\s*Button\(' 2>/dev/null && ! echo "$line" | grep -qE '^\s*//' 2>/dev/null; then
      # Check next 5 lines for accessibilityLabel
      has_label=$(sed -n "$((line_num)),$(( line_num + 5 ))p" "$file" 2>/dev/null | grep -c "accessibilityLabel" || true)
      if [ "$has_label" -eq 0 ]; then
        log_violation "$file" "$line_num" "missing_a11y_label" "Button without nearby .accessibilityLabel()"
      fi
    fi

  done < "$file"
done

# Output
echo "[REVIEW-LINT] Scanned $(echo "$SWIFT_FILES" | wc -l | tr -d ' ') Swift files in $DIR"

if [ "$VIOLATIONS" -eq 0 ]; then
  echo "[REVIEW-LINT] Clean — no mechanical violations detected"
  exit 0
else
  echo "[REVIEW-LINT] Found $VIOLATIONS violations:"
  echo ""
  echo "  Rule | Location | Detail"
  echo "  -----|----------|-------"
  echo -e "$VIOLATION_LOG"
  echo ""
  echo "[REVIEW-LINT] These are advisory — pass results to [REVIEW] agent to reduce its checklist burden."
  exit 1
fi
