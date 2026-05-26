#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/plugins/ai-engineering-skills/skills"
TARGET_DIR="${CODEX_SKILLS_DIR:-${HOME}/.codex/skills}"

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Source skills directory not found: ${SOURCE_DIR}" >&2
  exit 1
fi

mkdir -p "${TARGET_DIR}"

installed=0
for skill_dir in "${SOURCE_DIR}"/*; do
  [[ -d "${skill_dir}" ]] || continue

  skill_name="$(basename "${skill_dir}")"
  target="${TARGET_DIR}/${skill_name}"

  if [[ ! -f "${skill_dir}/SKILL.md" ]]; then
    echo "Skip ${skill_name}: missing SKILL.md" >&2
    continue
  fi

  rm -rf "${target}"
  cp -R "${skill_dir}" "${target}"
  echo "Installed ${skill_name} -> ${target}"
  installed=$((installed + 1))
done

if [[ "${installed}" -eq 0 ]]; then
  echo "No skills installed from ${SOURCE_DIR}" >&2
  exit 1
fi

echo "Installed ${installed} skills into ${TARGET_DIR}"
