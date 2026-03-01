# .xinitrc — runs when X starts (via startx)

# Restore last pywal theme (wallpaper + colors)
wal -R

# Apply colors to legacy terminals
xrdb -merge ~/.cache/wal/colors.Xresources

# Start i3
exec i3
