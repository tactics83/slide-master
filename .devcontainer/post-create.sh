#!/usr/bin/env bash
set -euo pipefail

cd "$(git rev-parse --show-toplevel)"

echo "[slide-master] Installing Python dependencies..."
python -m pip install --upgrade pip
python -m pip install -r requirements.txt

echo "[slide-master] Installing useful system packages..."
sudo apt-get update
sudo apt-get install -y --no-install-recommends \
  pandoc \
  libreoffice \
  fonts-noto-cjk \
  fontconfig
sudo rm -rf /var/lib/apt/lists/*

echo "[slide-master] Installing Codex CLI and OfficeCLI..."
npm install -g @openai/codex @officecli/officecli@1.0.135

echo "[slide-master] Refreshing font cache..."
fc-cache -f -v >/dev/null 2>&1 || true

echo "[slide-master] Syncing Codex skill discovery stubs..."
python .claude/skills/ppt-master/scripts/sync_codex_stubs.py

mkdir -p projects

cat <<'EOF'

============================================================
 slide-master Codespaces setup complete
============================================================
Next steps:
  1) Run: codex login
  2) Open the repository root in Codex.
  3) Ask naturally, e.g.:
     projects/mydeck/sources/report.pdf 로 임원 보고용 PPT 만들어줘

Optional API secrets can be configured in GitHub Codespaces secrets:
  OPENAI_API_KEY
  GEMINI_API_KEY
============================================================
EOF
