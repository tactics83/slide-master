#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"
mkdir -p projects

printf '\n[slide-master] Codespace ready. Repository: %s\n' "$(basename "$(pwd)")"
printf '[slide-master] Python: '; python --version || true
printf '[slide-master] Node: '; node --version || true
printf '[slide-master] Codex: '; codex --version || true
printf '[slide-master] OfficeCLI: '; officecli --version || true
printf '\nUse `codex` from the repository root to start a PPT task.\n\n'
