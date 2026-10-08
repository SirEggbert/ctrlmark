# ctrlmark

Small World of Warcraft marking addon from [Makers Shack](https://makers-shack.com/projects/ctrlmark/).

This repo is the addon only. The family vault stays in `lutz-command-center`. Do not put health, money, or house notes here.

## Status

Package shape is ready. The marking logic written on the game PC is not in this repo yet. Drop those `.lua` files into `ctrlmark/` and replace the stub before a CurseForge upload.

## Layout

```
ctrlmark/
  ctrlmark.toc
  ctrlmark.lua
```

Folder name and TOC name must match. CurseForge rejects a mismatch.

## Zip

Zip the `ctrlmark` folder, not the repo root. Unzipped, the path must be `ctrlmark/ctrlmark.toc`. Leave out `.git`.

## TOC

`## Interface: 120100` matches Midnight 12.1.0 as of 2026-09-10. Confirm it against the client you tested on before upload. Retail only for the first release.
