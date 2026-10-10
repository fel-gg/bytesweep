#!/usr/bin/env bash
set -euo pipefail

if [[ "$(uname -s)" != "Linux" ]]; then
  printf '%s\n' 'SKIPPED: Linux installer runtime requires a Linux/WSL2 host.'
  exit 0
fi

repository_root="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")/../.." && pwd)"
temporary_root="$(mktemp -d "${TMPDIR:-/tmp}/bytesweep-install.XXXXXX")"
trap 'rm -rf -- "${temporary_root}"' EXIT

desktop_home="${temporary_root}/home with space/用户"
desktop_bin="${desktop_home}/.local/bin"
desktop_apps="${desktop_home}/.local/share/applications"
outside_sentinel="${temporary_root}/outside-sentinel.txt"
mkdir -p -- "${desktop_home}"
printf '%s\n' 'must-survive' > "${outside_sentinel}"
HOME="${desktop_home}" XDG_BIN_HOME="${desktop_bin}" XDG_DATA_HOME="${desktop_home}/.local/share" \
  bash "${repository_root}/linux/desktop/Install_Desktop.sh" >/dev/null
test -x "${desktop_bin}/bytesweep"
test -x "${desktop_bin}/bytesweep-native"
test -f "${desktop_apps}/bytesweep.desktop"
grep -F "Exec=\"${desktop_bin}/bytesweep\" --menu" "${desktop_apps}/bytesweep.desktop" >/dev/null
# A user-owned config in the install prefix must survive an update and the
# scoped uninstall; installers do not own arbitrary sibling files.
desktop_config="${desktop_bin}/bytesweep.conf"
printf '%s\n' 'user-setting=keep' > "${desktop_config}"
HOME="${desktop_home}" XDG_BIN_HOME="${desktop_bin}" XDG_DATA_HOME="${desktop_home}/.local/share" \
  bash "${repository_root}/linux/desktop/Install_Desktop.sh" >/dev/null
grep -Fx 'user-setting=keep' "${desktop_config}" >/dev/null
HOME="${desktop_home}" XDG_BIN_HOME="${desktop_bin}" XDG_DATA_HOME="${desktop_home}/.local/share" \
  bash "${repository_root}/linux/desktop/Install_Desktop.sh" uninstall >/dev/null
test ! -e "${desktop_bin}/bytesweep"
test ! -e "${desktop_bin}/bytesweep-native"
test ! -e "${desktop_apps}/bytesweep.desktop"
grep -Fx 'user-setting=keep' "${desktop_config}" >/dev/null
grep -Fx 'must-survive' "${outside_sentinel}" >/dev/null

if [[ "${EUID}" -eq 0 ]]; then
  server_bin="${temporary_root}/server bin"
  BYTESWEEP_SERVER_BIN_DIR="${server_bin}" \
    bash "${repository_root}/linux/server/Install_Server.sh" >/dev/null
  test -x "${server_bin}/bytesweep-server"
  test -x "${server_bin}/bytesweep-native"
  BYTESWEEP_SERVER_BIN_DIR="${server_bin}" \
    bash "${repository_root}/linux/server/Install_Server.sh" uninstall >/dev/null
  test ! -e "${server_bin}/bytesweep-server"
  test ! -e "${server_bin}/bytesweep-native"
  printf '%s\n' 'server-setting=keep' > "${server_bin}/bytesweep.conf"
  BYTESWEEP_SERVER_BIN_DIR="${server_bin}" \
    bash "${repository_root}/linux/server/Install_Server.sh" >/dev/null
  grep -Fx 'server-setting=keep' "${server_bin}/bytesweep.conf" >/dev/null
  BYTESWEEP_SERVER_BIN_DIR="${server_bin}" \
    bash "${repository_root}/linux/server/Install_Server.sh" uninstall >/dev/null
  grep -Fx 'server-setting=keep' "${server_bin}/bytesweep.conf" >/dev/null
  grep -Fx 'must-survive' "${outside_sentinel}" >/dev/null
fi

printf '%s\n' 'Linux installer path-space, executable-bit, and server smoke checks passed.'
