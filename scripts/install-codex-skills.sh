#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
REPO_ROOT="$(cd "${SCRIPT_DIR}/.." && pwd)"
SOURCE_DIR="${REPO_ROOT}/plugins/ai-engineering-skills/skills"
TARGET_DIR="${CODEX_SKILLS_DIR:-${HOME}/.codex/skills}"
BACKUP_ROOT="${CODEX_SKILLS_BACKUP_DIR:-${HOME}/.codex/skills-backups}"
DRY_RUN=0
FORCE=0
BACKUP=0

usage() {
  cat <<'USAGE'
Usage: scripts/install-codex-skills.sh [--dry-run] [--force | --backup]

Installs skills from plugins/ai-engineering-skills/skills into ~/.codex/skills
or CODEX_SKILLS_DIR.

Options:
  --dry-run   Print planned actions without writing files.
  --force     Replace existing target skill directories.
  --backup    Move existing target skill directories into a timestamped backup.
  -h, --help  Show this help.

By default, existing target directories are not overwritten.
USAGE
}

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --dry-run)
      DRY_RUN=1
      ;;
    --force)
      FORCE=1
      ;;
    --backup)
      BACKUP=1
      ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      echo "Unknown option: $1" >&2
      usage >&2
      exit 1
      ;;
  esac
  shift
done

if [[ "${FORCE}" -eq 1 && "${BACKUP}" -eq 1 ]]; then
  echo "--force and --backup are mutually exclusive" >&2
  exit 1
fi

if [[ ! -d "${SOURCE_DIR}" ]]; then
  echo "Source skills directory not found: ${SOURCE_DIR}" >&2
  exit 1
fi

echo "Source: ${SOURCE_DIR}"
echo "Target: ${TARGET_DIR}"
if [[ "${BACKUP}" -eq 1 ]]; then
  echo "Backup root: ${BACKUP_ROOT}"
fi

if [[ "${DRY_RUN}" -eq 0 ]]; then
  mkdir -p "${TARGET_DIR}"
fi

installed=0
skipped=0
timestamp="$(date +%Y%m%d-%H%M%S)"

for skill_dir in "${SOURCE_DIR}"/*; do
  [[ -d "${skill_dir}" ]] || continue

  skill_name="$(basename "${skill_dir}")"
  target="${TARGET_DIR}/${skill_name}"

  if [[ ! -f "${skill_dir}/SKILL.md" ]]; then
    echo "Skip ${skill_name}: missing SKILL.md" >&2
    continue
  fi

  if [[ -e "${target}" ]]; then
    if [[ "${BACKUP}" -eq 1 ]]; then
      backup_dir="${BACKUP_ROOT}/${timestamp}/${skill_name}"
      echo "Backup ${target} -> ${backup_dir}"
      if [[ "${DRY_RUN}" -eq 0 ]]; then
        mkdir -p "$(dirname "${backup_dir}")"
        mv "${target}" "${backup_dir}"
      fi
    elif [[ "${FORCE}" -eq 1 ]]; then
      echo "Replace existing ${target}"
      if [[ "${DRY_RUN}" -eq 0 ]]; then
        rm -rf "${target}"
      fi
    else
      echo "Skip ${skill_name}: target exists. Use --force to replace or --backup to preserve it." >&2
      skipped=$((skipped + 1))
      continue
    fi
  fi

  echo "Install ${skill_name} -> ${target}"
  if [[ "${DRY_RUN}" -eq 0 ]]; then
    cp -R "${skill_dir}" "${target}"
  fi
  installed=$((installed + 1))
done

if [[ "${installed}" -eq 0 ]]; then
  if [[ "${skipped}" -gt 0 ]]; then
    echo "No skills installed; ${skipped} target directories already existed." >&2
    if [[ "${DRY_RUN}" -eq 1 ]]; then
      echo "Dry run complete: use --dry-run --force or --dry-run --backup to preview replacement behavior."
      exit 0
    fi
  else
    echo "No skills installed from ${SOURCE_DIR}" >&2
  fi
  exit 1
fi

if [[ "${DRY_RUN}" -eq 1 ]]; then
  echo "Dry run complete: ${installed} skills would be installed into ${TARGET_DIR}; ${skipped} skipped."
else
  echo "Installed ${installed} skills into ${TARGET_DIR}; ${skipped} skipped."
fi
