#!/usr/bin/env bash
# Convert SKILL.md to other AI coding tool formats
# Usage: ./convert.sh [SKILL.md path] [format] [output-dir]
# Formats: cursor, windsurf, copilot, aider, all

set -euo pipefail

SKILL_FILE="${1:-SKILL.md}"
FORMAT="${2:-all}"
OUTPUT_DIR="${3:-.}"

if [[ ! -f "$SKILL_FILE" ]]; then
  echo "Error: $SKILL_FILE not found"
  exit 1
fi

# Extract frontmatter (between first two --- lines only)
FRONTMATTER=$(awk 'NR==1 && /^---$/{fm=1; next} fm && /^---$/{exit} fm{print}' "$SKILL_FILE")

NAME=$(echo "$FRONTMATTER" | grep '^name:' | sed 's/name: *//')
DESC=$(echo "$FRONTMATTER" | grep '^description:' | sed 's/description: *//')

# Build converted content: header + body (frontmatter stripped)
build_content() {
  printf '%s\n\n%s\n\n' "# $NAME" "$DESC"
  awk 'BEGIN{skip=0} /^---$/{skip++; next} skip>=2{print}' "$SKILL_FILE"
}

write_format() {
  local out="$1"
  mkdir -p "$(dirname "$out")"
  build_content > "$out"
  echo "Generated: $out"
}

case "$FORMAT" in
  cursor)   write_format "$OUTPUT_DIR/.cursorrules" ;;
  windsurf) write_format "$OUTPUT_DIR/.windsurfrules" ;;
  copilot)  write_format "$OUTPUT_DIR/.github/copilot-instructions.md" ;;
  aider)    write_format "$OUTPUT_DIR/.aider.prompt.md" ;;
  all)
    write_format "$OUTPUT_DIR/.cursorrules"
    write_format "$OUTPUT_DIR/.windsurfrules"
    write_format "$OUTPUT_DIR/.github/copilot-instructions.md"
    write_format "$OUTPUT_DIR/.aider.prompt.md"
    ;;
  *)
    echo "Unknown format: $FORMAT"
    echo "Supported: cursor, windsurf, copilot, aider, all"
    exit 1
    ;;
esac
