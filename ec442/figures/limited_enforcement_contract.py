"""Redraw slide 27's vector curves; pass lecture7_2026.pdf as argument."""

from pathlib import Path
import sys

import fitz
import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

source = fitz.open(sys.argv[1])
drawings = source[26].get_drawings()
lower, higher, binding = drawings[6:9]
left, top, right, bottom = binding["rect"]


def coordinates(drawing):
    points = [item[1] for item in drawing["items"]]
    points.append(drawing["items"][-1][2])
    # Income ranges from 0.5 to 1.5; the source omits consumption tick values.
    return np.array([(.5 + (p.x - left) / (right - left),
                      (bottom - p.y) / (bottom - top)) for p in points]).T


plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 11,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-limited-enforcement-contract",
})
fig, ax = plt.subplots(figsize=(6.4, 4.7))
fig.subplots_adjust(left=.08, right=.97, bottom=.21, top=.83)
ax.plot(*coordinates(binding), color=".45", linestyle="--", linewidth=1.3)
ax.plot(*coordinates(lower), color="#D89000", marker="o",
        markersize=3.5, linewidth=1.7)
ax.plot(*coordinates(higher), color="#0072B2", marker="o",
        markersize=3.5, linewidth=1.7)
ax.text(.53, coordinates(higher)[1, 0] + .055,
        "Higher promise, $v_H$", color="#0072B2", va="bottom")
ax.text(.53, coordinates(lower)[1, 0] + .035,
        "Lower promise, $v_L$", color="#B57700", va="bottom")
ax.text(.78, .16, "Binding consumption\n$c^b(y_n)$", color=".4")
ax.text(0, 1.08, "Consumption, $c_n$\n(income units)",
        transform=ax.transAxes, weight="bold", va="bottom")
ax.text(1, -.14, "Income, $y_n$\n(income units)",
        transform=ax.transAxes, weight="bold", ha="right", va="top")
ax.set(xlim=(.49, 1.51), ylim=(-.02, 1.08),
       xticks=[.6, .8, 1., 1.2, 1.4], yticks=[])
ax.spines[["top", "right"]].set_visible(False)
ax.spines[["bottom", "left"]].set_color(".5")
ax.tick_params(axis="x", color=".5")
for extension in ("pdf", "svg"):
    fig.savefig(Path(__file__).with_suffix("." + extension),
                metadata={"Creator": "EC442 lecture notes"})
svg = Path(__file__).with_suffix(".svg")
svg.write_text("\n".join(line.rstrip() for line in svg.read_text().splitlines()) + "\n")
plt.close(fig)
