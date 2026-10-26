"""Redraw the consumption bands on slide 14; pass lecture8_2026.pdf."""

from pathlib import Path
import sys

import fitz
import matplotlib

matplotlib.use("Agg")
import matplotlib.pyplot as plt

source = fitz.open(sys.argv[1])
drawings = source[13].get_drawings()
origin = drawings[4]["rect"].y1
height = drawings[4]["rect"].height
bands = [((origin - drawings[i]["rect"].y1) / height,
          (origin - drawings[i]["rect"].y0) / height)
         for i in (6, 7, 13, 14)]

plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 10,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-consumption-bands",
})
fig, axes = plt.subplots(1, 2, figsize=(6.6, 3.6))
fig.subplots_adjust(left=.07, right=.98, bottom=.23, top=.71, wspace=.30)

for ax, title, intervals in zip(
        axes, ("No overlap", "Overlap"), (bands[:2], bands[2:])):
    ax.text(0, 1.47, title, transform=ax.transAxes, weight="bold")
    ax.text(0, 1.10, "Consumption, $c$\n(goods units)",
            transform=ax.transAxes, weight="bold", va="bottom")
    if title == "Overlap":
        lower, upper = intervals[1][0], intervals[0][1]
        ax.axhspan(lower, upper, color=".92", zorder=0)
        for bound in (lower, upper):
            ax.axhline(bound, color=".5", linestyle="--", linewidth=.8)
        ax.text(.5, (lower + upper) / 2, "Full\ninsurance",
                ha="center", va="center", fontsize=9)
    for x, (lower, upper), color in zip(
            (0, 1), intervals, ("#0072B2", "#D55E00")):
        ax.plot([x, x], [lower, upper], linewidth=7, color=color,
                solid_capstyle="butt")
    ax.set(xlim=(-.45, 1.45), ylim=(0, 1.06), yticks=[], xticks=[0, 1],
           xticklabels=["Low, $y_1$", "High, $y_2$"])
    ax.text(1, -.30, "Income state", transform=ax.transAxes,
            weight="bold", ha="right", va="top")
    ax.spines[["top", "right"]].set_visible(False)
    ax.spines[["bottom", "left"]].set_color(".5")
    ax.tick_params(color=".5")

for extension in ("pdf", "svg"):
    fig.savefig(Path(__file__).with_suffix("." + extension),
                metadata={"Creator": "EC442 lecture notes"})
svg = Path(__file__).with_suffix(".svg")
svg.write_text("\n".join(line.rstrip() for line in svg.read_text().splitlines()) + "\n")
plt.close(fig)
