#!/usr/bin/env bats
# Tests for skills/tech-docs/scripts/generate-adr.sh

SCRIPT="$BATS_TEST_DIRNAME/../../skills/tech-docs/scripts/generate-adr.sh"

setup() {
  TMP_DIR=$(mktemp -d)
  export TMP_DIR
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "generate-adr: first ADR is 001" {
  cd "$TMP_DIR"
  run bash "$SCRIPT" --title "Use Bats for testing" --status proposed
  [ "$status" -eq 0 ]
  [ -f "$TMP_DIR/docs/adr/001-use-bats-for-testing.md" ]
}

@test "generate-adr: sequential numbering" {
  cd "$TMP_DIR"
  bash "$SCRIPT" --title "First" --status proposed
  bash "$SCRIPT" --title "Second" --status accepted
  bash "$SCRIPT" --title "Third" --status proposed

  [ -f "$TMP_DIR/docs/adr/001-first.md" ]
  [ -f "$TMP_DIR/docs/adr/002-second.md" ]
  [ -f "$TMP_DIR/docs/adr/003-third.md" ]
}

@test "generate-adr: no executable grep -oP remains" {
  # Allow comments mentioning grep -oP, but no actual command
  run bash -c 'grep -nE "^[^#]*grep -oP" "$1"' bash "$SCRIPT"
  [ -z "$output" ]
}
