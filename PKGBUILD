# Maintainer: Rubén García <arqueonautis@gmail.com>
#
# Reproducible desktop asset catalogue: icons, GTK/Qt themes, cursors and fonts.
# Everything here resolves from the official repositories or the AUR — nothing
# is fetched from a personal repo or built by hand. The install flow lives in
# the README: pre-install the two hard AUR depends with paru, then makepkg and
# pacman -U the metas (paru -U is a pacman passthrough and cannot resolve AUR
# dependencies; makepkg -si would install fonts-pairings, which stays separate).
#
# Nothing is installed to $HOME and no configuration is written: the runtime
# theme is chosen by DankMaterialShell and propagated by its dms-theme-sync
# plugin. These packages only make the assets available.

pkgbase=arqueon-desktop-assets
pkgname=(
  arqueon-desktop-assets
  arqueon-desktop-engine
  arqueon-desktop-icons
  arqueon-desktop-themes
  arqueon-desktop-qt
  arqueon-desktop-cursors
  arqueon-desktop-fonts
  arqueon-desktop-fonts-pairings
)
pkgver=1.0.0
pkgrel=1
pkgdesc="Curated desktop assets (meta packages)"
arch=('any')
url="https://github.com/arqueon/desktop-assets"
license=('MIT')

package_arqueon-desktop-assets() {
  pkgdesc="Curated desktop assets — everything"
  depends=(
    arqueon-desktop-engine
    arqueon-desktop-icons
    arqueon-desktop-themes
    arqueon-desktop-qt
    arqueon-desktop-cursors
    arqueon-desktop-fonts
  )
}

package_arqueon-desktop-engine() {
  pkgdesc="Dynamic colour engine: Material You generation and folder recolouring"
  # matugen emits the @define-color sets libadwaita honours; papirus-folders is
  # the only single-package folder recolourer (every other theme ships one
  # package per colour).
  depends=(matugen papirus-folders)
}

package_arqueon-desktop-icons() {
  pkgdesc="Icon themes: Papirus as the working set, Adwaita/Breeze as fallback"
  # Papirus has the widest app coverage for a GTK+Qt+Electron mix and ~80 folder
  # colours in one package. Adwaita and Breeze are not decoration: GTK and Qt
  # fall back to them for icons a theme is missing, so they always stay.
  depends=(papirus-icon-theme adwaita-icon-theme breeze-icons)
  optdepends=(
    'tela-icon-theme: flat, colourful alternative'
    'colloid-icon-theme-git: closest match to a Material shell'
    'qogir-icon-theme-git: muted Material alternative'
    'fluent-icon-theme-git: Windows 11 look'
    'kora-icon-theme: elegant, well maintained'
    'papirus-folders-catppuccin-git: Catppuccin folder accents for Papirus'
  )
}

package_arqueon-desktop-themes() {
  pkgdesc="GTK themes. GTK4/libadwaita takes colour only — see the note below"
  # adw-gtk-theme provides adw-gtk3{,-dark}: the only GTK3 theme that tracks
  # libadwaita, and the one matugen recolours cleanly.
  #
  # There is deliberately no GTK4 theme here. libadwaita ignores ~/.themes and
  # gtk-theme-name entirely; it honours only ~/.config/gtk-4.0/gtk.css colour
  # overrides (what matugen writes) and the portal's colour-scheme. Anything
  # sold as a "GTK4 theme" is decorative. Gradience was archived in 2024-07 and
  # is gone from the AUR; catppuccin/gtk was archived in 2024-06 — the AUR
  # package catppuccin-gtk-theme-mocha still points at that dead repo, so use
  # catppuccin-gtk-theme-git (Fausto-Korpsvart), which is alive.
  depends=(adw-gtk-theme)
  optdepends=(
    'catppuccin-gtk-theme-git: Catppuccin, 9 accents in light and dark'
    'colloid-gtk-theme-git: Material-flavoured, actively maintained'
    'orchis-theme: rounded Material theme (official repo)'
    'fluent-gtk-theme-git: Windows 11 look'
    'whitesur-gtk-theme-git: macOS look'
    'graphite-gtk-theme-git: flat, high-contrast'
  )
}

