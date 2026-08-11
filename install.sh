#!/usr/bin/env bash
set -euo pipefail

repo_url=https://github.com/arqueon/desktop-assets.git
papirus_package=papirus-folders-catppuccin-git
install_dms=false
install_fonts=false

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

for command_name in git makepkg paru sudo; do
  if ! command -v "$command_name" >/dev/null; then
    printf 'Required command not found: %s\n' "$command_name" >&2
    exit 1
  fi
done

workdir=$(mktemp -d /tmp/arqueon-desktop-assets.XXXXXX)
trap 'rm -rf -- "$workdir"' EXIT

printf '\n==> Downloading desktop-assets\n'
git clone --depth 1 "$repo_url" "$workdir/repo"
cd "$workdir/repo"

printf '\n==> Installing AUR prerequisites\n'
paru -S --needed --asdeps \
  "$papirus_package" \
  catppuccin-cursors-mocha \
  qadwaitadecorations-qt6 \
  kvantum-theme-libadwaita-git \
  qt6ct-kde

printf '\n==> Building and installing Material Bibata cursor variants\n'
(
  cd recipes/material-bibata-cursor
  makepkg -si
)

printf '\n==> Building and installing the base meta packages\n'
makepkg -si

if [[ $install_dms == true ]]; then
  printf '\n==> Installing optional DMS integration\n'
  paru -S --needed --asdeps \
    kvantum-theme-catppuccin-git \
    catppuccin-gtk-theme-git
fi

if [[ $install_fonts == true ]]; then
  printf '\n==> Installing optional document font pairings\n'
  paru -S --needed --asdeps \
    ttf-archivo-variable \
    ttf-archivo-narrow \
    ttf-piazzolla-variable \
    ttf-spline-sans-mono

  (
    cd recipes/otf-impallari-libre-franklin
    makepkg --force
  )

  libre_franklin_packages=(
    recipes/otf-impallari-libre-franklin/ttf-impallari-libre-franklin-*.pkg.tar.zst
  )
  sudo pacman -U --needed "${libre_franklin_packages[@]}"

  (
    cd recipes/arqueon-desktop-fonts-pairings
    makepkg -si
  )
fi

printf '\n==> Installation completed successfully\n'
