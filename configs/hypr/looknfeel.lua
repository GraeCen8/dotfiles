hl.config({
  general = {
    layout = "scrolling",

    gaps_in = 1,
    gaps_out = 1,
    border_size = 1,
  },

  decoration = {
    rounding = 1,

    shadow = {
      enabled = true,
      range = 20,
      offset = "0 4",
      color = "rgba(00000060)",
    },

    -- Blur behind transparent windows (mango: blur radius 5, 1 pass, noise
    -- 0.02, brightness/contrast 0.9, saturation 1.2).
    blur = {
      enabled = true,
      size = 5,
      passes = 1,
      noise = 0.02,
      brightness = 0.9,
      contrast = 0.9,
      vibrancy = 0.4,
    },
  },

  scrolling = {
    -- Tape runs horizontally: new windows appear to the right and the tape
    -- scrolls right/left. Columns are vertical strips, so focus "down" (j)
    -- moves to the next window in the column and focus "up" (k) to the
    -- previous one; h/l move between columns.
    direction = "right",

    -- scroller_default_proportion = 0.5
    column_width = 0.5,

    -- scroller_proportion_preset = "0.5,0.8,1.0" (cycled with SUPER+R)
    explicit_column_widths = "0.5, 0.8, 1.0",

    -- scroller_focus_center = 0 -> bring focused strip into view, don't center it.
    focus_fit_method = 1,

    -- circle_layout = "scroller,fair" -> focus/swap wraps around the tape.
    wrap_focus = true,
    wrap_swapcol = true,
  },

  animations = {
    enabled = true,
  },
})

-- Animations, mango durations:
--   move/open 450ms, tag/close 300ms, focus 0ms (no focus animation).
-- Hyprland duration ms = 1000 / speed, so:
--   450ms -> speed 2.22, 300ms -> speed 3.33.
hl.animation({ leaf = "windows", enabled = true, speed = 4.44, bezier = "easeOutQuint" })
hl.animation({ leaf = "windowsIn", enabled = true, speed = 4.44, bezier = "easeOutQuint", style = "popin 87%" })
hl.animation({ leaf = "windowsOut", enabled = true, speed = 6.66, bezier = "linear", style = "popin 87%" })
-- Workspaces slide vertically (top-to-bottom) to match the layout direction.
hl.animation({ leaf = "workspaces", enabled = true, speed = 6.66, bezier = "easeOutQuint", style = "slidevert" })
hl.animation({ leaf = "fadeIn", enabled = false })
hl.animation({ leaf = "fadeOut", enabled = false })
hl.animation({ leaf = "fadeSwitch", enabled = true, speed = 3.03, bezier = "quick" })


-- app rules
hl.window_rule({
  match = { class = "firefox" },
  opacity = "0.90 0.90",
})
hl.window_rule({
  opacity = "0.9 0.8",
  match = { class = "foot" },
})
hl.window_rule({
  opacity = "0.9 0.8",
  match = { class = "kitty" },
})
