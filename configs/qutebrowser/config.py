# qutebrowser config — Oxocarbon Dark
# Same palette as dwl/sway/foot/tmux/wmenu, hardcoded to match there:
#   bg #161616  surface #262626  border #393939  dim #565656
#   fg #dde1e6  bright #f2f4f8   accent #78a9ff  urgent #fa4d56

config.load_autoconfig()

p = {
    "mode": "dark",
    "accent": "#78a9ff",
    "selection": "#393939",
    "muted": "#565656",
    "background": "#161616",
    "dark_background": "#262626",
    "darker_background": "#161616",
    "lighter_background": "#393939",
    "foreground": "#dde1e6",
    "dark_foreground": "#565656",
    "light_foreground": "#dde1e6",
    "bright_foreground": "#f2f4f8",
    "red": "#fa4d56",
    "yellow": "#82cfff",
    "orange": "#be95ff",
    "green": "#42be65",
    "cyan": "#3ddbd9",
    "blue": "#33b1ff",
    "magenta": "#ee5396",
}

bg = p["background"]
bg_dark = p["dark_background"]
bg_darker = p["darker_background"]
bg_light = p["lighter_background"]
fg = p["foreground"]
fg_bright = p["bright_foreground"]
fg_dim = p["dark_foreground"]
accent = p["accent"]
sel = p["selection"]
muted = p["muted"]

# Smooth scrolling (also in autoconfig.yml, pinned here so it's versioned)
c.scrolling.smooth = True

# Search engines / bangs — type e.g. `!yt lofi` in the address bar
c.url.searchengines = {
    "DEFAULT": "https://duckduckgo.com/?q={}",
    "!yt": "https://www.youtube.com/results?search_query={}",
    "!apkg": "https://archlinux.org/packages/?q={}",
    "!adoc": "https://wiki.archlinux.org/index.php?search={}",
    "!odoc": "https://duckduckgo.com/?q=site%3Aomarchy.org%2Fmanual+{}",
    # extras
    "!aur": "https://aur.archlinux.org/packages/?K={}",
    "!gh": "https://github.com/search?q={}&type=repositories",
    "!w": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "!g": "https://www.google.com/search?q={}",
}

# Web pages follow light/dark mode
c.colors.webpage.preferred_color_scheme = p["mode"]
c.colors.webpage.darkmode.enabled = p["mode"] == "dark"

# Statusbar
c.colors.statusbar.normal.bg = bg
c.colors.statusbar.normal.fg = fg
c.colors.statusbar.command.bg = bg_darker
c.colors.statusbar.command.fg = fg
c.colors.statusbar.insert.bg = bg
c.colors.statusbar.insert.fg = accent
c.colors.statusbar.private.bg = bg_darker
c.colors.statusbar.private.fg = p["magenta"]
c.colors.statusbar.caret.bg = bg
c.colors.statusbar.caret.fg = accent
c.colors.statusbar.caret.selection.bg = bg
c.colors.statusbar.caret.selection.fg = accent
c.colors.statusbar.progress.bg = accent
c.colors.statusbar.url.fg = fg
c.colors.statusbar.url.success.http.fg = fg
c.colors.statusbar.url.success.https.fg = p["green"]
c.colors.statusbar.url.error.fg = p["red"]
c.colors.statusbar.url.warn.fg = p["yellow"]
c.colors.statusbar.url.hover.fg = accent

# Tab bar
c.colors.tabs.bar.bg = bg_darker
c.colors.tabs.odd.bg = bg_dark
c.colors.tabs.odd.fg = fg_dim
c.colors.tabs.even.bg = bg_dark
c.colors.tabs.even.fg = fg_dim
c.colors.tabs.selected.odd.bg = accent
c.colors.tabs.selected.odd.fg = bg
c.colors.tabs.selected.even.bg = accent
c.colors.tabs.selected.even.fg = bg
c.colors.tabs.pinned.odd.bg = bg_dark
c.colors.tabs.pinned.odd.fg = fg
c.colors.tabs.pinned.even.bg = bg_dark
c.colors.tabs.pinned.even.fg = fg
c.colors.tabs.pinned.selected.odd.bg = accent
c.colors.tabs.pinned.selected.odd.fg = bg
c.colors.tabs.pinned.selected.even.bg = accent
c.colors.tabs.pinned.selected.even.fg = bg
c.colors.tabs.indicator.start = accent
c.colors.tabs.indicator.stop = accent
c.colors.tabs.indicator.error = p["red"]

