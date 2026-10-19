"""Three log-utility schematics for Lecture 6, slide 11; uncalibrated rates."""

from pathlib import Path

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 11,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-romer-equilibrium",
})

rho, alpha, r_entry, r_shift = 0.02, 0.9, 0.10, 0.18
r_planner = r_entry / alpha ** (1 / (1 - alpha))
returns = [r_entry, r_shift, r_planner]
growth = [(1 + r) / (1 + rho) - 1 for r in returns]
labels = ["Free entry", r"Higher $L$ or lower $\eta$", r"Social return ($r^*$)"]
r_ticks = [r"$\pi/\eta$", r"$r_1$", r"$r^*$"]
g_ticks = [r"$g_{\mathrm{eq}}$", r"$g_1$", r"$g^*$"]
g = np.linspace(0, 0.32, 300)

for stage, suffix in enumerate(["", "_scale_effect", "_planner"]):
    fig, ax = plt.subplots(figsize=(6.4, 3.6))
    fig.subplots_adjust(left=0.14, right=0.97, bottom=0.26, top=0.80)
    ax.plot(g, (1 + rho) * (1 + g) - 1, color="#0072B2", linewidth=1.8)
    ax.text(0.318, 0.357, r"Euler equation ($\sigma=1$)", color="#0072B2",
            ha="right", va="bottom")

    for i in range(stage + 1):
        color = "black" if i == stage else "0.5"
        ax.axhline(returns[i], color=color, linewidth=1.5,
                   linestyle="--" if i == 1 else "-")
        ax.vlines(growth[i], 0, returns[i], color="0.6", linewidth=0.9,
                  linestyles="--")
        ax.plot(growth[i], returns[i], "o", color=color, markersize=5)
        ax.text(0.008, returns[i] + 0.012, labels[i], color=color, va="bottom")

    ax.set(xlim=(0, 0.33), ylim=(0, 0.38),
           xticks=[0] + growth[:stage + 1],
           xticklabels=["0"] + g_ticks[:stage + 1],
           yticks=[rho] + returns[:stage + 1],
           yticklabels=[r"$\rho$"] + r_ticks[:stage + 1])
    ax.text(0, 1.08, "Net interest rate, $r$\n(per period)",
            transform=ax.transAxes, weight="bold", va="bottom")
    ax.text(1, -0.22, "Consumption growth, $g$\n(per period)",
            transform=ax.transAxes, weight="bold", ha="right", va="top")
    ax.spines[["top", "right"]].set_visible(False)
    ax.tick_params(length=3, pad=5)

    for extension in ["pdf", "svg"]:
        path = Path(__file__).with_name(f"romer_equilibrium{suffix}.{extension}")
        fig.savefig(path, metadata={"Creator": "EC442 lecture notes"})
    plt.close(fig)
