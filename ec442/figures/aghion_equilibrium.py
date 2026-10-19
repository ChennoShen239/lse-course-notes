"""Log-utility schematics for Lecture 6, slide 21; uncalibrated rates."""

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
    "svg.hashsalt": "ec442-aghion-equilibrium",
})

rho, gamma = 0.06, 2.0
entry_intercepts = [0.65, 0.85]
mu_eq = [(k - rho) / (1 + (1 + rho) * (gamma - 1))
         for k in entry_intercepts]
r_eq = [k - mu for k, mu in zip(entry_intercepts, mu_eq)]
mu = np.linspace(0, 0.60, 300)
mu_ticks = [r"$\mu_{\mathrm{eq}}$", r"$\mu_1$"]
r_ticks = [r"$r_{\mathrm{eq}}$", r"$r_1$"]

for stage, suffix in enumerate(["", "_scale_effect"]):
    fig, ax = plt.subplots(figsize=(6.4, 3.6))
    fig.subplots_adjust(left=0.14, right=0.97, bottom=0.26, top=0.80)
    ax.plot(mu, (1 + rho) * (1 + mu * (gamma - 1)) - 1,
            color="#0072B2", linewidth=1.8)
    ax.text(0.585, 0.725, r"Euler equation ($\sigma=1$)", color="#0072B2",
            ha="right", va="bottom")

    for i in range(stage + 1):
        color = "black" if i == stage else "0.5"
        ax.plot(mu, entry_intercepts[i] - mu, color=color, linewidth=1.5,
                linestyle="--" if i == 1 else "-")
        ax.vlines(mu_eq[i], 0, r_eq[i], color="0.65", linewidth=0.8,
                  linestyles="--")
        ax.hlines(r_eq[i], 0, mu_eq[i], color="0.65", linewidth=0.8,
                  linestyles="--")
        ax.plot(mu_eq[i], r_eq[i], "o", color=color, markersize=5)
        label = "Free entry" if i == 0 else r"Higher $L$ or $\lambda$"
        ax.text(0.018, entry_intercepts[i] - 0.008, label,
                color=color, va="bottom")

    ax.set(xlim=(0, 0.60), ylim=(0, 0.95),
           xticks=[0] + mu_eq[:stage + 1],
           xticklabels=["0"] + mu_ticks[:stage + 1],
           yticks=[rho] + r_eq[:stage + 1],
           yticklabels=[r"$\rho$"] + r_ticks[:stage + 1])
    ax.text(0, 1.08, "Net interest rate, $r$\n(per period)",
            transform=ax.transAxes, weight="bold", va="bottom")
    ax.text(1, -0.22, "Innovation probability, $\\mu$\n(per period)",
            transform=ax.transAxes, weight="bold", ha="right", va="top")
    ax.spines[["top", "right"]].set_visible(False)
    ax.tick_params(length=3, pad=5)

    for extension in ["pdf", "svg"]:
        path = Path(__file__).with_name(f"aghion_equilibrium{suffix}.{extension}")
        fig.savefig(path, metadata={"Creator": "EC442 lecture notes"})
    plt.close(fig)
