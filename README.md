# desktop-assets

Catálogo reproducible de iconos, temas GTK/Qt, cursores y fuentes para mi
escritorio (CachyOS + niri + DankMaterialShell).

Todo se resuelve desde **repos oficiales o el AUR**. Nada viene de un repo
personal ni se compila a mano, así que en una máquina nueva basta:

```sh
git clone https://github.com/arqueon/desktop-assets
cd desktop-assets
paru -S --needed --asdeps papirus-folders catppuccin-cursors-mocha
makepkg
sudo pacman -U arqueon-desktop-{assets,engine,icons,themes,qt,cursors,fonts}-*.pkg.tar.zst
```

El primer paso existe porque esas dos son las únicas *depends* duras que viven
en el AUR; todo lo demás es de repos oficiales y `pacman -U` lo arrastra solo.

**Ni `paru -U` ni `makepkg -si` sirven aquí** (comprobado el 10-jul-2026 con
paru 2.1.0): `paru -U` es un *passthrough* a `pacman -U` y no resuelve
dependencias del AUR — instala en silencio solo los metas cuyas dependencias ya
estén presentes y deja fuera el resto. Y `makepkg -si` instala **todos** los
subpaquetes del split, incluido `fonts-pairings`, que por diseño va aparte.

Los paquetes están **vacíos**: solo declaran dependencias. No instalan nada en
`$HOME` ni escriben configuración. Qué tema se usa en cada momento lo decide
DankMaterialShell, y lo propaga su plugin `dms-theme-sync`.

## Los paquetes

| Paquete | Qué trae |
|---|---|
| `arqueon-desktop-assets` | meta: instala todos los de abajo |
| `arqueon-desktop-engine` | `matugen` (color dinámico) + `papirus-folders` |
| `arqueon-desktop-icons` | Papirus como set de trabajo; Adwaita y Breeze como fallback |
| `arqueon-desktop-themes` | `adw-gtk3`, más alternativas en `optdepends` |
| `arqueon-desktop-qt` | `qt5ct` + `qt6ct` |
| `arqueon-desktop-cursors` | cursores Catppuccin (los 16 acentos) |
| `arqueon-desktop-fonts` | mono, interfaz, documento y cobertura |
| `arqueon-desktop-fonts-pairings` | dos pares tipográficos para documentos |

El meta **no** incluye `fonts-pairings`: son fuentes de maquetación, no del
escritorio. Instálalo aparte si hace falta — sus fuentes variables también
viven en el AUR:

```sh
paru -S --needed --asdeps ttf-archivo-variable ttf-archivo-narrow \
  ttf-piazzolla-variable ttf-impallari-libre-franklin ttf-spline-sans-mono
sudo pacman -U arqueon-desktop-fonts-pairings-*.pkg.tar.zst
``` Los dos pares son
Archivo + Archivo Narrow + Piazzolla, y Libre Franklin + Source Serif 4 +
Spline Sans Mono; hasta ahora vivían como ficheros sueltos en
`~/.local/share/fonts`, y las seis familias resultan estar empaquetadas.

## Decisiones que conviene no reabrir

**No hay tema GTK4.** libadwaita ignora `~/.themes` y `gtk-theme-name` por
completo. Solo obedece las sobrescrituras de color en
`~/.config/gtk-4.0/gtk.css` —que es lo que matugen escribe— y el
`color-scheme` del portal. Cualquier cosa vendida como "tema GTK4" es
decorativa.

**Gradience y `catppuccin/gtk` están muertos.** El primero archivado en julio de
2024 y fuera del AUR; el segundo archivado en junio de 2024. Ojo con el paquete
`catppuccin-gtk-theme-mocha`, que sigue apuntando al repo muerto: el vivo es
`catppuccin-gtk-theme-git`, de Fausto-Korpsvart.

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

## `recipes/` — PKGBUILD corregidos

Paquetes del AUR que **no compilan** y hay que arreglar antes de poder
depender de ellos. Cada receta explica el fallo y la corrección.

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
