#!/usr/bin/env bats
# Ensure no script uses eval "$cmd" anti-pattern

@test "no eval \"\$cmd\" in any bash skill script" {
  SKILLS_DIR="$BATS_TEST_DIRNAME/../../skills"
  run bash -c 'grep -rn '"'"'eval "\$cmd"'"'"' "$1"/*/scripts/*.sh 2>/dev/null || true' bash "$SKILLS_DIR"
  [ -z "$output" ]
}
