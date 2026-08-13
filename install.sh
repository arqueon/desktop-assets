#!/usr/bin/env bash
set -euo pipefail

repo_url=https://github.com/arqueon/desktop-assets.git
papirus_package=papirus-folders-catppuccin-git
install_dms=false
install_fonts=false
workdir=
makepkg_config=
sudo_keepalive_pid=

cleanup() {
  local exit_status=$?

  if [[ -n ${sudo_keepalive_pid} ]]; then
    kill "${sudo_keepalive_pid}" 2>/dev/null || true
    wait "${sudo_keepalive_pid}" 2>/dev/null || true
  fi
  if [[ -n ${workdir} ]]; then
    rm -rf -- "${workdir}"
  fi

  return "${exit_status}"
}

install_with_paru() {
  paru -S --needed --noconfirm --skipreview --noupgrademenu \
    --sudoloop --sudoflags=-n "$@"
}

build_and_install() {
  local recipe_dir=$1
  shift

  (
    cd "${recipe_dir}"
    makepkg --config "${makepkg_config}" --cleanbuild --force --check \
      --syncdeps --noconfirm

    local -a built_packages selected_packages selectors
    local package_path package_name selector
    mapfile -t built_packages < <(
      makepkg --config "${makepkg_config}" --packagelist
    )
    selectors=("$@")

    if ((${#selectors[@]} == 0)); then
      selected_packages=("${built_packages[@]}")
    else
      selected_packages=()
      for package_path in "${built_packages[@]}"; do
        package_name=${package_path##*/}
        for selector in "${selectors[@]}"; do
          if [[ ${package_name} == "${selector}-"* ]]; then
            selected_packages+=("${package_path}")
            break
          fi
        done
      done
    fi

    if ((${#selected_packages[@]} == 0)); then
      printf 'No built packages selected in %s\n' "${recipe_dir}" >&2
      exit 1
    fi

    sudo -n pacman -U --needed --noconfirm "${selected_packages[@]}"
  )
}

usage() {
  cat <<'EOF'
Usage: ./install.sh [options]

Installs the Arqueon desktop asset meta packages.

Options:
  --all             Install the base, DMS integration, and font pairings
  --dms             Install the optional Catppuccin Kvantum/GTK pairing
  --fonts           Install the optional document font pairings
  --stock-papirus   Use stock papirus-folders instead of Catppuccin colours
  -h, --help        Show this help
EOF
}

while (($#)); do
  case $1 in
    --all)
      install_dms=true
      install_fonts=true
      ;;
    --dms) install_dms=true ;;
    --fonts) install_fonts=true ;;
    --stock-papirus) papirus_package=papirus-folders ;;
    -h|--help)
      usage
      exit 0
      ;;
    *)
      printf 'Unknown option: %s\n\n' "$1" >&2
      usage >&2
      exit 2
      ;;
  esac
  shift
done

if ((EUID == 0)); then
  printf 'Run this script as your normal user, not as root.\n' >&2
  exit 1
fi

for command_name in git makepkg pacman paru sudo; do
  if ! command -v "$command_name" >/dev/null; then
    printf 'Required command not found: %s\n' "$command_name" >&2
    exit 1
  fi
done

trap cleanup EXIT

printf '\n==> Authenticating sudo (the only possible prompt)\n'
sudo -v

# Keep the single authentication alive while the cursor and GTK themes build.
# Every later privileged call uses -n, so an expired credential fails instead
# of stopping halfway through the install to ask another question.
(
  while sleep 45; do
    sudo -n -v || exit 0
  done
) &
sudo_keepalive_pid=$!

export GIT_TERMINAL_PROMPT=0

workdir=$(mktemp -d /tmp/arqueon-desktop-assets.XXXXXX)
makepkg_config=${workdir}/makepkg.conf

# makepkg normally invokes `sudo -k`, which deliberately invalidates the
# credential and asks again for every dependency transaction. Preserve the
# system/user build settings but force its pacman wrapper through cached,
# noninteractive sudo instead.
{
  cat /etc/makepkg.conf
  user_makepkg_config=${XDG_CONFIG_HOME:-${HOME}/.config}/pacman/makepkg.conf
  if [[ -r ${user_makepkg_config} ]]; then
    cat "${user_makepkg_config}"
  elif [[ -r ${HOME}/.makepkg.conf ]]; then
    cat "${HOME}/.makepkg.conf"
  fi
  printf '\nPACMAN_AUTH=(sudo -n)\n'
} >"${makepkg_config}"

if [[ -n ${ARQUEON_DESKTOP_ASSETS_SOURCE_DIR:-} ]]; then
  if [[ ! -f ${ARQUEON_DESKTOP_ASSETS_SOURCE_DIR}/PKGBUILD ]]; then
    printf 'Invalid ARQUEON_DESKTOP_ASSETS_SOURCE_DIR: %s\n' \
      "${ARQUEON_DESKTOP_ASSETS_SOURCE_DIR}" >&2
    exit 1
  fi
  cd "${ARQUEON_DESKTOP_ASSETS_SOURCE_DIR}"
else
  printf '\n==> Downloading desktop-assets\n'
  git clone --depth 1 "$repo_url" "$workdir/repo"
  cd "$workdir/repo"
fi

printf '\n==> Installing AUR prerequisites\n'
install_with_paru --asdeps \
  "$papirus_package" \
  catppuccin-cursors-mocha \
  fish \
  gtk-engine-murrine \
  jq \
  librsvg \
  python \
  qadwaitadecorations-qt6 \
  kvantum-theme-libadwaita-git \
  qt6ct-kde \
  xorg-xcursorgen

printf '\n==> Building and installing Material Bibata cursor variants\n'
build_and_install recipes/material-bibata-cursor

printf '\n==> Building and installing the base meta packages\n'
build_and_install .

if [[ $install_dms == true ]]; then
  printf '\n==> Installing optional DMS integration\n'
  install_with_paru --asdeps \
    gnome-themes-extra \
    kvantum-theme-catppuccin-git \
    sassc

  printf '\n==> Building Catppuccin GTK without session integration\n'
  build_and_install recipes/catppuccin-gtk-theme-git
fi

if [[ $install_fonts == true ]]; then
  printf '\n==> Installing optional document font pairings\n'
  install_with_paru --asdeps \
    ttf-archivo-variable \
    ttf-archivo-narrow \
    ttf-piazzolla-variable \
    ttf-spline-sans-mono

  build_and_install recipes/otf-impallari-libre-franklin \
    ttf-impallari-libre-franklin
  build_and_install recipes/arqueon-desktop-fonts-pairings
fi

printf '\n==> Installation completed successfully\n'
