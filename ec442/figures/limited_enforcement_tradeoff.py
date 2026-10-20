"""Reproduce slide 20's vector curves; pass lecture7_2026.pdf as argument."""

from pathlib import Path
import sys

import fitz
import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

source = fitz.open(sys.argv[1])
drawings = source[19].get_drawings()
blue = next(d for d in drawings if d["type"] == "s"
            and d["color"][2] > 0.65 and len(d["items"]) > 2)
gray = next(d for d in drawings if d["type"] == "s"
            and len(d["items"]) > 20)
origin = drawings[1]["items"][0][1]
width = drawings[1]["items"][0][2].x - origin.x
height = origin.y - drawings[3]["items"][0][2].y


def coordinates(drawing):
    points = [item[1] for item in drawing["items"]]
    points.append(drawing["items"][-1][2])
    return np.array([((p.x - origin.x) / width,
                      (origin.y - p.y) / height) for p in points]).T


plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 11,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-limited-enforcement-tradeoff",
})
fig, ax = plt.subplots(figsize=(6.4, 5.4))
fig.subplots_adjust(left=0.08, right=0.97, bottom=0.21, top=0.84)
ax.plot(*coordinates(gray), color="0.45", linestyle="--", linewidth=1.5)
ax.plot(*coordinates(blue), color="#0072B2", marker="o",
        markersize=4, linewidth=1.7)
ax.text(0.12, 0.75, "Limited enforcement\noptimal $(c_n,v'_n)$",
        color="#0072B2", va="bottom")
ax.text(0.43, 0.23, "Flat-consumption benchmark\n$v'=u(c)/(1-\\beta)$",
        color="0.4", va="top")
ax.text(0, 1.06, "Continuation promise, $v'_n$\n(discounted utility)",
        transform=ax.transAxes, weight="bold", va="bottom")
ax.text(1, -0.08, "Current consumption, $c_n$\n(income units)",
        transform=ax.transAxes, weight="bold", ha="right", va="top")
ax.set(xlim=(0, 1), ylim=(0, 1), xticks=[], yticks=[])
ax.set_aspect(height / width)
ax.spines[["top", "right"]].set_visible(False)
ax.spines[["bottom", "left"]].set_color("0.5")
for extension in ("pdf", "svg"):
    fig.savefig(Path(__file__).with_suffix("." + extension),
                metadata={"Creator": "EC442 lecture notes"})
plt.close(fig)
