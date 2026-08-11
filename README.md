# desktop-assets

*Read this in [Spanish](README.es.md).*

Reproducible catalogue of icons, GTK/Qt themes, cursors and fonts for my
desktop (CachyOS + niri + DankMaterialShell).

Everything resolves from **official repos or the AUR**. Nothing comes from a
personal repo or a manual build, so on a fresh machine this is enough:

### Base installation

The simplest route is to download the installer, inspect it, and run it:

```sh
curl -fLO https://raw.githubusercontent.com/arqueon/desktop-assets/master/install.sh
less install.sh
bash install.sh             # base desktop
bash install.sh --all       # base + DMS integration + font pairings
```

Available options are `--dms`, `--fonts`, and `--stock-papirus`. `--dms` adds
the Catppuccin Kvantum/GTK pair; the base already contains the automatic-sync
components. The last option uses the stock Papirus colours instead of the
Catppuccin variant. The script works in a temporary directory and retains the
normal `paru`, `pacman`, and `sudo` confirmations; do not run it as root.

The 28 Material Bibata variants are rendered during installation and occupy
about 550 MiB installed. This is a one-time build unless the pinned recipe is
updated.

The equivalent manual installation is:

```sh
git clone https://github.com/arqueon/desktop-assets
cd desktop-assets
paru -S --needed --asdeps papirus-folders-catppuccin-git catppuccin-cursors-mocha \
  qadwaitadecorations-qt6 kvantum-theme-libadwaita-git qt6ct-kde
(cd recipes/material-bibata-cursor && makepkg -si)
makepkg -si
```

The first step exists because those five are the only hard *depends* that
live in the AUR; everything else comes from official repos and `pacman -U`
pulls it in by itself. (On CachyOS, `kvantum-theme-libadwaita-git` ships in
the `cachyos` repo and paru takes it from there without building.)

`papirus-folders-catppuccin-git` provides the same `papirus-folders` command
as the stock package and intentionally conflicts with it. If paru asks to
replace/remove `papirus-folders`, answer `y`. To keep the stock colours
instead, install `papirus-folders` in the first command and do not install the
Catppuccin variant; never install both.

### Optional integrations

`qt6ct-kde`, `qt6-tools`, `xsettingsd`, `dconf`, Murrine, and all 28
`Bibata-Material-*` variants are now part of the base installation because they
complete the automatic synchronization routes in `dms-theme-sync`.

An additional optional visual pair is:

```sh
paru -S --asdeps kvantum-theme-catppuccin-git catppuccin-gtk-theme-git
```

**`paru -U` does not work here** (verified 2026-07-10 with paru 2.1.0): it is a
*passthrough* to `pacman -U` and does not resolve AUR dependencies. Pre-install
the five AUR dependencies above, install the Bibata recipe, then use
`makepkg -si` or the explicit `pacman -U` command. The optional
`fonts-pairings` meta has its own recipe, so
it cannot block installation or upgrades of the base split package.

The packages are **empty**: they only declare dependencies. They install
nothing into `$HOME` and write no configuration. Which theme is in use at any
moment is decided by DankMaterialShell and propagated by its
`dms-theme-sync` plugin.

## The catalogue

Packages marked with `*` come from the AUR; the rest, from official repos.

### What the meta always installs

`arqueon-desktop-assets` pulls in these eight, and each one its *depends*:

| Metapackage | Assets |
|---|---|
| `arqueon-desktop-engine` | `matugen` (Material You dynamic color) · `papirus-folders`\* (folder recoloring via CLI) · `dconf` · `xsettingsd` |
| `arqueon-desktop-icons` | `papirus-icon-theme` (working set) · `adwaita-icon-theme` and `breeze-icons` (mandatory GTK/Qt fallback) |
| `arqueon-desktop-themes` | `adw-gtk-theme` → `adw-gtk3` / `adw-gtk3-dark` · `breeze-gtk` (GTK half of the native Breeze pair) · `gtk-engine-murrine` (GTK2 themes) |
| `arqueon-desktop-unified` | `breeze` (Qt6) + `breeze5` (Qt5) · `kvantum` · `kvantum-theme-libadwaita-git`† (KvLibadwaita: libadwaita replicated in Qt) · `qadwaitadecorations-qt6`\* (Adwaita-style CSD for Qt windows) |
| `arqueon-desktop-qt` | `qt5ct` · `qt6ct-kde`\* · `qt6-tools` / `qtdiag` |
| `arqueon-desktop-cursors` | `catppuccin-cursors-mocha`\* (all 16 accents, complete XCursor alias set) · `material-bibata-cursor` (local recipe, 28 variants for automatic accent matching) |
| `arqueon-desktop-fonts` | `otf-cascadia-code` · `ttf-jetbrains-mono` · `ttf-nerd-fonts-symbols` (glyphs via fallback) · `ttf-roboto` · `inter-font` · `adobe-source-serif-fonts` · `noto-fonts` + `-cjk` + `-emoji` (coverage) · `ttf-liberation` (MS metrics with a clean license) |
| `arqueon-desktop-login` | (empty: only documents SDDM/Plymouth optionals) |

