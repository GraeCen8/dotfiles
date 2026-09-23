-- Change the default Omarchy look'n'feel.

-- https://wiki.hypr.land/Configuring/Basics/Variables/#general
hl.config({
  general = {
--     -- No gaps between windows or borders.
    gaps_in = 3,
    gaps_out = 3,
    border_size = 2,
    layout = "scrolling",
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#decoration
hl.config({
  decoration = {
    blur = {
      -- Blur the wallpaper / windows behind transparent apps (e.g. foot terminal with alpha=0.95).
      enabled = true,
      size = 5,
      passes = 2,
      ignore_opacity = true,
      new_optimizations = true,
      xray = false,
    },
  },
})

-- https://wiki.hypr.land/Configuring/Basics/Variables/#animations
-- hl.config({
--   animations = {
--     -- Disable all animations.
--     enabled = false,
--   },
-- })

-- https://wiki.hypr.land/Configuring/Basics/Variables/#layout
-- hl.config({
--   layout = {
--     -- Avoid overly wide single-window layouts on wide screens.
--     single_window_aspect_ratio = { 1, 1 },
--   },
-- })

-- https://wiki.hypr.land/Configuring/Animations/
-- Fast vertical slide for workspace up/down switching.
-- Overrides Omarchy default which disables workspaces animation.
-- slidevert auto-slides from above/below based on direction (e-1 / e+1).
hl.animation({ leaf = "workspaces", enabled = true, speed = 6, bezier = "easeOutQuint", style = "slidevert" })

-- https://wiki.hypr.land/Configuring/Layouts/Scrolling-Layout/
-- hl.config({
--   scrolling = {
--     -- See only one column per screen instead of two.
-- r   column_width = 0.97,
--   },
-- })
