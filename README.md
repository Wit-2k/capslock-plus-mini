# capslock-plus-mini

[中文](README_zh-CN.md) | English

`capslock-plus-mini` is a trimmed AutoHotkey v2 keyboard utility derived from CapsLock+. It keeps the core CapsLock modifier workflow and intentionally leaves the original GUI-heavy modules out for now.

This project is a fork of [wo52616111/capslock-plus](https://github.com/wo52616111/capslock-plus).

## Scope

Implemented:

- CapsLock as a modifier key
- Cursor movement and text selection
- Deletion helpers
- Independent CapsLock clipboard slots
- Basic reload and documentation shortcuts
- Brief startup/reload notice animation
- A small set of non-GUI window helpers
- Live loading of `CapsLock+settings.ini` key overrides

Not implemented in this mini version:

- qbar
- Translation GUI/API
- Math Board
- CapsLock+Tab hotstrings
- Full original window-binding persistence
- Bundled user script examples from the original AutoHotkey v1 project

## Requirements

- Windows
- AutoHotkey v2.0+

If `.ahk` files are still associated with AutoHotkey v1, launch explicitly:

```powershell
& 'C:\Program Files\AutoHotkey\v2\AutoHotkey64.exe' 'D:\CS_Tech\AutoHotKey\capslock-plus\CapsLock+.ahk'
```

## Run

Run `CapsLock+.ahk` with AutoHotkey v2. The script relaunches itself as administrator when needed.

Startup and reload show a small non-interactive notice window. It closes automatically as soon as initialization finishes.

Press `CapsLock+F5` to reload.

## Default Shortcuts

In the tables below, `CL` means CapsLock and `LAlt` means left Alt.

### Cursor Movement

| Shortcut | Action |
|---|---|
| `CL+E/S/D/F` | Move up/left/down/right |
| `CL+A/G` | Move one word left/right |
| `CL+P` | Move to line start |
| `CL+;` | Move to line end |
| `CL+LAlt+P` | Move to document start |
| `CL+LAlt+;` | Move to document end |

### Selection

| Shortcut | Action |
|---|---|
| `CL+I/J/K/L` | Select up/left/down/right |
| `CL+H` | Select one word left |
| `CL+.` | Select one word right |
| `CL+,` | Select current word |
| `CL+LAlt+,` | Select current line |
| `CL+U/O` | Select to line start/end |
| `CL+LAlt+U/O` | Select to document start/end |

### Deletion

| Shortcut | Action |
|---|---|
| `CL+W` | Backspace |
| `CL+R` | Delete |
| `CL+[` | Delete to line start |
| `CL+/` | Delete to line end |
| `CL+LAlt+[` | Delete to document start |
| `CL+LAlt+/` | Delete to document end |
| `CL+Backspace` | Delete current line |

### Clipboard

| Shortcut | Action |
|---|---|
| `CL+C/X/V` | Copy/cut/paste through the first CapsLock clipboard slot |
| `CL+LAlt+C/X/V` | Copy/cut/paste through the second CapsLock clipboard slot |
| `Ctrl+V` | Paste from the system clipboard slot tracked by the script |

When no text is selected, `CL+C` and `CL+X` fall back to copying or cutting the current line.

### Other

| Shortcut | Action |
|---|---|
| `CL+Enter` | Insert a new line below |
| `CL+F1` | Open the original CapsLock+ website |
| `CL+F5` | Reload script |
| `CL+F6` | Toggle always-on-top for the active window |
| `CL+F4` | Toggle transparency for the active window |

## Configuration

Runtime settings are stored in `CapsLock+settings.ini`, which is generated automatically and ignored by git.

Override shortcuts in the `[Keys]` section:

```ini
[Keys]
caps_f7=keyFunc_doNothing
caps_lalt_f=keyFunc_moveRight(10)
```

Only functions whose names start with `keyFunc_` are accepted.

## Development Notes

- This branch is AutoHotkey v2-only.
- Legacy AutoHotkey v1 modules and GUI-heavy code have been removed from this mini branch. See the upstream repository for the original full implementation.
- GUI modules should stay out of scope unless explicitly reintroduced.
