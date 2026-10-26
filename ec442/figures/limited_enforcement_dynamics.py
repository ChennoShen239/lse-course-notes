"""Redraw slide 33's income and consumption paths; pass lecture7_2026.pdf."""

from pathlib import Path
import sys

import fitz
import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

source = fitz.open(sys.argv[1])
drawings = source[32].get_drawings()
x0 = drawings[1]["items"][0][1].x
x_scale = (drawings[1]["items"][1][1].x - x0) / 5
y_one = drawings[2]["items"][1][1].y
y_scale = 2 * (drawings[2]["items"][0][1].y - y_one)


def coordinates(points):
    return np.array([((p.x - x0) / x_scale,
                      1 + (y_one - p.y) / y_scale) for p in points]).T


income = coordinates([fitz.Point((item[1].x0 + item[1].x1) / 2, item[1].y0)
                      for item in drawings[7]["items"]])
points = [item[1] for item in drawings[8]["items"]]
points.append(drawings[8]["items"][-1][2])
consumption = coordinates(points)

plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 10,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-limited-enforcement-dynamics",
})
fig, ax = plt.subplots(figsize=(6.4, 3.8))
fig.subplots_adjust(left=.09, right=.78, bottom=.19, top=.81)
ax.plot(*income, color=".72", linewidth=.8, marker="o", markersize=2.7)
ax.axhline(1, color=".5", linestyle="--", linewidth=.9)
ax.plot(*consumption, color="#0072B2", linewidth=2.3)
ax.text(40.5, consumption[1, -1] + .035, "Consumption, $c_t$",
        color="#0072B2", va="center", clip_on=False)
ax.text(40.5, .97, "Mean income", color=".4", va="center", clip_on=False)
ax.annotate("Income, $y_t$", xy=income[:, 32], xytext=(32, 1.57),
            ha="center", color=".4",
            arrowprops={"arrowstyle": "-", "color": ".55", "lw": .7})
ax.text(0, 1.08, "Income and consumption\n(income units)",
        transform=ax.transAxes, weight="bold", va="bottom")
ax.text(1, -.15, "Time, $t$ (periods)", transform=ax.transAxes,
        weight="bold", ha="right", va="top")
ax.set(xlim=(-.5, 40), ylim=(.45, 1.62),
       xticks=range(0, 41, 10), yticks=[.5, 1, 1.5])
ax.spines[["top", "right"]].set_visible(False)
ax.spines[["bottom", "left"]].set_color(".5")
ax.tick_params(color=".5")
for extension in ("pdf", "svg"):
    fig.savefig(Path(__file__).with_suffix("." + extension),
                metadata={"Creator": "EC442 lecture notes"})
svg = Path(__file__).with_suffix(".svg")
svg.write_text("\n".join(line.rstrip() for line in svg.read_text().splitlines()) + "\n")
plt.close(fig)
