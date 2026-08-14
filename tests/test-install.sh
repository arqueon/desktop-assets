#!/usr/bin/env bash
set -euo pipefail

repo_root=$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)
test_root=$(mktemp -d /tmp/desktop-assets-install-test.XXXXXX)
fake_bin=${test_root}/bin
fake_package_dir=${test_root}/packages
command_log=${test_root}/commands.log
mkdir -p "${fake_bin}" "${fake_package_dir}"
trap 'rm -rf -- "${test_root}"' EXIT

cat >"${fake_bin}/sudo" <<'EOF'
#!/usr/bin/env bash
printf 'sudo' >>"${COMMAND_LOG}"
printf ' <%s>' "$@" >>"${COMMAND_LOG}"
printf '\n' >>"${COMMAND_LOG}"

if [[ ${1:-} == -v ]]; then
  exit 0
fi
if [[ ${1:-} == -n ]]; then
  shift
  if [[ ${1:-} == -v ]]; then
    exit 0
  fi
fi
exec "$@"
EOF

cat >"${fake_bin}/paru" <<'EOF'
#!/usr/bin/env bash
printf 'paru' >>"${COMMAND_LOG}"
printf ' <%s>' "$@" >>"${COMMAND_LOG}"
printf '\n' >>"${COMMAND_LOG}"
EOF

cat >"${fake_bin}/pacman" <<'EOF'
#!/usr/bin/env bash
printf 'pacman' >>"${COMMAND_LOG}"
printf ' <%s>' "$@" >>"${COMMAND_LOG}"
printf '\n' >>"${COMMAND_LOG}"
EOF

cat >"${fake_bin}/makepkg" <<'EOF'
#!/usr/bin/env bash
printf 'makepkg cwd=<%s>' "$PWD" >>"${COMMAND_LOG}"
printf ' <%s>' "$@" >>"${COMMAND_LOG}"
printf '\n' >>"${COMMAND_LOG}"

if [[ " $* " == *' --packagelist '* ]]; then
  if [[ $PWD == */recipes/otf-impallari-libre-franklin ]]; then
    : >"$FAKE_PACKAGE_DIR/otf-impallari-libre-franklin-1:3.007-1-any.pkg.tar.zst"
    : >"$FAKE_PACKAGE_DIR/ttf-impallari-libre-franklin-1:3.007-1-any.pkg.tar.zst"
    printf '%s/%s\n' "$FAKE_PACKAGE_DIR" 'otf-impallari-libre-franklin-1:3.007-1-any.pkg.tar.zst'
    printf '%s/%s\n' "$FAKE_PACKAGE_DIR" 'ttf-impallari-libre-franklin-1:3.007-1-any.pkg.tar.zst'
  elif [[ $PWD == */recipes/material-bibata-cursor ]]; then
    : >"$FAKE_PACKAGE_DIR/material-bibata-cursor-1-any.pkg.tar.zst"
    printf '%s/%s\n' "$FAKE_PACKAGE_DIR" 'material-bibata-cursor-1-any.pkg.tar.zst'
    printf '%s/%s\n' "$FAKE_PACKAGE_DIR" 'material-bibata-cursor-debug-1-any.pkg.tar.zst'
  else
    : >"$FAKE_PACKAGE_DIR/fake-${PWD##*/}-1-any.pkg.tar.zst"
    printf '%s/fake-%s-1-any.pkg.tar.zst\n' "$FAKE_PACKAGE_DIR" "${PWD##*/}"
  fi
fi
EOF

cat >"${fake_bin}/git" <<'EOF'
#!/usr/bin/env bash
printf 'git' >>"${COMMAND_LOG}"
printf ' <%s>' "$@" >>"${COMMAND_LOG}"
printf '\n' >>"${COMMAND_LOG}"
EOF

chmod +x "${fake_bin}"/*

run_installer() {
  : >"${command_log}"
  COMMAND_LOG=${command_log} \
    FAKE_PACKAGE_DIR=${fake_package_dir} \
    ARQUEON_DESKTOP_ASSETS_SOURCE_DIR=${repo_root} \
    PATH="${fake_bin}:${PATH}" \
    bash "${repo_root}/install.sh" "$@"
}

assert_all_lines_contain() {
  local prefix=$1
  local required=$2
  local line

  while IFS= read -r line; do
    [[ $line == *"${required}"* ]] || {
      printf 'Missing %s in: %s\n' "${required}" "${line}" >&2
      exit 1
    }
  done < <(grep "^${prefix}" "${command_log}")
}

run_installer --all

[[ $(grep -c '^paru ' "${command_log}") -eq 3 ]]
assert_all_lines_contain paru '<--noconfirm>'
assert_all_lines_contain paru '<--skipreview>'
assert_all_lines_contain paru '<--noupgrademenu>'
assert_all_lines_contain pacman '<--noconfirm>'
while IFS= read -r makepkg_line; do
  [[ $makepkg_line == *'<--config>'* ]]
  [[ $makepkg_line == *'<--syncdeps>'* ]]
  [[ $makepkg_line == *'<--noconfirm>'* ]]
done < <(grep '^makepkg .*<--cleanbuild>' "${command_log}")

if grep '^paru ' "${command_log}" | grep -Fq '<catppuccin-gtk-theme-git>'; then
  printf 'Catppuccin GTK must be built from the local noninteractive recipe\n' >&2
  exit 1
fi
grep -Fq "makepkg cwd=<${repo_root}/recipes/catppuccin-gtk-theme-git>" \
  "${command_log}"
grep -Fq 'BATCH_MODE=true ./install.sh' \
  "${repo_root}/recipes/catppuccin-gtk-theme-git/PKGBUILD"

libre_pacman_line=$(grep '^pacman ' "${command_log}" | grep 'impallari-libre-franklin')
[[ $libre_pacman_line == *'/ttf-impallari-libre-franklin-'* ]]
[[ $libre_pacman_line != *'/otf-impallari-libre-franklin-1:'* ]]

material_pacman_line=$(grep '^pacman ' "${command_log}" | grep 'material-bibata-cursor')
[[ $material_pacman_line == *'/material-bibata-cursor-1-any.pkg.tar.zst'* ]]
[[ $material_pacman_line != *'/material-bibata-cursor-debug-'* ]]

run_installer --stock-papirus

[[ $(grep -c '^paru ' "${command_log}") -eq 1 ]]
grep '^paru ' "${command_log}" | grep -Fq '<papirus-folders>'
if grep '^paru ' "${command_log}" | grep -Fq '<papirus-folders-catppuccin-git>'; then
  printf 'Stock Papirus mode selected the Catppuccin package\n' >&2
  exit 1
fi

printf 'installer tests: ok\n'
