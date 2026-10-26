"""Redraw slides 15-16's consumption paths; pass lecture8_2026.pdf."""

from pathlib import Path
import sys

import fitz
import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

source = fitz.open(sys.argv[1])
histories = ("LHHLHLLHHL", "LLHLHHLHLL")
plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 10,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-consumption-band-dynamics",
})

for page, name in ((14, "nonoverlap"), (15, "overlap")):
    drawings = source[page].get_drawings()
    raw_bounds = np.array([item[1].y for item in drawings[3]["items"]])
    origin, scale = raw_bounds[0], raw_bounds[0] - raw_bounds[-1]
    bounds = np.sort((origin - raw_bounds) / scale)
    labels = ["$c\u0332_1$", r"$\bar{c}_1$",
              "$c\u0332_2$", r"$\bar{c}_2$"]
    low, high = bounds[:2], bounds[2:]
    if name == "overlap":
        labels[1], labels[2] = labels[2], labels[1]
        low, high = bounds[[0, 2]], bounds[[1, 3]]

    fig, axes = plt.subplots(1, 2, figsize=(6.6, 3.5))
    fig.subplots_adjust(left=.075, right=.99, bottom=.22, top=.70, wspace=.27)
    for ax, index, history, title, color in zip(
            axes, (12, 33), histories,
            ("Initially in low band", "Initially in high band"),
            ("#0072B2", "#D55E00")):
        segments = drawings[index]["items"]
        points = [item[1] for item in segments] + [segments[-1][2]]
        consumption = (origin - np.array([point.y for point in points])) / scale
        intervals = np.array([low if state == "L" else high for state in history])
        expected = np.clip(consumption[:-1], intervals[:, 0], intervals[:, 1])
        assert np.allclose(consumption[1:], expected, atol=1e-6)

        if name == "overlap":
            ax.axhspan(bounds[1], bounds[2], color=".94", zorder=0)
        for bound in bounds:
            ax.axhline(bound, color=".75", linestyle="--", linewidth=.7)
        ax.plot(range(11), consumption, color=color, linewidth=1.8,
                marker="o", markersize=3.8)
        ax.text(0, 1.47, title, transform=ax.transAxes, weight="bold", fontsize=10)
        ax.text(0, 1.10, "Consumption, $c_t$\n(goods units)",
                transform=ax.transAxes, weight="bold", va="bottom")
        ax.text(1, -.29, "Income state at $t$", transform=ax.transAxes,
                weight="bold", ha="right", va="top")
        ax.set(xlim=(-.15, 10.35), ylim=(-.10, 1.12),
               yticks=bounds, yticklabels=labels,
               xticks=range(11), xticklabels=["0", *history])
        ax.tick_params(axis="x", labelsize=9)
        ax.tick_params(color=".5")
        ax.spines[["top", "right"]].set_visible(False)
        ax.spines[["bottom", "left"]].set_color(".5")

    output = Path(__file__).with_name("consumption_" + name)
    for extension in ("pdf", "svg"):
        fig.savefig(output.with_suffix("." + extension),
                    metadata={"Creator": "EC442 lecture notes"})
    svg = output.with_suffix(".svg")
    svg.write_text("\n".join(line.rstrip() for line in svg.read_text().splitlines()) + "\n")
    plt.close(fig)
    print(f"Slide {page + 1}: both paths match the consumption adjustment rule.")