† `cachyos` repo on CachyOS; AUR on plain Arch. Same for `otf-intel-one-mono`
among the optionals.

In total, the base install is 39 packages: the 9 metas and 30 real
dependencies.

### The Qt + GTK pairs (why `unified` exists)

Qt only looks *the same* as GTK when both halves come from the same design
(research verified 2026-07-10):

| Pair | Qt half | GTK half | Status |
|---|---|---|---|
| **Breeze** | `breeze` (Qt6) + `breeze5` (Qt5), native QStyle | `breeze-gtk` | official repos and installed by the base metas; `dms-theme-sync` selects it only as a complete pair |
| **Libadwaita** (the home team) | `kvantum-theme-libadwaita-git`† | `adw-gtk-theme` | author on declared hiatus (Sep 2025); stable because the libadwaita look doesn't change |
| Qogir | `kvantum-theme-qogir-git`\* | `qogir-gtk-theme-git`\* | same author; separate light/dark and solid variants |
| Lavanda | `kvantum-theme-lavanda-git`\* | `lavanda-gtk-theme-git`\* | same author and packaged; one Kvantum variant for the GTK light/dark family |
| Matcha | `kvantum-theme-matcha-git`\* | `matcha-gtk-theme`\* | same author; local Kvantum-only candidate pins the audited source and patches the tree header |
| WhiteSur | `kvantum-theme-whitesur-git`\* | `whitesur-gtk-theme-git`\* | vinceliuice, alive (GTK Jul 2026) |
| Orchis | `kvantum-theme-orchis-git`\* | `orchis-theme` | vinceliuice, alive |
| Catppuccin | `kvantum-theme-catppuccin-git`\* (56 variants) | `catppuccin-gtk-theme-git`\* (Fausto-Korpsvart) | both sides alive |
| Materia | `kvantum-theme-materia` | `materia-gtk-theme` | the only 100% official-repos pair; upstream quiet for years |

Matcha's GTK half is still maintained, while the KDE repository's `master` has
not changed since August 2020. The local Kvantum-only recipe under `recipes/`
pins the audited commit, backports the tree-header fix from upstream PR #5 and
packages only `Matcha-sea`/`Matcha-sea-dark`. Both variants load with current
Qt 6/Kvantum and the DMS detector selects the correct light/dark half. It is a
local candidate, not an AUR takeover; publication still needs coordination with
the current AUR maintainer.

Without a packaged Kvantum half: Colloid, Graphite and Fluent (Fluent's has
been orphaned since 2020) — out until someone packages them.

### The reference desktop (verified 2026-07-10)

