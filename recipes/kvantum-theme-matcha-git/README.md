# Local Matcha Kvantum package candidate

This recipe packages only the two maintained-scope Kvantum themes from
[`vinceliuice/Matcha-kde`](https://github.com/vinceliuice/Matcha-kde):

- `Matcha-sea`
- `Matcha-sea-dark`

It deliberately excludes the repository's Plasma global theme, desktop theme,
Aurorae and SDDM assets. Those need a separate Plasma 6 port and cannot inherit
support from a successful Kvantum build.

## Local divergence

- The source is pinned to audited commit `a3b247b` instead of following a moving
  branch during every build.
- `pkgrel=2` applies the small tree-header fix proposed in upstream
  [PR #5](https://github.com/vinceliuice/Matcha-kde/pull/5).
- `check()` validates both SVG files and proves that the broken `harrow` element
  is disabled in both `.kvconfig` files.
- The package includes upstream documentation and the GPL-3.0 license.

As verified through the official AUR RPC on 2026-08-09, the existing package is
maintained by `phnt`, is not flagged out of date, and remains at
`r11.a3b247b-1`. This recipe is a local candidate; it must not be presented as
an AUR takeover. Its pinned commit is useful for this reproducible catalogue,
but a contribution to the `-git` package should preserve normal VCS-package
semantics and propose the patch, checks, narrow install scope, and `pkgrel`
bump to the current maintainer.

## Build without installing

```sh
makepkg --cleanbuild --force --check
```

The result should be `kvantum-theme-matcha-git-r11.a3b247b-2-any.pkg.tar.zst`.
