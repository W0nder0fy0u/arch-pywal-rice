ii# 🎨 Arch Linux Pywal Rice

> **One command. Entire desktop recolors from your wallpaper.**

![Arch Linux](https://img.shields.io/badge/Arch-Linux-1793D1?logo=arch-linux&logoColor=white)
![i3wm](https://img.shields.io/badge/WM-i3-e67e22?logo=i3&logoColor=white)
![pywal](https://img.shields.io/badge/Themed%20by-pywal-27ae60)
![License](https://img.shields.io/badge/License-MIT-blue)

---

## 📸 Preview

> Here's what your desktop will look like after ricing



### Wallpaper Theme
![Preview 2](theme/preview%202.png)

### Theme Switching in Action
![Theme Change](theme/change.png)

### Full Desktop Overview
![Full Theme](theme/theme.png)

---

## ✨ What This Does

```bash
theme ~/Pictures/any-wallpaper.jpg
```

That one command themes your **entire desktop** automatically:

| Component | What gets themed |
|---|---|
| 🖼️ Wallpaper | Set via feh |
| 🪟 i3 window borders | Accent color from wallpaper |
| 📊 i3bar | Background, text, workspace indicator colors |
| 🚀 Rofi launcher | Full theme — background, accent, hover |
| 💻 Terminator | All 16 terminal colors + 80% transparency |
| 🖥️ All terminals | Xresources updated for any terminal |

No manual hex editing. Ever.

---

## 🎨 The 60/30/10 Rule

This setup follows the classic interior design color rule, applied to your desktop:

```
60% ── Background     (dominant color — window backgrounds, bar)
30% ── Secondary      (panels, inactive elements, inputbar)
10% ── Accent         (borders, selections, highlights, prompt)
```

pywal extracts these automatically from whatever wallpaper you give it.

---

## 📦 What You Need

- Arch Linux (or Arch-based: Manjaro, EndeavourOS, etc.)
- i3 window manager
- `yay` AUR helper (installer will set it up if missing)

---

## 🚀 Installation

### 1. Clone the repo

```bash
git clone https://github.com/YOUR_USERNAME/arch-pywal-rice ~/Downloads/arch-pywal-rice
cd ~/Downloads/arch-pywal-rice
```

### 2. Run the installer

```bash
bash install.sh
```

The installer will:
- Install all required packages (`python-pywal`, `picom`, `terminator`, `rofi`, `feh`, `flameshot`, `ttf-firacode-nerd`)
- Copy all pywal templates to `~/.config/wal/templates/`
- Set up rofi, terminator configs
- Install the `theme` script to `~/.local/bin/`
- Add `~/.local/bin` to your PATH

### 3. Apply i3 config

**Option A — Use the included i3 config (replaces yours):**
```bash
cp .config/i3/config ~/.config/i3/config
```

**Option B — Add to your existing i3 config manually:**

Add at the very **top** of `~/.config/i3/config`:
```
include ~/.cache/wal/colors-i3
```

Add in the exec section:
```
exec_always --no-startup-id picom --daemon
exec_always --no-startup-id wal -R
```

Change terminal keybind to:
```
bindsym $mod+Return exec terminator
```

> ⚠️ **Important:** Remove your existing `bar { }` block — the pywal template now manages it.

### 4. Apply your first theme

```bash
theme ~/Pictures/your-wallpaper.jpg
```

Then reload i3 with `Mod+Shift+R`.

---

## 🔄 Daily Usage

```bash
# Change wallpaper + entire theme
theme ~/Pictures/forest.jpg
theme ~/Pictures/city.png
theme ~/Pictures/anime.gif   # GIFs work too!
```

---

## 📁 File Structure

```
arch-pywal-rice/
│
├── README.md
├── install.sh                              ← Run this first
├── .xinitrc                                ← Restores theme on X startup
│
├── theme/                                  ← Preview screenshots
│   ├── change.png
│   ├── prebiew.png
│   ├── preview 2.png
│   └── theme.png
│
├── .config/
│   ├── i3/
│   │   └── config                          ← Full i3 config with pywal
│   │
│   ├── wal/
│   │   └── templates/
│   │       ├── colors-i3                   ← i3 borders + i3bar template
│   │       ├── colors-rofi-dark.rasi       ← Rofi theme template
│   │       └── colors-terminator           ← Terminator + transparency
│   │
│   ├── rofi/
│   │   └── config.rasi                     ← Points rofi to pywal theme
│   │
│   └── terminator/
│       └── config                          ← Base config (overwritten by theme)
│
└── .local/
    └── bin/
        └── theme                           ← Master theme switch script
```

---

## ⚙️ How It Works

```
You run:  theme ~/Pictures/wallpaper.jpg
                    │
                    ▼
             pywal extracts
             16 colors from
             the wallpaper
                    │
        ┌───────────┼───────────┐
        ▼           ▼           ▼
  colors-i3   colors-rofi  colors-terminator
  written to ~/.cache/wal/
        │           │           │
        ▼           ▼           ▼
    i3 reload   rofi reads   cp to
   applies new   on next    ~/.config/
   borders+bar    launch    terminator/
```

pywal fills your templates with real hex values and drops them in `~/.cache/wal/`. Each app reads from there.

---

## 🔧 Troubleshooting

### Rofi errors on launch
```bash
# Check the generated theme file exists and has content
cat ~/.cache/wal/colors-rofi-dark.rasi

# If empty, run wal manually
wal -i ~/Pictures/your-wallpaper.jpg
```

### Terminator not transparent
```bash
# Transparency needs a compositor. Start picom:
picom --daemon &

# Check it's running
pgrep picom && echo "running"
```

### i3 bar not themed
```bash
# Make sure include is at TOP of i3 config (line 1-3)
head -5 ~/.config/i3/config

# Make sure old bar {} block is removed/commented
grep -n "^bar" ~/.config/i3/config
```

### `theme` command not found
```bash
# Reload your shell
source ~/.zshrc  # or source ~/.bashrc

# Or run directly
~/.local/bin/theme ~/Pictures/wallpaper.jpg
```

### Colors look washed out
```bash
# Try increasing saturation
wal -i ~/Pictures/wallpaper.jpg --saturate 0.7

# Or try light mode
wal -i ~/Pictures/wallpaper.jpg -l
```

### FiraCode font not rendering
```bash
# Verify font is installed
fc-list | grep -i fira

# Rebuild font cache
fc-cache -fv
```

---

## ⌨️ Keybindings (i3)

| Keys | Action |
|---|---|
| `Mod+Return` | Open Terminator |
| `Mod+D` | Open Rofi launcher |
| `Mod+Shift+Q` | Close window |
| `Mod+Shift+R` | Restart i3 |
| `Mod+Shift+C` | Reload i3 config |
| `Print` | Screenshot (flameshot) |
| `Mod+1..0` | Switch workspace |
| `Mod+Shift+1..0` | Move window to workspace |
| `Mod+F` | Fullscreen toggle |
| `Mod+H/V` | Split horizontal/vertical |
| `Mod+R` | Resize mode |

> `Mod` key is set to **Alt** (`Mod1`). Change to Super key by replacing `Mod1` with `Mod4` in i3 config.

---

## 🙏 Credits

- [pywal](https://github.com/dylanaraps/pywal) — color extraction engine
- [i3wm](https://i3wm.org/) — window manager
- [rofi](https://github.com/davatorium/rofi) — application launcher
- [picom](https://github.com/yshui/picom) — compositor for transparency
---

## 📄 License

MIT — use it, fork it, make it yours.
