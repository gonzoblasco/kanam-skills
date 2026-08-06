#!/usr/bin/env bats
# Tests for skills/engineering-governance/scripts/detect-duplicates.sh

SCRIPT="$BATS_TEST_DIRNAME/../../skills/engineering-governance/scripts/detect-duplicates.sh"
SKILLS_DIR="$BATS_TEST_DIRNAME/../../skills"

setup() {
  TMP_DIR=$(mktemp -d)
  export TMP_DIR
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "detect-duplicates: exits 0 and creates report" {
  cd "$TMP_DIR"
  SKILLS_DIR="$SKILLS_DIR" bash "$SCRIPT" 2>/dev/null
  [ -f "$TMP_DIR/duplicates-report.md" ]
}

@test "detect-duplicates: report contains original headings" {
  cd "$TMP_DIR"
  SKILLS_DIR="$SKILLS_DIR" bash "$SCRIPT" >/dev/null 2>&1
  run cat "$TMP_DIR/duplicates-report.md"
  [[ "$output" == *"## Shared Section Headings"* ]]
  [[ "$output" == *"## Shared Checklist Items"* ]]
}
