# desktop-assets

*Léelo en [inglés](README.md) — esa es la versión canónica; esta traducción puede rezagarse.*

Catálogo reproducible de iconos, temas GTK/Qt, cursores y fuentes para mi
escritorio (CachyOS + niri + DankMaterialShell).

Todo se resuelve desde **repos oficiales o el AUR**. Nada viene de un repo
personal ni se compila a mano, así que en una máquina nueva basta:

```sh
git clone https://github.com/arqueon/desktop-assets
cd desktop-assets
paru -S --needed --asdeps papirus-folders catppuccin-cursors-mocha \
  qadwaitadecorations-qt6 kvantum-theme-libadwaita-git
makepkg
sudo pacman -U arqueon-desktop-{assets,engine,icons,themes,unified,qt,cursors,fonts,login}-*.pkg.tar.zst
```

El primer paso existe porque esas cuatro son las únicas *depends* duras que
viven en el AUR; todo lo demás es de repos oficiales y `pacman -U` lo arrastra
solo. (En CachyOS, `kvantum-theme-libadwaita-git` viene del repo `cachyos` y
paru lo toma de ahí sin compilar.)

Un quinto paso, opcional pero recomendado si el escritorio es DMS:

```sh
paru -S qt6ct-kde        # sustituye a qt6ct (provides/conflicts): mismo qt6ct,
                         # pero capaz de leer la paleta KColorScheme que DMS exporta
```

Y para el emparejado Kvantum↔GTK del tema que uses, su media naranja:

```sh
paru -S --asdeps kvantum-theme-catppuccin-git   # o -whitesur-git, -orchis-git…
```

**Ni `paru -U` ni `makepkg -si` sirven aquí** (comprobado el 10-jul-2026 con
paru 2.1.0): `paru -U` es un *passthrough* a `pacman -U` y no resuelve
dependencias del AUR — instala en silencio solo los metas cuyas dependencias ya
estén presentes y deja fuera el resto. Y `makepkg -si` instala **todos** los
subpaquetes del split, incluido `fonts-pairings`, que por diseño va aparte.

Los paquetes están **vacíos**: solo declaran dependencias. No instalan nada en
`$HOME` ni escriben configuración. Qué tema se usa en cada momento lo decide
DankMaterialShell, y lo propaga su plugin `dms-theme-sync`.

## El catálogo

Los paquetes marcados con `*` vienen del AUR; el resto, de repos oficiales.

### Lo que instala siempre el meta

`arqueon-desktop-assets` arrastra estos ocho, y cada uno sus *depends*:

| Metapaquete | Assets |
|---|---|
| `arqueon-desktop-engine` | `matugen` (color dinámico Material You) · `papirus-folders`\* (recoloreo de carpetas por CLI) |
| `arqueon-desktop-icons` | `papirus-icon-theme` (set de trabajo) · `adwaita-icon-theme` y `breeze-icons` (fallback obligado de GTK/Qt) |
| `arqueon-desktop-themes` | `adw-gtk-theme` → `adw-gtk3` / `adw-gtk3-dark` · `breeze-gtk` (mitad GTK de la pareja Breeze nativa) |
| `arqueon-desktop-unified` | `breeze` (Qt6) + `breeze5` (Qt5) · `kvantum` · `kvantum-theme-libadwaita-git`† (KvLibadwaita: libadwaita replicado en Qt) · `qadwaitadecorations-qt6`\* (CSD estilo Adwaita para ventanas Qt) |
| `arqueon-desktop-qt` | `qt5ct` · `qt6ct` |
| `arqueon-desktop-cursors` | `catppuccin-cursors-mocha`\* (los 16 acentos, alias XCursor completo) |
| `arqueon-desktop-fonts` | `otf-cascadia-code` · `ttf-jetbrains-mono` · `ttf-nerd-fonts-symbols` (glifos por fallback) · `ttf-roboto` · `inter-font` · `adobe-source-serif-fonts` · `noto-fonts` + `-cjk` + `-emoji` (cobertura) · `ttf-liberation` (métricas MS con licencia limpia) |
| `arqueon-desktop-login` | (vacío: solo documenta opcionales de SDDM/Plymouth) |

† repo `cachyos` en CachyOS; AUR en Arch puro. Igual `otf-intel-one-mono` entre
los opcionales.

En total, la instalación base son 34 paquetes: los 9 metas y 25 dependencias
reales.

### Las parejas Qt + GTK (por qué existe `unified`)

Qt solo se ve *igual* que GTK cuando las dos mitades salen del mismo diseño
(investigación verificada 10-jul-2026):

