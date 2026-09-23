#!/usr/bin/env python3
"""Generate qutebrowser startpage dashboard from the current Omarchy palette.

Reads:  ~/.local/state/omarchy/current/theme/colors.toml
Writes: startpage.html (next to this script)

EDIT YOUR LINKS in the CATEGORIES list below, then re-run:
    python3 generate-startpage.py
It re-runs automatically on `omarchy theme set` (theme-set hook) and
every 10 min via the qute-startpage systemd user timer, so theme and
stats stay fresh.
"""

import os
import shutil
import subprocess
import tomllib
from datetime import datetime

# --- Link sections disabled (user removed them 2026-09-23).
# To bring them back, add: [(section, [(label, url, hint), ...])] ---
CATEGORIES = []

# Must mirror c.url.searchengines in config.py
BANGS = {
    "!yt": "https://www.youtube.com/results?search_query={}",
    "!apkg": "https://archlinux.org/packages/?q={}",
    "!adoc": "https://wiki.archlinux.org/index.php?search={}",
    "!odoc": "https://duckduckgo.com/?q=site%3Aomarchy.org%2Fmanual+{}",
    "!aur": "https://aur.archlinux.org/packages/?K={}",
    "!gh": "https://github.com/search?q={}&type=repositories",
    "!w": "https://en.wikipedia.org/wiki/Special:Search?search={}",
    "!g": "https://www.google.com/search?q={}",
}
DEFAULT_SEARCH = "https://duckduckgo.com/?q={}"

DEFAULTS = {
    "mode": "dark",
    "accent": "#89b4fa",
    "selection": "#45475a",
    "muted": "#585b70",
    "background": "#1e1e2e",
    "dark_background": "#161622",
    "darker_background": "#101019",
    "lighter_background": "#313244",
    "foreground": "#cdd6f4",
    "dark_foreground": "#6c7086",
    "light_foreground": "#bac2de",
    "bright_foreground": "#cdd6f4",
}


def load_palette():
    pal = dict(DEFAULTS)
    path = os.path.expanduser("~/.local/state/omarchy/current/theme/colors.toml")
    try:
        with open(path, "rb") as f:
            data = tomllib.load(f)
        for k in pal:
            if k in data:
                pal[k] = data[k]
    except (FileNotFoundError, OSError, tomllib.TOMLDecodeError):
        pass
    return pal


def _run(cmd, timeout=30):
    try:
        r = subprocess.run(cmd, capture_output=True, text=True, timeout=timeout)
        return r.stdout.strip() if r.returncode == 0 else None
    except (OSError, subprocess.TimeoutExpired):
        return None