The combination this catalogue feeds, running in production:
DankMaterialShell + [dms-theme-sync ≥ 0.7](https://github.com/arqueon/dms-theme-sync)
with its **Automatic** sync path, `qt6ct-kde` instead of qt6ct, and the complete
pair of the active GTK theme. With that, the path resolves itself on every
apply: native Qt pair (currently Breeze) → Kvantum pair if it exists →
Kvantum rendering of the DMS palette → palette via qt6ct-kde → follow GTK. The plugin detects what is
installed (the `--probe-qt` probe) and diagnoses whatever is missing —
including the silent trap that stock qt6ct cannot read `DankMatugen.colors`
and leaves Qt apps on the default palette without saying a word.

### Documented optionals (`optdepends`)

Nothing installs these; they are the curated menu of alternatives, each with
its rationale in the `PKGBUILD`:

| Scope | Packages |
|---|---|
| Icons | `tela-icon-theme`\* · `colloid-icon-theme-git`\* · `qogir-icon-theme-git`\* · `fluent-icon-theme-git`\* · `kora-icon-theme`\* · `papirus-folders-catppuccin-git`\* (Catppuccin accents for Papirus) · `morewaita-icon-theme`\* (adds apps on top of Adwaita without replacing it; AUR by the author himself) · `adwaita-colors-icon-theme`\* (GNOME 47+ accent folders) · `vimix-icon-theme`\* · `whitesur-icon-theme-git`\* |
| GTK themes | `qogir-gtk-theme-git`\* · `lavanda-gtk-theme-git`\* · `matcha-gtk-theme`\* · `catppuccin-gtk-theme-git`\* (the live one; see `recipes/`) · `colloid-gtk-theme-git`\* · `orchis-theme` · `fluent-gtk-theme-git`\* · `whitesur-gtk-theme-git`\* · `graphite-gtk-theme-git`\* · the Fausto-Korpsvart family by palette: `gruvbox-gtk-theme-git`\* · `tokyonight-gtk-theme-git`\* · `everforest-gtk-theme-git`\* · `kanagawa-gtk-theme-git`\* · `rose-pine-gtk-theme`\* |
| Qt pairs (in `unified`) | `kvantum-qt5` · `kvantum-theme-qogir-git`\* · `kvantum-theme-lavanda-git`\* · `kvantum-theme-matcha-git`\* (local candidate; see `recipes/`) · `kvantum-theme-whitesur-git`\* · `kvantum-theme-orchis-git`\* · `kvantum-theme-catppuccin-git`\* · `kvantum-theme-materia` + `materia-gtk-theme` |
| Cursors | `catppuccin-cursors-latte`\* (light mode) · `bibata-cursor-theme`\* · `capitaine-cursors` · `phinger-cursors`\* · `adwaita-cursors` · `vimix-cursors` (official, vinceliuice) · `nordzy-cursors`\* · `xcursor-simp1e`\* · `googledot-cursor-theme`\* · `notwaita-cursor-theme`\* — the XCursor alias sets of these last five not audited yet |
| Fonts | `maplemono-nf`\* · `maplemono-variable`\* · `ttf-monaspace-variable` (replaces `otf-monaspace`: variable axes, official repo) · `ttf-iosevka-nerd` · `ttf-fira-code` · `ttf-jetbrains-mono-nerd` (for terminals without *font fallback*) · `adwaita-fonts` · `otf-geist-mono-nerd` · `ttf-geist`\* · `ttf-geist-mono-variable`\* · `otf-intel-one-mono`† · `ttf-commit-mono`\* · `ttf-0xproto`\* · `ttf-manrope`\* |
| Login/boot (in `login`) | `sddm-silent-theme`\* · `where-is-my-sddm-theme-git`\* · `plymouth-theme-catppuccin-mocha-git`\* |

### Separate by design: the typographic pairs

The meta does **not** include `arqueon-desktop-fonts-pairings`: those are
layout fonts, not desktop fonts. The two pairs are **Archivo + Archivo
Narrow + Piazzolla** and **Libre Franklin + Source Serif 4 + Spline Sans
Mono**; until now they lived as loose files in `~/.local/share/fonts`, and
all six families turn out to be packaged — in variable builds, which is what
the loose files were. Install it separately when needed:

```sh
paru -S --needed --asdeps ttf-archivo-variable ttf-archivo-narrow \
  ttf-piazzolla-variable ttf-spline-sans-mono
(cd recipes/otf-impallari-libre-franklin && makepkg)   # the AUR one doesn't build
sudo pacman -U recipes/otf-impallari-libre-franklin/ttf-impallari-libre-franklin-*.pkg.tar.zst
(cd recipes/arqueon-desktop-fonts-pairings && makepkg -si)
```

To update after pulling new repository changes, repeat the AUR prerequisite
command and run `makepkg -si` at the repository root. Update the separate font
pairings only if you installed them. Old package files in the working tree are
not installation targets and may be removed after a successful upgrade.

## Decisions best not reopened

**There is no GTK4 theme.** libadwaita ignores `~/.themes` and
`gtk-theme-name` entirely. It only obeys the color overrides in
`~/.config/gtk-4.0/gtk.css` — which is what matugen writes — and the
portal's `color-scheme`. Anything sold as a "GTK4 theme" is decorative.

**Gradience and `catppuccin/gtk` are dead.** The former archived in July
2024 and gone from the AUR; the latter archived *deliberately* in June 2024
("GTK is a nightmare to consistently theme", issue #262). Beware the
`catppuccin-gtk-theme-mocha` package, which still points at the dead repo:
the live one is `catppuccin-gtk-theme-git`, by Fausto-Korpsvart — whose
family (9 palettes under one author: Catppuccin, Gruvbox, Tokyo Night, Rosé
Pine, Everforest, Nightfox, Kanagawa, Solarized Osaka, Material) is the
reference living upstream in 2026. Also frozen and out: `dracula-gtk-theme`
(2023) and `nordic-theme` (2022).

**Papirus, and nothing else, as the working set.** It has the best coverage
for a mix of GTK, Qt and Electron apps, and it is the only one shipping ~80
folder colors in a single package, recolorable via CLI. Tela, Colloid and
friends fall back to the "one package per color" model.

**Adwaita and Breeze are not decoration.** GTK and Qt fall back to them when
a theme is missing an icon. They stay installed, always.

**Nerd Fonts via fallback, not patching.** `ttf-nerd-fonts-symbols` plus one
fontconfig rule serves the icon glyphs without duplicating families or
losing ligatures and variable axes. Installing patched fonts only makes
sense for terminals without *font fallback*.

**Catppuccin cursors.** They are generated from Bibata's SVG source, so the
XCursor alias set is complete — an incomplete alias set is what makes Qt and
Electron fall back to the X11 arrow. All 16 accents come in one package,
which is the only "recoloring" possible: XCursor themes are bitmaps
pre-rendered per size and cannot be tinted on the fly.

**`hyprcursor` is useless on niri**, which draws the cursor via XCursor.

**`ttf-ms-fonts` stays out.** Its EULA forbids redistribution.
`ttf-liberation` is metric-compatible and clean-licensed.

**`kvantum` is optional.** `qt6ct` with the matugen palette already gives
color consistency; Kvantum only adds SVG-drawn widgets, and demands a theme
of its own. Selecting the `kvantum` style without it installed makes Qt fall
back to Fusion without warning.

## `recipes/` — local PKGBUILDs

Build fixes for broken AUR packages and narrowly scoped maintenance candidates.
Each recipe explains its divergence and publication boundary.

- `material-bibata-cursor` — reproducibly builds the 28
  `Bibata-Material-*` accent variants used by dms-theme-sync. Both the colour
  generator and Bibata sources are pinned, and the result is installed
  system-wide under `/usr/share/icons` instead of writing loose files to
  `~/.icons`.

```sh
cd recipes/material-bibata-cursor && makepkg -si
```

- `kvantum-theme-matcha-git` — Kvantum-only maintenance candidate pinned to
  Matcha-kde commit `a3b247b`. It packages the Sea light/dark pair, backports
  upstream PR #5, validates both SVGs and excludes the unported Plasma/SDDM
  assets. The existing AUR package has a maintainer, so this is local until a
  contribution or co-maintenance handoff is agreed.

```sh
cd recipes/kvantum-theme-matcha-git && makepkg --cleanbuild --force --check
```

- `catppuccin-gtk-theme-git` — upstream's `install.sh` ends in a
  "Session Integration" step that applies the theme to the session: it calls
  `xfconf-query`. Inside makepkg's fakeroot there is no session and no
  D-Bus, so it aborts with `Failed to init libxfconf`. Before that it asks
  two interactive questions, which a build must not do either. The
  `install.sh` itself provides the way out (`themes/install.sh:127`): with
  `BATCH_MODE=true` it skips the menu and never reaches the session
  integration. The AUR PKGBUILD doesn't use it. One line.

```sh
cd recipes/catppuccin-gtk-theme-git && makepkg -si
```

- `otf-impallari-libre-franklin` (and its `ttf-` half) — the AUR PKGBUILD
  downloads `archive/master.zip` — a moving target — and validates it
  against an md5 baked in 2020. Upstream has pushed since ("Roman v3.007",
  Sep 2025), so the checksum will never match again. The recipe pins the
  source to the commit and sets `epoch=1` so paru doesn't "update" it back
  to the broken 4.015 (upstream renumbered versions downwards).

```sh
cd recipes/otf-impallari-libre-franklin && makepkg
sudo pacman -U ttf-impallari-libre-franklin-*.pkg.tar.zst
```

## Verification

Package names are not written from memory. Before touching the `PKGBUILD`:

```sh
makepkg --printsrcinfo > .SRCINFO
awk -F' = ' '/^\tdepends|^\toptdepends/{print $2}' .SRCINFO |
  cut -d: -f1 | sort -u | grep -v '^arqueon-' |
  while IFS= read -r p; do
    pacman -Si "$p" >/dev/null 2>&1 && { echo "official $p"; continue; }
    c=$(curl -sf "https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=$p" |
        grep -o '"resultcount":[0-9]*' | cut -d: -f2)
    [ "${c:-0}" -gt 0 ] && echo "AUR     $p" || echo "MISSING $p"
  done
```

It earns its keep: `ttf-maplemono-nf` does not exist (it's `maplemono-nf`),
and `surfn-horst-red-icons-git` is not in the AUR either, despite installing
without complaint from a personal repo.