| Pareja | Mitad Qt | Mitad GTK | Estado |
|---|---|---|---|
| **Breeze** | `breeze` (Qt6) + `breeze5` (Qt5), QStyle nativo | `breeze-gtk` | repos oficiales e instalada por los metas base; `dms-theme-sync` sólo la elige como pareja completa |
| **Libadwaita** (la de casa) | `kvantum-theme-libadwaita-git`† | `adw-gtk-theme` | autor en pausa declarada (sep-2025); estable porque el look libadwaita no cambia |
| Qogir | `kvantum-theme-qogir-git`\* | `qogir-gtk-theme-git`\* | mismo autor; variantes claras, oscuras y sólidas separadas |
| Lavanda | `kvantum-theme-lavanda-git`\* | `lavanda-gtk-theme-git`\* | mismo autor y empaquetado; un solo Kvantum para la familia GTK clara/oscura |
| Matcha | `kvantum-theme-matcha-git`\* | `matcha-gtk-theme`\* | mismo autor; candidato local sólo Kvantum con fuente fijada y corrección de cabecera de árbol |
| WhiteSur | `kvantum-theme-whitesur-git`\* | `whitesur-gtk-theme-git`\* | vinceliuice, vivo (GTK jul-2026) |
| Orchis | `kvantum-theme-orchis-git`\* | `orchis-theme` | vinceliuice, vivo |
| Catppuccin | `kvantum-theme-catppuccin-git`\* (56 variantes) | `catppuccin-gtk-theme-git`\* (Fausto-Korpsvart) | vivos ambos lados |
| Materia | `kvantum-theme-materia` | `materia-gtk-theme` | única 100 % repos oficiales; upstream quieto hace años |

La mitad GTK de Matcha sigue mantenida, mientras que la rama `master` del
repositorio KDE no cambia desde agosto de 2020. La receta local sólo Kvantum de
`recipes/` fija el commit auditado, incorpora la corrección de cabecera de árbol
del PR #5 y empaqueta únicamente `Matcha-sea`/`Matcha-sea-dark`. Las dos
variantes cargan con Qt 6/Kvantum actual y DMS elige correctamente claro/oscuro.
Es un candidato local, no una toma del paquete AUR; publicar exige coordinarse
con su mantenedor actual.

Sin Kvantum empaquetado: Colloid, Graphite y Fluent (el de Fluent lleva
huérfano desde 2020) — fuera hasta que alguien los empaquete.

### El escritorio de referencia (verificado 10-jul-2026)