# Completion
c.colors.completion.fg = fg
c.colors.completion.odd.bg = bg_dark
c.colors.completion.even.bg = bg_dark
c.colors.completion.category.bg = bg_darker
c.colors.completion.category.fg = accent
c.colors.completion.category.border.top = bg_darker
c.colors.completion.category.border.bottom = bg_darker
c.colors.completion.item.selected.bg = sel
c.colors.completion.item.selected.fg = fg_bright
c.colors.completion.item.selected.border.top = sel
c.colors.completion.item.selected.border.bottom = sel
c.colors.completion.match.fg = accent
c.colors.completion.scrollbar.bg = bg_dark
c.colors.completion.scrollbar.fg = muted

# Hints, downloads, messages, prompts
c.colors.hints.bg = p["yellow"]
c.colors.hints.fg = bg_darker
c.colors.hints.match.fg = sel
c.colors.downloads.bar.bg = bg_darker
c.colors.downloads.start.bg = accent
c.colors.downloads.start.fg = bg_darker
c.colors.downloads.stop.bg = p["green"]
c.colors.downloads.stop.fg = bg_darker
c.colors.downloads.error.bg = p["red"]
c.colors.downloads.error.fg = bg_darker
c.colors.messages.error.bg = p["red"]
c.colors.messages.error.fg = bg_darker
c.colors.messages.error.border = p["red"]
c.colors.messages.warning.bg = p["yellow"]
c.colors.messages.warning.fg = bg_darker
c.colors.messages.warning.border = p["yellow"]
c.colors.messages.info.bg = bg
c.colors.messages.info.fg = fg
c.colors.messages.info.border = bg_light
c.colors.prompts.bg = bg_dark
c.colors.prompts.fg = fg
c.colors.prompts.selected.bg = sel
c.colors.prompts.selected.fg = fg_bright
c.colors.prompts.border = bg_light
c.colors.contextmenu.menu.bg = bg_dark
c.colors.contextmenu.menu.fg = fg
c.colors.contextmenu.selected.bg = sel
c.colors.contextmenu.selected.fg = fg_bright
c.colors.keyhint.bg = bg_darker
c.colors.keyhint.fg = fg
c.colors.keyhint.suffix.fg = accent
c.colors.tooltip.bg = bg_dark
c.colors.tooltip.fg = fg

# Adblocking (needs `python-adblock`: omarchy pkg add python-adblock,
# then `:adblock-update` inside qutebrowser)
c.content.blocking.enabled = True
c.content.blocking.method = "both"
c.content.blocking.adblock.lists = [
    "https://easylist.to/easylist/easylist.txt",
    "https://easylist.to/easylist/easyprivacy.txt",
    "https://secure.fanboy.co.nz/fanboy-cookiemonster.txt",
    "https://easylist.to/easylist/fanboy-social.txt",
]

# Start page / look — local dashboard, regenerated from the Omarchy
# palette by generate-startpage.py (re-run on every theme change)
c.url.start_pages = "file:///home/grae/.config/qutebrowser/startpage.html"
c.url.default_page = "file:///home/grae/.config/qutebrowser/startpage.html"
c.tabs.show = "multiple"
c.zoom.default = 100
c.fonts.default_size = "11pt"
c.fonts.default_family = "JetBrainsMono Nerd Font"
c.fonts.statusbar = "11pt JetBrainsMono Nerd Font"
c.fonts.tabs.selected = "11pt JetBrainsMono Nerd Font"
c.fonts.tabs.unselected = "11pt JetBrainsMono Nerd Font"
c.fonts.completion.entry = "11pt JetBrainsMono Nerd Font"
c.fonts.prompts = "11pt JetBrainsMono Nerd Font"

# Downloads
c.downloads.location.prompt = False
c.downloads.remove_finished = 5000

# Passwords via `pass` + built-in qute-pass userscript
# Install with: omarchy pkg add pass qute-pass  (qute-pass ships with qutebrowser)
# then press ,p on a login page.
config.bind(",p", "spawn --userscript qute-pass")
config.bind(",u", "spawn --userscript qute-pass --username-only")
config.bind(",P", "spawn --userscript qute-pass --password-only")
