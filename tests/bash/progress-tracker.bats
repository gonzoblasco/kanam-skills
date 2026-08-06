#!/usr/bin/env bats
# Tests for skills/narrative-content/scripts/progress-tracker.sh

SCRIPT="$BATS_TEST_DIRNAME/../../skills/narrative-content/scripts/progress-tracker.sh"

setup() {
  TMP_DIR=$(mktemp -d)
  export TMP_DIR
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "progress-tracker: add words and status reflects them" {
  run bash "$SCRIPT" --log "$TMP_DIR/log.md" --add 100
  [ "$status" -eq 0 ]
  [[ "$output" == *"Logged: 100 words"* ]]

  run bash "$SCRIPT" --status --log "$TMP_DIR/log.md"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Total words:  100"* ]]
  [[ "$output" == *"Sessions:     1"* ]]
}

@test "progress-tracker: same day entry updates total" {
  bash "$SCRIPT" --log "$TMP_DIR/log.md" --add 100
  bash "$SCRIPT" --log "$TMP_DIR/log.md" --add 50

  run bash "$SCRIPT" --status --log "$TMP_DIR/log.md"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Total words:  150"* ]]
  [[ "$output" == *"Sessions:     1"* ]]
}
