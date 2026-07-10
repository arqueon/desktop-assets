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
  arqueon-desktop-unified
  arqueon-desktop-qt
  arqueon-desktop-cursors
  arqueon-desktop-fonts
  arqueon-desktop-fonts-pairings
  arqueon-desktop-login
)
pkgver=1.1.0
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
    arqueon-desktop-unified
    arqueon-desktop-qt
    arqueon-desktop-cursors
    arqueon-desktop-fonts
    arqueon-desktop-login
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
    'morewaita-icon-theme: adds app icons on top of Adwaita without replacing it; AUR package maintained by the upstream author'
    'adwaita-colors-icon-theme: accent-coloured Adwaita folders (GNOME 47+ style), same author as MoreWaita'
    'vimix-icon-theme: Material flavour, vinceliuice, alive (2025.08)'
    'whitesur-icon-theme-git: completes the WhiteSur look'
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
    'gruvbox-gtk-theme-git: Gruvbox palette (Fausto-Korpsvart family)'
    'tokyonight-gtk-theme-git: Tokyo Night palette (Fausto-Korpsvart family)'
    'everforest-gtk-theme-git: Everforest palette (Fausto-Korpsvart family)'
    'kanagawa-gtk-theme-git: Kanagawa palette (Fausto-Korpsvart family)'
    'rose-pine-gtk-theme: Rose Pine palette'
  )
  # More dead traps besides catppuccin/gtk: dracula-gtk-theme (frozen 2023) and
  # nordic-theme (frozen 2022) are stale AUR packages — deliberately out.
}

package_arqueon-desktop-unified() {
  pkgdesc="Qt apps that pass for GTK: Kvantum with same-author theme pairs and Adwaita CSDs"
  # The Qt<->GTK unification axis (research verified 2026-07-10). KvLibadwaita
  # replicates libadwaita in Qt — the natural partner of adw-gtk3. Its author
  # declares maintenance paused (last push 2025-09), acceptable because the
  # libadwaita look itself is stable; kept as a hard depend with the pairs below
  # as fallback. On CachyOS it comes from the cachyos repo; on vanilla Arch,
  # from the AUR. qadwaitadecorations-qt6 draws Adwaita-style client-side
  # decorations, closing the last visible gap (window titlebars).
  #
  # The optdepends are same-author Kvantum+GTK pairs, so both halves of the
  # desktop are drawn from one design: WhiteSur and Orchis are vinceliuice
  # (kvantum halves live in his -kde repos), Catppuccin's kvantum ships 56
  # variants (4 flavours x 14 accents) matching Fausto-Korpsvart's GTK side.
  # Materia is the only pair fully in official repos, but its upstream (nana-4)
  # has been quiet for years — usable, not a pillar.
  #
  # No Kvantum for Colloid, Graphite or Fluent: their kvantum ports have no
  # AUR package (Fluent's is orphaned since 2020), so they stay out.
  depends=(kvantum kvantum-theme-libadwaita-git qadwaitadecorations-qt6)
  optdepends=(
    'kvantum-qt5: Kvantum for the remaining Qt5 apps'
    'kvantum-theme-whitesur-git: pairs with whitesur-gtk-theme-git (same author)'
    'kvantum-theme-orchis-git: pairs with orchis-theme (same author)'
    'kvantum-theme-catppuccin-git: 56 variants, pairs with catppuccin-gtk-theme-git'
    'kvantum-theme-materia: pairs with materia-gtk-theme, both official repos'
    'materia-gtk-theme: the GTK half of the Materia pair'
  )
}

package_arqueon-desktop-qt() {
  pkgdesc="Qt5/Qt6 consistency on a non-KDE Wayland session"
  # QT_QPA_PLATFORMTHEME=qt6ct plus the palette DMS writes to
  # ~/.config/qt6ct/colors/. Never QT_QPA_PLATFORMTHEME=kde outside Plasma.
  # Kvantum and the CSD plugin moved to arqueon-desktop-unified.
  depends=(qt5ct qt6ct)
  optdepends=(
    'qt6ct-kde: drop-in qt6ct (provides/conflicts it) that parses the KColorScheme palette DMS exports — dms-theme-sync 0.7 builds its kcolorscheme route on it'
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
    'vimix-cursors: vinceliuice, official repo — closes the all-vinceliuice look'
    'nordzy-cursors: Vimix-derived, alive (2.5.0, 2026-04)'
    'xcursor-simp1e: minimal, consistent'
    'googledot-cursor-theme: Google-style dot cursor'
    'notwaita-cursor-theme: Adwaita-flavoured alternative'
  )
  # Alias-set completeness of the five above is NOT verified yet (the Bibata
  # lesson) — inspect before promoting any of them to a depend.
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
    'ttf-monaspace-variable: five-style superfamily with texture healing, variable axes (official repo; replaces otf-monaspace)'
    'ttf-iosevka-nerd: narrow, fits more columns'
    'ttf-fira-code: classic ligature font'
    'ttf-jetbrains-mono-nerd: patched JetBrains Mono, for terminals without font fallback'
    'adwaita-fonts: GNOME Adwaita Sans and Mono'
    'otf-geist-mono-nerd: Vercel Geist Mono with Nerd glyphs (official repo)'
    'ttf-geist: Geist as UI sans, alive (1.8.0)'
    'ttf-geist-mono-variable: Geist Mono, variable build'
    'otf-intel-one-mono: high-legibility mono (cachyos repo; AUR on vanilla Arch)'
    'ttf-commit-mono: neutral, spacing-tuned mono'
    'ttf-0xproto: distinctive-glyph mono, alive (2.502)'
    'ttf-manrope: geometric UI sans, alive (2026-05)'
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

package_arqueon-desktop-login() {
  pkgdesc="Login and boot theming: SDDM and Plymouth (all optional)"
  # Everything here is cosmetic and machine-specific, so nothing is a hard
  # depend: the package exists to document the vetted choices. GRUB themes were
  # evaluated and left out (grub-theme-vimix-* frozen since 2022).
  optdepends=(
    'sddm-silent-theme: modern SDDM theme, alive (1.5.0, 2026-06)'
    'where-is-my-sddm-theme-git: the minimal SDDM alternative'
    'plymouth-theme-catppuccin-mocha-git: boot splash from the Catppuccin project itself'
  )
}
