#!/usr/bin/env bash
set -e

# ---- Check arguments ----
if [ "$#" -eq 0 ]; then
  echo "Usage: $0 <package> [package2 ...]"
  echo "Example: $0 ultralytics torch numpy"
  exit 1
fi

# ---- UV-prefixed temporary paths ----
UV_TMP_BASE="$HOME/uv-tmp-$$"
UV_TMP_DIR="$UV_TMP_BASE/tmp"

mkdir -p "$UV_TMP_DIR"

echo "Using temporary directories:"
echo "  TMPDIR=$UV_TMP_DIR"
echo "  UV_CACHE_DIR=/dev/null"
echo "Installing packages: $*"
echo

# ---- Run uv install with overridden env ----
TMPDIR="$UV_TMP_DIR" \
  TEMP="$UV_TMP_DIR" \
  TMP="$UV_TMP_DIR" \
  UV_CACHE_DIR=/dev/null \
  uv pip install --no-cache "$@"

# ---- Cleanup ----
rm -rf "$UV_TMP_BASE"

echo
echo "✔ Installation complete. Temporary UV directories removed."
