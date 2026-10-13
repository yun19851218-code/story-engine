#!/usr/bin/env bash
# 安裝剪片與文案引擎需要的所有工具。
# 用法：bash scripts/setup.sh
set -euo pipefail
cd "$(dirname "$0")/.."

# 系統工具：ffmpeg（剪片核心）與思源黑體（繁中字幕字型）
if ! command -v ffmpeg >/dev/null || ! fc-list | grep -q "Noto Sans CJK"; then
  SUDO=""; [ "$(id -u)" -ne 0 ] && SUDO="sudo"
  $SUDO apt-get update -q
  DEBIAN_FRONTEND=noninteractive $SUDO apt-get install -y -q --no-install-recommends $(cat packages.txt)
fi

# Python 套件裝在專案自己的虛擬環境，避免和系統套件衝突
[ -d .venv ] || python3 -m venv .venv
.venv/bin/pip install -q --upgrade pip
.venv/bin/pip install -q -r requirements.txt

ffmpeg -version | head -1
.venv/bin/python -c "import moviepy, faster_whisper, opencc, streamlit; print('剪片工具安裝完成')"
