#!/usr/bin/env bats
# Tests for skills/copy-editing/scripts/word-count.sh

SCRIPT="$BATS_TEST_DIRNAME/../../skills/copy-editing/scripts/word-count.sh"

setup() {
  TMP_DIR=$(mktemp -d)
  export TMP_DIR
}

teardown() {
  rm -rf "$TMP_DIR"
}

@test "word-count: empty file returns 0 paragraphs" {
  printf '' > "$TMP_DIR/empty.txt"
  run bash "$SCRIPT" "$TMP_DIR/empty.txt"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Paragraphs:   0"* ]]
}

@test "word-count: single paragraph" {
  printf 'One paragraph here.\n' > "$TMP_DIR/one.txt"
  run bash "$SCRIPT" "$TMP_DIR/one.txt"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Paragraphs:   1"* ]]
  [[ "$output" == *"Words:        3"* ]]
}

@test "word-count: three paragraphs separated by blank lines" {
  printf 'First paragraph.\n\nSecond paragraph.\n\n   \n\nThird paragraph.\n' > "$TMP_DIR/three.txt"
  run bash "$SCRIPT" "$TMP_DIR/three.txt"
  [ "$status" -eq 0 ]
  [[ "$output" == *"Paragraphs:   3"* ]]
}

@test "word-count: missing file shows usage" {
  run bash "$SCRIPT" "$TMP_DIR/nonexistent.txt"
  [ "$status" -eq 1 ]
  [[ "$output" == *"Usage"* ]]
}
