"""Uncalibrated schematics for Lecture 5, slide 32. Run with Python/Matplotlib."""

from pathlib import Path

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

OUT = Path(__file__).parent
THRESHOLD = 0.45
SLOPE = 0.7
BLUE = "#0072B2"
ORANGE = "#B65F00"


def education(g):
    return np.maximum(0, 1 - np.exp(-4 * (g - THRESHOLD)))


def intersections(g0):
    def gap(e):
        return education(g0 + SLOPE * e) - e

    roots = [0.0] if gap(0) == 0 else []
    grid = np.linspace(0.0001, 1, 2000)
    for left, right in zip(grid[:-1], grid[1:]):
        if gap(left) * gap(right) < 0:
            for _ in range(50):
                mid = (left + right) / 2
                if gap(left) * gap(mid) <= 0:
                    right = mid
                else:
                    left = mid
            roots.append((left + right) / 2)
    return roots


plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 11,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-galor-weil",
})

g_grid = np.linspace(0, 1.62, 700)
e_grid = np.linspace(0, 1.08, 300)
regimes = [
    ("malthusian", "small", 0.15, 1, 0.85),
    ("post_malthusian", "intermediate", 0.30, 3, 0.88),
    ("modern", "large", 0.62, 1, 0.55),
]

for name, size, g0, expected_count, label_height in regimes:
    fig, ax = plt.subplots(figsize=(5.2, 3.3))
    fig.subplots_adjust(left=0.19, right=0.96, bottom=0.26, top=0.94)
    ax.plot(g_grid, education(g_grid), color=BLUE, linewidth=1.8)
    ax.plot(g0 + SLOPE * e_grid, e_grid, color=ORANGE,
            linewidth=1.6, linestyle="--")
    ax.text(1.37, 1.01, r"$e(g)$", color=BLUE)
    label_x = g0 + SLOPE * label_height
    ax.text(label_x + (0.035 if size == "large" else -0.035), label_height,
            rf"$g(e; L)$, {size} $L$", color=ORANGE, fontsize=10,
            ha="left" if size == "large" else "right")

    roots = intersections(g0)
    assert len(roots) == expected_count, (name, roots)
    for e in roots:
        g = g0 + SLOPE * e
        response = 0 if e == 0 else 4 * SLOPE * np.exp(-4 * (g - THRESHOLD))
        stable = response < 1
        ax.plot(g, e, "o", color="black", markersize=5.5,
                markerfacecolor="black" if stable else "white", zorder=4)
        print(name, f"g={g:.4f}, e={e:.4f}, response={response:.4f}, stable={stable}")
        if e == 0:
            continue
        elif not stable:
            label, offset = r"$(g_u, e_u)$", (7, -20)
        elif name == "post_malthusian":
            label, offset = r"$(g_h, e_h)$", (7, -23)
        else:
            label, offset = r"$(g^*, e^*)$", (7, -22)
        ax.annotate(label, (g, e), xytext=offset,
                    textcoords="offset points", fontsize=10)

    low_corner = roots[0] == 0
    ax.set(xlim=(-0.04, 1.62), ylim=(-0.04, 1.12),
           xticks=[0, g0, THRESHOLD] if low_corner else [0, THRESHOLD],
           xticklabels=["0", r"$g_0$", r"$\hat g$"] if low_corner else ["0", r"$\hat g$"],
           yticks=[0], yticklabels=["0"])
    ax.set_xlabel("Technological progress, $g$\n(rate per generation)", labelpad=9)
    ax.set_ylabel("Education per child, $e$\n(schematic units)", labelpad=8)
    for side in ["top", "right"]:
        ax.spines[side].set_visible(False)
    ax.spines["bottom"].set_position(("data", 0))
    ax.spines["left"].set_position(("data", 0))
    ax.spines["bottom"].set_bounds(0, 1.62)
    ax.spines["left"].set_bounds(0, 1.10)
    ax.tick_params(length=3, labelsize=10)
    for extension in ["pdf", "svg"]:
        fig.savefig(OUT / f"gw_{name}.{extension}", metadata={"Creator": "EC442 lecture notes"})
    plt.close(fig)
