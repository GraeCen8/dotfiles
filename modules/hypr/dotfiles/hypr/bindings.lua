-- Mango-style keybindings: hjkl for directional actions (arrows -> hjkl),
-- and the old hjkl bindings moved to the arrow keys (hjkl -> arrows).

-- ==========================================================================
-- 1. Unbind every default binding that is being replaced (arrows and hjkl).
-- ==========================================================================

-- Arrow-key bindings (moving to hjkl)
hl.unbind("SUPER + LEFT")
hl.unbind("SUPER + RIGHT")
hl.unbind("SUPER + UP")
hl.unbind("SUPER + DOWN")
hl.unbind("SUPER + SHIFT + LEFT")
hl.unbind("SUPER + SHIFT + RIGHT")
hl.unbind("SUPER + SHIFT + UP")
hl.unbind("SUPER + SHIFT + DOWN")
hl.unbind("SUPER + SHIFT + ALT + LEFT")
hl.unbind("SUPER + SHIFT + ALT + RIGHT")
hl.unbind("SUPER + SHIFT + ALT + UP")
hl.unbind("SUPER + SHIFT + ALT + DOWN")
hl.unbind("SUPER + ALT + LEFT")
hl.unbind("SUPER + ALT + RIGHT")
hl.unbind("SUPER + ALT + UP")
hl.unbind("SUPER + ALT + DOWN")
hl.unbind("SUPER + CTRL + LEFT")
hl.unbind("SUPER + CTRL + RIGHT")

-- hjkl bindings (moving to arrows)
hl.unbind("SUPER + J")
hl.unbind("SUPER + K")
hl.unbind("SUPER + L")
hl.unbind("SUPER + ALT + K")
hl.unbind("SUPER + CTRL + K")
hl.unbind("SUPER + CTRL + H")
hl.unbind("SUPER + CTRL + L")

-- ==========================================================================
-- 2. hjkl: the directional bindings formerly on the arrow keys.
-- ==========================================================================

-- Focus between windows (was SUPER + LEFT/RIGHT/UP/DOWN)
o.bind("SUPER + H", "Focus on left window", hl.dsp.focus({ direction = "l" }))
o.bind("SUPER + L", "Focus on right window", hl.dsp.focus({ direction = "r" }))
o.bind("SUPER + K", "Focus on above window", hl.dsp.focus({ direction = "u" }))
o.bind("SUPER + J", "Focus on below window", hl.dsp.focus({ direction = "d" }))

-- Swap windows (was SUPER + SHIFT + LEFT/RIGHT/UP/DOWN)
o.bind("SUPER + SHIFT + H", "Swap window to the left", hl.dsp.window.swap({ direction = "l" }))
o.bind("SUPER + SHIFT + L", "Swap window to the right", hl.dsp.window.swap({ direction = "r" }))
o.bind("SUPER + SHIFT + K", "Swap window up", hl.dsp.window.swap({ direction = "u" }))
o.bind("SUPER + SHIFT + J", "Swap window down", hl.dsp.window.swap({ direction = "d" }))

-- Move workspace to a monitor (was SUPER + SHIFT + ALT + LEFT/RIGHT/UP/DOWN)
o.bind("SUPER + SHIFT + ALT + H", "Move workspace to left monitor", hl.dsp.workspace.move({ monitor = "l" }))
o.bind("SUPER + SHIFT + ALT + L", "Move workspace to right monitor", hl.dsp.workspace.move({ monitor = "r" }))
o.bind("SUPER + SHIFT + ALT + K", "Move workspace to up monitor", hl.dsp.workspace.move({ monitor = "u" }))
o.bind("SUPER + SHIFT + ALT + J", "Move workspace to down monitor", hl.dsp.workspace.move({ monitor = "d" }))

-- Move window into a group (was SUPER + ALT + LEFT/RIGHT/UP/DOWN)
o.bind("SUPER + ALT + H", "Move window to group on left", hl.dsp.window.move({ into_group = "l" }))
o.bind("SUPER + ALT + L", "Move window to group on right", hl.dsp.window.move({ into_group = "r" }))
o.bind("SUPER + ALT + K", "Move window to group on top", hl.dsp.window.move({ into_group = "u" }))
o.bind("SUPER + ALT + J", "Move window to group on bottom", hl.dsp.window.move({ into_group = "d" }))

-- Move grouped window focus (was SUPER + CTRL + LEFT/RIGHT)
o.bind("SUPER + CTRL + H", "Move grouped window focus left", hl.dsp.group.prev())
o.bind("SUPER + CTRL + L", "Move grouped window focus right", hl.dsp.group.next())

-- ==========================================================================
-- 3. arrows: the bindings that used hjkl.
-- ==========================================================================

-- Toggle window split (was SUPER + J)
o.bind("SUPER + DOWN", "Toggle window split", hl.dsp.layout("togglesplit"))

-- Keybindings menu (was SUPER + K)
o.bind("SUPER + UP", "Keybindings", "omarchy-menu-keybindings")

-- Toggle workspace layout (was SUPER + L)
o.bind("SUPER + RIGHT", "Toggle workspace layout", "omarchy-hyprland-workspace-layout-toggle")

-- Tmux keybindings (was SUPER + ALT + K)
o.bind("SUPER + ALT + UP", "Tmux keybindings", "omarchy-menu-tmux-keybindings")

-- Herdr keybindings (was SUPER + CTRL + K)
o.bind("SUPER + CTRL + UP", "Herdr keybindings", "omarchy-menu-herdr-keybindings")

-- Hardware menu (was SUPER + CTRL + H)
o.bind("SUPER + CTRL + LEFT", "Hardware menu", "omarchy-menu toggle hardware")

-- Lock system (was SUPER + CTRL + L)
o.bind("SUPER + CTRL + RIGHT", "Lock system", "omarchy-system-lock")

-- ==========================================================================
-- 4. Workspace navigation, top-to-bottom (mango's viewtoleft/viewtoright).
-- ==========================================================================

-- SUPER+U = up a workspace (previous), SUPER+I = down a workspace (next)
o.bind("SUPER + U", "Previous workspace (up)", hl.dsp.focus({ workspace = "e-1" }))
o.bind("SUPER + I", "Next workspace (down)", hl.dsp.focus({ workspace = "e+1" }))

-- ==========================================================================
-- 5. Scrolling layout extras (mango's switch_proportion_preset on SUPER+R).
-- ==========================================================================

-- Cycle column width through the "0.5, 0.8, 1.0" preset
o.bind("SUPER + R", "Cycle column width", hl.dsp.layout("colresize +conf"))
o.bind("SUPER + SHIFT + R", "Cycle column width back", hl.dsp.layout("colresize -conf"))

-- other app launcher menu
o.bind("SUPER + D", "Apps menu", "omarchy-menu toggle apps")