package_arqueon-desktop-qt() {
  pkgdesc="Qt5/Qt6 consistency on a non-KDE Wayland session"
  # QT_QPA_PLATFORMTHEME=qt6ct plus the palette DMS writes to
  # ~/.config/qt6ct/colors/. Never QT_QPA_PLATFORMTHEME=kde outside Plasma.
  depends=(qt5ct qt6ct)
  optdepends=(
    'kvantum: SVG-drawn Qt widgets (needs a Kvantum theme; qt6ct alone is enough for colour)'
    'kvantum-qt5: the same for Qt5'
    'qadwaitadecorations-qt6: Adwaita-style client-side decorations for Qt apps'
    'qt6-tools: provides qtdiag, which dms-theme-sync uses to list the platform themes and styles Qt can load'
  )
}

package_arqueon-desktop-cursors() {
  pkgdesc="Cursor themes"
  # Catppuccin's cursors are generated from Bibata's SVG source, so the XCursor
  # alias set is complete — an incomplete set is what makes Qt and Electron apps
  # fall back to the X11 arrow. All 16 accents ship in one package, which is the
  # only practical "recolour": XCursor themes are pre-rendered bitmaps per size
  # and cannot be tinted at runtime.
  #
  # hyprcursor is pointless on niri, which renders the cursor through XCursor.
  depends=(catppuccin-cursors-mocha)
  optdepends=(
    'catppuccin-cursors-latte: light-mode counterpart'
    'bibata-cursor-theme: the classic shape (upstream quiet since 2024)'
    'capitaine-cursors: neutral, complete, good at HiDPI'
    'phinger-cursors: soft alternative'
    'adwaita-cursors: GNOME default, fallback'
  )
}

package_arqueon-desktop-fonts() {
  pkgdesc="Coding, UI and document fonts, with Nerd glyphs by fallback"
  # ttf-nerd-fonts-symbols instead of patched fonts: fontconfig serves the icon
  # codepoints as a fallback, so ligatures and variable axes survive and no
  # family is duplicated.
  #
  # ttf-ms-fonts is deliberately absent: its EULA forbids redistribution.
  # ttf-liberation is metric-compatible and license-clean.
  depends=(
    otf-cascadia-code
    ttf-jetbrains-mono
    ttf-nerd-fonts-symbols
    ttf-roboto
    inter-font
    adobe-source-serif-fonts
    noto-fonts
    noto-fonts-cjk
    noto-fonts-emoji
    ttf-liberation
  )
  optdepends=(
    'maplemono-nf: rounded coding font with the best ligatures and real italics'
    'maplemono-variable: the same, unpatched, as a variable font'
    'otf-monaspace: five-style superfamily with texture healing'
    'ttf-iosevka-nerd: narrow, fits more columns'
    'ttf-fira-code: classic ligature font'
    'ttf-jetbrains-mono-nerd: patched JetBrains Mono, for terminals without font fallback'
    'adwaita-fonts: GNOME Adwaita Sans and Mono'
  )
}

package_arqueon-desktop-fonts-pairings() {
  pkgdesc="Two document typeface pairings (sans + serif + mono)"
  # These were carried around as loose files in ~/.local/share/fonts
  # (direccion-a, direccion-c). Every one of them is packaged, so there is
  # nothing to redistribute here — which also sidesteps having to ship the OFL
  # text alongside the binaries.
  #
  # The variable builds are chosen deliberately: the loose files were variable
  # (Archivo[wdth_wght], Piazzolla[opsz_wght], ...), and the static AUR packages
  # would silently lose the axes.
  #
  # Pairing A: Archivo + Archivo Narrow + Piazzolla
  # Pairing C: Libre Franklin + Source Serif 4 + Spline Sans Mono
  depends=(
    ttf-archivo-variable
    ttf-archivo-narrow
    ttf-piazzolla-variable
    ttf-impallari-libre-franklin
    adobe-source-serif-fonts
    ttf-spline-sans-mono
  )
}
