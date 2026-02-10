#!/usr/bin/env bash
set -e
REPO="https://raw.githubusercontent.com/ahmadmute/freedom/main"

if ! command -v curl &>/dev/null; then
  echo "curl is required."
  exit 1
fi

if [[ -w /usr/local/bin ]] 2>/dev/null; then
  TARGET="/usr/local/bin/freedom"
  curl -fsSL "$REPO/freedom.sh" | sed 's/\r$//' > "$TARGET"
  chmod +x "$TARGET"
elif command -v sudo &>/dev/null && sudo -n true 2>/dev/null; then
  TARGET="/usr/local/bin/freedom"
  curl -fsSL "$REPO/freedom.sh" | sed 's/\r$//' | sudo tee "$TARGET" >/dev/null
  sudo chmod +x "$TARGET"
else
  mkdir -p "$HOME/bin"
  TARGET="$HOME/bin/freedom"
  curl -fsSL "$REPO/freedom.sh" | sed 's/\r$//' > "$TARGET"
  chmod +x "$TARGET"
  echo "Added to $TARGET. Add to PATH if needed: export PATH=\"\$HOME/bin:\$PATH\""
fi

echo "Installed to $TARGET. Run: freedom"
