#!/usr/bin/env bash
set -Eeuo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
TMP_ROOT="$(mktemp -d)"
trap 'rm -rf "$TMP_ROOT"' EXIT

export RUA_EDGE_INSTALLER_LIB_ONLY=1
# shellcheck source=../install.sh
source "$ROOT_DIR/install.sh"

INSTALL_ROOT="$TMP_ROOT/etc/rua-edge"
BACKUP_DIR="$INSTALL_ROOT/backups"
INSTALL_META="$INSTALL_ROOT/install-meta.json"
CONFIG_FILE="$INSTALL_ROOT/config.yml"
CREDENTIALS_FILE="$INSTALL_ROOT/credentials.env"
BINARY_PATH="$TMP_ROOT/usr/local/bin/rua-edge"
SERVICE_NAME="rua-edge.service"
SERVICE_PATH="$TMP_ROOT/etc/systemd/system/$SERVICE_NAME"
CLI_PATH="$TMP_ROOT/usr/local/bin/rua-edge-ctl"
LEGACY_INSTALL_ROOT="$TMP_ROOT/etc/xboard-node"
LEGACY_BINARY_PATH="$TMP_ROOT/usr/local/bin/xboard-node"
LEGACY_CLI_PATH="$TMP_ROOT/usr/local/bin/xbctl"
LEGACY_SERVICE_NAME="xboard-node.service"
LEGACY_SERVICE_PATH="$TMP_ROOT/etc/systemd/system/$LEGACY_SERVICE_NAME"

systemctl() { return 1; }

mkdir -p "$LEGACY_INSTALL_ROOT/instances/demo" "$(dirname "$LEGACY_SERVICE_PATH")" "$(dirname "$LEGACY_BINARY_PATH")"
cat > "$LEGACY_INSTALL_ROOT/config.yml" <<EOF
instances:
  - id: demo
    kernel:
      config_dir: "$LEGACY_INSTALL_ROOT/instances/demo"
EOF
printf 'INSTANCE_DEMO_API_KEY=test-token\n' > "$LEGACY_INSTALL_ROOT/credentials.env"
printf '{"version":"legacy"}\n' > "$LEGACY_INSTALL_ROOT/install-meta.json"
printf '# legacy unit\n' > "$LEGACY_SERVICE_PATH"
printf '#!/bin/sh\n' > "$LEGACY_BINARY_PATH"
printf '#!/bin/sh\n' > "$LEGACY_CLI_PATH"
chmod +x "$LEGACY_BINARY_PATH" "$LEGACY_CLI_PATH"

migrate_legacy_layout

test -f "$CONFIG_FILE"
test -f "$CREDENTIALS_FILE"
test -f "$INSTALL_META"
test -d "$INSTALL_ROOT/instances/demo"
grep -F "$INSTALL_ROOT/instances/demo" "$CONFIG_FILE" >/dev/null
if grep -F "$LEGACY_INSTALL_ROOT" "$CONFIG_FILE" >/dev/null; then
  echo "legacy path remained in migrated config" >&2
  exit 1
fi

remove_legacy_runtime
test ! -e "$LEGACY_INSTALL_ROOT"
test ! -e "$LEGACY_BINARY_PATH"
test ! -e "$LEGACY_CLI_PATH"
test ! -e "$LEGACY_SERVICE_PATH"

echo "RUA Edge legacy-layout migration test passed"