def collect_stats():
    s = {}
    try:
        s["kernel"] = os.uname().release.split("-")[0]
    except OSError:
        s["kernel"] = "n/a"
    try:
        secs = int(float(open("/proc/uptime").read().split()[0]))
        d, secs = divmod(secs, 86400)
        h, m = divmod(secs, 3600)[0], (secs % 3600) // 60
        s["uptime"] = (f"{d}d " if d else "") + f"{h}h {m}m"
    except OSError:
        s["uptime"] = "n/a"
    for label, path in (("root", "/"), ("home", os.path.expanduser("~"))):
        try:
            du = shutil.disk_usage(path)
            s[f"disk_{label}"] = f"{du.free // 1024**3}G free"
        except OSError:
            s[f"disk_{label}"] = "n/a"
    out = _run(["pacman", "-Qq"], timeout=30)
    s["pkgs"] = str(len(out.splitlines())) if out else "n/a"
    out = _run(["checkupdates"], timeout=60)
    s["updates"] = str(len(out.splitlines())) if out is not None else "n/a"
    # battery (first BAT* found)
    s["battery"] = "n/a"
    try:
        import glob as _glob
        bats = sorted(_glob.glob("/sys/class/power_supply/BAT*"))
        if bats:
            cap = open(os.path.join(bats[0], "capacity")).read().strip()
            st = open(os.path.join(bats[0], "status")).read().strip().lower()[:4]
            s["battery"] = f"{cap}% {st}"
    except OSError:
        pass
    # load average + memory
    try:
        s["load"] = " ".join(open("/proc/loadavg").read().split()[:3])
    except OSError:
        s["load"] = "n/a"
    try:
        mem = {}
        for line in open("/proc/meminfo"):
            k, v = line.split(":")
            mem[k] = int(v.split()[0])
        used = mem["MemTotal"] - mem["MemAvailable"]
        s["mem"] = f"{used // 1024**2}G/{mem['MemTotal'] // 1024**2}G"
    except (OSError, KeyError, ValueError):
        s["mem"] = "n/a"
    # cpu temp: hottest thermal zone, fallback to `sensors`
    s["temp"] = "n/a"
    try:
        import glob as _glob2
        temps = []
        for z in _glob2.glob("/sys/class/thermal/thermal_zone*/temp"):
            try:
                temps.append(int(open(z).read().strip()) // 1000)
            except (OSError, ValueError):
                continue
        if temps:
            s["temp"] = f"{max(temps)}C"
    except OSError:
        pass
    # failed systemd services (system + user)
    nsys = _run(["systemctl", "--failed", "--no-legend"], timeout=15)
    nusr = _run(["systemctl", "--user", "--failed", "--no-legend"], timeout=15)
    s["failed"] = (
        f"{len(nsys.splitlines()) if nsys else 0}/"
        f"{len(nusr.splitlines()) if nusr else 0}"
    )
    s["generated"] = datetime.now().strftime("%H:%M %d %b")
    return s


def main():
    p = load_palette()
    s = collect_stats()
    here = os.path.dirname(os.path.abspath(__file__))
    out = os.path.join(here, "startpage.html")

    sections = []
    for title, links in CATEGORIES:
        cards = "\n".join(
            f'      <a class="card" href="{url}"><span class="hint">{hint}</span>{label}</a>'
            for label, url, hint in links
        )
        sections.append(
            f'    <section>\n      <h2>{title}</h2>\n'
            f'      <div class="grid">\n{cards}\n      </div>\n    </section>'
        )
    sections_html = "\n".join(sections)
    bangs_js = "\n".join(f'      "{k}": "{v}",' for k, v in BANGS.items())
    stat_rows = "\n".join(
        f'        <div class="stat"><span>{k}</span><b>{v}</b></div>'
        for k, v in [
            ("kernel", s["kernel"]),
            ("uptime", s["uptime"]),
            ("pkgs", s["pkgs"]),
            ("updates", s["updates"]),
            ("battery", s["battery"]),
            ("load", s["load"]),
            ("mem", s["mem"]),
            ("cpu", s["temp"]),
            ("failed s/u", s["failed"]),
            ("/ free", s["disk_root"]),
            ("~ free", s["disk_home"]),
        ]
    )

    html = f"""<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8">
<meta name="color-scheme" content="{p["mode"]}">
<title>~</title>
<style>
  :root {{
    --bg: {p["darker_background"]};
    --panel: {p["dark_background"]};
    --card: {p["lighter_background"]};
    --fg: {p["foreground"]};
    --dim: {p["dark_foreground"]};
    --accent: {p["accent"]};
    --sel: {p["selection"]};
  }}
  * {{ box-sizing: border-box; margin: 0; padding: 0; border-radius: 0 !important; }}
  body {{
    background: var(--bg);
    color: var(--fg);
    font-family: "JetBrainsMono Nerd Font", monospace;
    min-height: 100vh;
    display: flex;
    flex-direction: column;
    align-items: center;
    justify-content: center;
    padding: 2.5rem 1rem;
    gap: 1rem;
  }}
  .wrap {{ width: min(960px, 96vw); display: flex; flex-direction: column; gap: 1rem; }}
  .timebox {{
    display: flex; flex-direction: column; align-items: center; justify-content: center;
    flex: 1; padding: 1rem;
  }}
  #clock {{ font-size: 3rem; letter-spacing: 0.1em; }}
  #date {{ color: var(--dim); font-size: 0.85rem; margin-top: 0.2rem; }}
  .widgets {{ display: grid; grid-template-columns: 1fr 1fr 1fr; gap: 1rem; align-items: stretch; }}
  .midcol {{ display: flex; flex-direction: column; gap: 1rem; }}
  .notes-panel {{ display: flex; flex-direction: column; flex: 1; }}
  .panel {{ background: var(--panel); border: 1px solid var(--sel); }}
  .panel h2 {{
    font-size: 0.75rem; letter-spacing: 0.25em; color: var(--accent);
    padding: 0.5rem 0.8rem; border-bottom: 1px solid var(--sel); background: var(--bg);
  }}
  #cal {{ padding: 0.6rem 0.8rem; }}
  #cal table {{ width: 100%; border-collapse: collapse; font-size: 0.8rem; text-align: center; }}
  #cal th {{ color: var(--dim); font-weight: normal; padding: 0.25rem; }}
  #cal td {{ padding: 0.25rem; }}
  #cal td.today {{ background: var(--accent); color: var(--bg); }}
  .cal-title {{ font-size: 0.8rem; margin-bottom: 0.4rem; }}
  .stat {{
    display: flex; justify-content: space-between;
    padding: 0.45rem 0.8rem; font-size: 0.8rem; border-bottom: 1px solid var(--bg);
  }}
  .stat span {{ color: var(--dim); }}
  .stat b {{ font-weight: normal; }}
  .stat b.warn {{ color: {p.get("yellow", "#f9e2af")}; }}
  .stale {{ font-size: 0.65rem; color: var(--dim); padding: 0.4rem 0.8rem; }}
  .notes-head {{
    display: flex; justify-content: space-between; align-items: center;
    font-size: 0.75rem; letter-spacing: 0.25em; color: var(--accent);
    padding: 0.5rem 0.8rem; border-bottom: 1px solid var(--sel); background: var(--bg);
  }}
  #saved {{ color: var(--dim); letter-spacing: 0; font-size: 0.65rem; }}
  #notes {{
    width: 100%; min-height: 10rem; flex: 1; background: var(--panel); color: var(--fg);
    border: 0; padding: 0.6rem 0.8rem; font: inherit; font-size: 0.82rem;
    outline: none; resize: vertical;
  }}
  form {{ width: 100%; }}
  input {{
    width: 100%; background: var(--card); color: var(--fg);
    border: 1px solid var(--sel); border-left: 4px solid var(--accent);
    padding: 0.7rem 1rem; font: inherit; outline: none;
  }}
  input:focus {{ border-color: var(--accent); border-left: 4px solid var(--accent); }}
  section {{ background: var(--panel); border: 1px solid var(--sel); }}
  section h2 {{
    font-size: 0.75rem; letter-spacing: 0.25em; color: var(--accent);
    padding: 0.5rem 0.8rem; border-bottom: 1px solid var(--sel); background: var(--bg);
  }}
  .grid {{ display: grid; grid-template-columns: repeat(4, 1fr); }}
  .card {{
    background: var(--panel); padding: 0.7rem 0.5rem; text-align: center;
    text-decoration: none; color: var(--fg); font-size: 0.82rem;
    border-right: 1px solid var(--bg); border-bottom: 1px solid var(--bg);
  }}
  .card:hover {{ background: var(--card); color: var(--accent); }}
  .hint {{ display: block; font-size: 0.65rem; color: var(--dim); margin-bottom: 0.2rem; }}
  .card:hover .hint {{ color: var(--accent); }}
</style>
</head>
<body>
<div class="wrap">
  <div class="widgets">
    <div class="panel notes-panel">
      <div class="notes-head"><span>notes</span><span id="saved"></span></div>
      <textarea id="notes" placeholder="scratch ..." spellcheck="false"></textarea>
    </div>
    <div class="midcol">
      <div class="panel">
        <h2>cal</h2>
        <div id="cal"></div>
      </div>
      <form id="search">
        <input id="q" type="text" placeholder="search" autocomplete="off" autofocus>
      </form>
      <div class="panel timebox">
        <div id="clock">--:--</div>
        <div id="date"></div>
      </div>
    </div>
    <div class="panel">
      <h2>sys</h2>
      <div>
{stat_rows}
        <div class="stale">snapshot {s["generated"]}</div>
      </div>
    </div>
  </div>
{sections_html}
</div>
<script>
  const BANGS = {{
{bangs_js}
  }};
  const DEFAULT = "{DEFAULT_SEARCH}";
  document.getElementById("search").addEventListener("submit", (e) => {{
    e.preventDefault();
    const raw = document.getElementById("q").value.trim();
    if (!raw) return;
    const [first, ...rest] = raw.split(/\\s+/);
    if (BANGS[first] && rest.length) {{
      location.href = BANGS[first].replace("{{}}", encodeURIComponent(rest.join(" ")));
    }} else if (BANGS[first]) {{
      location.href = BANGS[first].replace("{{}}", "");
    }} else {{
      location.href = DEFAULT.replace("{{}}", encodeURIComponent(raw));
    }}
  }});
  function tick() {{
    const d = new Date();
    document.getElementById("clock").textContent =
      String(d.getHours()).padStart(2, "0") + ":" + String(d.getMinutes()).padStart(2, "0");
    document.getElementById("date").textContent = d.toDateString();
  }}
  function calendar() {{
    const now = new Date();
    const y = now.getFullYear(), m = now.getMonth();
    const months = ["january","february","march","april","may","june","july",
                    "august","september","october","november","december"];
    const start = (new Date(y, m, 1).getDay() + 6) % 7;
    const days = new Date(y, m + 1, 0).getDate();
    let h = '<div class="cal-title">' + months[m] + " " + y + "</div><table><tr><th>mo</th><th>tu</th><th>we</th><th>th</th><th>fr</th><th>sa</th><th>su</th></tr><tr>";
    for (let i = 0; i < start; i++) h += "<td></td>";
    for (let d = 1; d <= days; d++) {{
      h += d === now.getDate() ? '<td class="today">' + d + "</td>" : "<td>" + d + "</td>";
      if ((start + d) % 7 === 0 && d !== days) h += "</tr><tr>";
    }}
    document.getElementById("cal").innerHTML = h + "</tr></table>";
  }}
  tick();
  calendar();
  setInterval(tick, 10000);
  const notes = document.getElementById("notes");
  const saved = document.getElementById("saved");
  try {{
    notes.value = localStorage.getItem("qute-notes") || "";
  }} catch (e) {{}}
  let t = null;
  notes.addEventListener("input", () => {{
    clearTimeout(t);
    t = setTimeout(() => {{
      try {{
        localStorage.setItem("qute-notes", notes.value);
        const d = new Date();
        saved.textContent = "saved " + String(d.getHours()).padStart(2, "0") +
          ":" + String(d.getMinutes()).padStart(2, "0");
      }} catch (e) {{
        saved.textContent = "not saved (storage blocked)";
      }}
    }}, 500);
  }});
</script>
</body>
</html>
"""
    with open(out, "w") as f:
        f.write(html)
    print(f"wrote {out}")


if __name__ == "__main__":
    main()
