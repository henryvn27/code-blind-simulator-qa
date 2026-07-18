#!/usr/bin/env bash
set -euo pipefail

repo_dir="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
skill_file="$repo_dir/SKILL.md"
prompt_file="$repo_dir/references/tester-prompt.md"
metadata_file="$repo_dir/agents/openai.yaml"

fail() {
  printf 'error: %s\n' "$1" >&2
  exit 1
}

[[ -f "$skill_file" ]] || fail "SKILL.md is missing"
[[ -f "$prompt_file" ]] || fail "references/tester-prompt.md is missing"
[[ -f "$metadata_file" ]] || fail "agents/openai.yaml is missing"

[[ "$(sed -n '1p' "$skill_file")" == "---" ]] || fail "SKILL.md must start with YAML frontmatter"
grep -Fxq 'name: code-blind-simulator-qa' "$skill_file" || fail "skill name is missing or incorrect"
grep -Eq '^description: .+' "$skill_file" || fail "skill description is missing"
grep -Fq 'The orchestrator knows the code; the tester does not.' "$skill_file" || fail "core isolation contract is missing"
grep -Fxq 'license: MIT' "$skill_file" || fail "skill license metadata is missing or incorrect"
grep -Fxq 'interface:' "$metadata_file" || fail "agent interface metadata is missing"
grep -Fq '$code-blind-simulator-qa' "$metadata_file" || fail "agent default prompt does not invoke the skill"

for placeholder in PRODUCT UDID BUNDLE_ID_SENTENCE USER_FACING_MISSION; do
  count="$(grep -o "<$placeholder>" "$prompt_file" | wc -l | tr -d ' ')"
  [[ "$count" == "1" ]] || fail "<$placeholder> must appear exactly once"
done

grep -Fq 'Forbidden:' "$prompt_file" || fail "tester prohibitions are missing"
grep -Fq 'Do not create or edit project files.' "$prompt_file" || fail "tester project-write boundary is missing"
grep -Fq 'Simulator artifacts produced by permitted simulator tools are allowed' "$prompt_file" || fail "simulator artifact allowance is missing"

for relative_path in references/tester-prompt.md agents/openai.yaml assets/social-preview.svg LICENSE; do
  [[ -f "$repo_dir/$relative_path" ]] || fail "$relative_path is missing"
done

if grep -RniE 'Cardinal|Scoutly|/Users/[^ <]+|\.xcodeproj|\.xcworkspace' \
  "$skill_file" "$prompt_file" "$metadata_file"; then
  fail "private project or filesystem context leaked into the public skill"
fi

printf 'code-blind-simulator-qa: validation passed\n'
