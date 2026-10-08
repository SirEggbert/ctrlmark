# CtrlMarks

World of Warcraft marking wheel from [Makers Shack](https://makers-shack.com/projects/ctrlmark/).

Ctrl+left click on a unit opens a mark wheel. Ctrl+left click on empty ground arms a ground marker. Version 1.18.

This repo is the addon only. The family vault stays in `lutz-command-center`.

## Layout

```
CtrlMarks/
  CtrlMarks.toc
  CtrlMarks.lua
  Bindings.xml
  Gold.tga
  Ring.tga
```

Folder name matches the TOC. Zip that folder, not the repo root. Unzipped path must be `CtrlMarks/CtrlMarks.toc`.

## Flavor

`## Interface: 16001` is Forever 1.60.1, not Midnight retail (`120100`). Tag the CurseForge project for the client you tested. Retail will treat this build as out of date until the interface number matches that client.