La combinación que este catálogo alimenta y que está corriendo en producción:
DankMaterialShell + [dms-theme-sync ≥ 0.7](https://github.com/arqueon/dms-theme-sync)
con su ruta de sincronización **Automatic**, `qt6ct-kde` en lugar de qt6ct, y
la pareja completa del tema GTK activo. Con eso la ruta se resuelve sola en
cada apply: pareja Qt nativa (por ahora Breeze) → pareja Kvantum si existe →
Kvantum renderizado de la paleta DMS →
paleta vía qt6ct-kde → seguir a GTK. El plugin detecta qué hay instalado (sonda
`--probe-qt`) y diagnostica lo que falte — incluida la trampa silenciosa de que
el qt6ct de fábrica no sabe leer `DankMatugen.colors` y deja las apps Qt con la
paleta por defecto sin decir nada.

### Opcionales documentados (`optdepends`)

No los instala nada; son el menú curado de alternativas, con su porqué en el
`PKGBUILD`:

| Ámbito | Paquetes |
|---|---|
| Iconos | `tela-icon-theme`\* · `colloid-icon-theme-git`\* · `qogir-icon-theme-git`\* · `fluent-icon-theme-git`\* · `kora-icon-theme`\* · `papirus-folders-catppuccin-git`\* (acentos Catppuccin para Papirus) · `morewaita-icon-theme`\* (suma apps sobre Adwaita sin sustituirla; AUR del propio autor) · `adwaita-colors-icon-theme`\* (carpetas con acento GNOME 47+) · `vimix-icon-theme`\* · `whitesur-icon-theme-git`\* |
| Temas GTK | `qogir-gtk-theme-git`\* · `lavanda-gtk-theme-git`\* · `matcha-gtk-theme`\* · `catppuccin-gtk-theme-git`\* (el vivo; ver `recipes/`) · `colloid-gtk-theme-git`\* · `orchis-theme` · `fluent-gtk-theme-git`\* · `whitesur-gtk-theme-git`\* · `graphite-gtk-theme-git`\* · familia Fausto-Korpsvart por paleta: `gruvbox-gtk-theme-git`\* · `tokyonight-gtk-theme-git`\* · `everforest-gtk-theme-git`\* · `kanagawa-gtk-theme-git`\* · `rose-pine-gtk-theme`\* |
| Parejas Qt (en `unified`) | `kvantum-qt5` · `kvantum-theme-qogir-git`\* · `kvantum-theme-lavanda-git`\* · `kvantum-theme-matcha-git`\* (candidato local; ver `recipes/`) · `kvantum-theme-whitesur-git`\* · `kvantum-theme-orchis-git`\* · `kvantum-theme-catppuccin-git`\* · `kvantum-theme-materia` + `materia-gtk-theme` |
| Qt | `qt6ct-kde`\* (sustituto directo de qt6ct con parches para apps KDE; en evaluación para dms-theme-sync) · `qt6-tools` (trae `qtdiag`, que usa dms-theme-sync) |
| Cursores | `catppuccin-cursors-latte`\* (modo claro) · `bibata-cursor-theme`\* · `capitaine-cursors` · `phinger-cursors`\* · `adwaita-cursors` · `vimix-cursors` (oficial, vinceliuice) · `nordzy-cursors`\* · `xcursor-simp1e`\* · `googledot-cursor-theme`\* · `notwaita-cursor-theme`\* — alias XCursor de estos cinco sin auditar aún |
| Fuentes | `maplemono-nf`\* · `maplemono-variable`\* · `ttf-monaspace-variable` (sustituye a `otf-monaspace`: ejes variables, repo oficial) · `ttf-iosevka-nerd` · `ttf-fira-code` · `ttf-jetbrains-mono-nerd` (para terminales sin *font fallback*) · `adwaita-fonts` · `otf-geist-mono-nerd` · `ttf-geist`\* · `ttf-geist-mono-variable`\* · `otf-intel-one-mono`† · `ttf-commit-mono`\* · `ttf-0xproto`\* · `ttf-manrope`\* |
| Login/arranque (en `login`) | `sddm-silent-theme`\* · `where-is-my-sddm-theme-git`\* · `plymouth-theme-catppuccin-mocha-git`\* |

### Aparte, por diseño: los pares tipográficos

El meta **no** incluye `arqueon-desktop-fonts-pairings`: son fuentes de
maquetación, no del escritorio. Los dos pares son **Archivo + Archivo Narrow +
Piazzolla** y **Libre Franklin + Source Serif 4 + Spline Sans Mono**; hasta
ahora vivían como ficheros sueltos en `~/.local/share/fonts`, y las seis
familias resultan estar empaquetadas — en builds variables, que es lo que eran
los ficheros sueltos. Instálalo aparte si hace falta:

```sh
paru -S --needed --asdeps ttf-archivo-variable ttf-archivo-narrow \
  ttf-piazzolla-variable ttf-spline-sans-mono
(cd recipes/otf-impallari-libre-franklin && makepkg)   # el del AUR no compila
sudo pacman -U recipes/otf-impallari-libre-franklin/ttf-impallari-libre-franklin-*.pkg.tar.zst \
  arqueon-desktop-fonts-pairings-*.pkg.tar.zst
```

## Decisiones que conviene no reabrir

**No hay tema GTK4.** libadwaita ignora `~/.themes` y `gtk-theme-name` por
completo. Solo obedece las sobrescrituras de color en
`~/.config/gtk-4.0/gtk.css` —que es lo que matugen escribe— y el
`color-scheme` del portal. Cualquier cosa vendida como "tema GTK4" es
decorativa.

**Gradience y `catppuccin/gtk` están muertos.** El primero archivado en julio de
2024 y fuera del AUR; el segundo archivado *deliberadamente* en junio de 2024
("GTK is a nightmare to consistently theme", issue #262). Ojo con el paquete
`catppuccin-gtk-theme-mocha`, que sigue apuntando al repo muerto: el vivo es
`catppuccin-gtk-theme-git`, de Fausto-Korpsvart — cuya familia (9 paletas bajo
un autor: Catppuccin, Gruvbox, Tokyo Night, Rosé Pine, Everforest, Nightfox,
Kanagawa, Solarized Osaka, Material) es el upstream vivo de referencia en 2026.
También congelados y fuera: `dracula-gtk-theme` (2023) y `nordic-theme` (2022).

**Papirus, y no otro, como set de trabajo.** Tiene la mejor cobertura para una
mezcla de GTK, Qt y Electron, y es el único que trae ~80 colores de carpeta en
un solo paquete, recoloreables por CLI. Tela, Colloid y compañía vuelven al
modelo de "un paquete por color".

**Adwaita y Breeze no son decoración.** GTK y Qt caen en ellos cuando a un tema
le falta un icono. Se quedan siempre instalados.

**Nerd Fonts por fallback, no parcheando.** `ttf-nerd-fonts-symbols` más una
regla de fontconfig sirve los glifos de iconos sin duplicar familias ni perder
ligaduras y ejes variables. Instalar fuentes parcheadas solo tiene sentido para
terminales sin *font fallback*.

**Cursores Catppuccin.** Están generados desde el SVG de Bibata, así que el
juego de alias XCursor está completo — un juego incompleto es lo que hace que
Qt y Electron caigan en la flecha de X11. Los 16 acentos vienen en un paquete,
que es el único "recoloreado" posible: los temas XCursor son mapas de bits
pre-renderizados por tamaño y no se pueden teñir en caliente.

**`hyprcursor` no sirve en niri**, que dibuja el cursor por XCursor.

**`ttf-ms-fonts` queda fuera.** Su EULA prohíbe redistribuir. `ttf-liberation`
es compatible en métricas y de licencia limpia.

**`kvantum` es opcional.** `qt6ct` con la paleta de matugen ya da consistencia
de color; Kvantum solo añade widgets dibujados en SVG, y exige un tema propio.
Elegir el estilo `kvantum` sin tenerlo instalado hace que Qt caiga en Fusion
sin avisar.

## `recipes/` — PKGBUILD locales

Correcciones para paquetes AUR rotos y candidatos de mantenimiento con alcance
estrecho. Cada receta explica su divergencia y la compuerta de publicación.

- `kvantum-theme-matcha-git` — candidato de mantenimiento sólo Kvantum fijado
  al commit `a3b247b` de Matcha-kde. Empaqueta la pareja Sea clara/oscura,
  incorpora el PR #5, valida ambos SVG y excluye Plasma/SDDM todavía sin portar.
  El paquete AUR existente tiene mantenedor: este candidato permanece local
  hasta acordar una contribución o co-mantenimiento.

```sh
cd recipes/kvantum-theme-matcha-git && makepkg --cleanbuild --force --check
```

- `catppuccin-gtk-theme-git` — el `install.sh` de upstream acaba en una
  "Session Integration" que aplica el tema a la sesión: llama a `xfconf-query`.
  Dentro del fakeroot de `makepkg` no hay sesión ni D-Bus, y aborta con
  `Failed to init libxfconf`. Antes de eso hace dos preguntas interactivas, que
  un build tampoco debe hacer. El propio `install.sh` trae la salida
  (`themes/install.sh:127`): con `BATCH_MODE=true` salta el menú y nunca llega
  a la integración con la sesión. El PKGBUILD del AUR no la usa. Una línea.

```sh
cd recipes/catppuccin-gtk-theme-git && makepkg -si
```

- `otf-impallari-libre-franklin` (y su mitad `ttf-`) — el PKGBUILD del AUR
  descarga `archive/master.zip` — un objetivo móvil — y lo valida contra un md5
  horneado en 2020. Upstream ha empujado desde entonces («Roman v3.007»,
  sep-2025), así que el checksum no volverá a cuadrar jamás. La receta fija la
  fuente al commit y pone `epoch=1` para que paru no la "actualice" de vuelta
  al 4.015 roto (upstream renumeró versiones hacia abajo).

```sh
cd recipes/otf-impallari-libre-franklin && makepkg
sudo pacman -U ttf-impallari-libre-franklin-*.pkg.tar.zst
```

## Verificación

Los nombres de paquete no se escriben de memoria. Antes de tocar el `PKGBUILD`:

```sh
makepkg --printsrcinfo > .SRCINFO
awk -F' = ' '/^\tdepends|^\toptdepends/{print $2}' .SRCINFO |
  cut -d: -f1 | sort -u | grep -v '^arqueon-' |
  while IFS= read -r p; do
    pacman -Si "$p" >/dev/null 2>&1 && { echo "oficial $p"; continue; }
    c=$(curl -sf "https://aur.archlinux.org/rpc/?v=5&type=info&arg[]=$p" |
        grep -o '"resultcount":[0-9]*' | cut -d: -f2)
    [ "${c:-0}" -gt 0 ] && echo "AUR     $p" || echo "FALTA   $p"
  done
```

Sirve de algo: `ttf-maplemono-nf` no existe (es `maplemono-nf`), y
`surfn-horst-red-icons-git` tampoco está en el AUR pese a instalarse sin quejas
desde un repo personal.
