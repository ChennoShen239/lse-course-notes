"""Schematic borrowing limit and conditional Arrow pricing."""

from pathlib import Path

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 8.5,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-lecture9",
})

for name in ("borrowing_limit", "arrow_price"):
    fig, ax = plt.subplots(figsize=(3.35, 3.25))
    fig.subplots_adjust(left=.12, right=.96, bottom=.28, top=.76)
    ax.spines[["top", "right"]].set_visible(False)
    ax.spines[["bottom", "left"]].set_color(".5")
    ax.tick_params(color=".5", labelsize=8)

    if name == "borrowing_limit":
        bound = -.3
        assets = np.linspace(-1.1, 1.1, 300)
        gain = np.log1p((assets - bound) / 1.2)
        ax.plot(assets, gain, color="#0072B2", linewidth=2)
        ax.axhline(0, color=".6", linewidth=.8)
        ax.axvline(bound, color=".5", linestyle=":", linewidth=1)
        ax.plot(bound, 0, "o", color="#0072B2", markersize=4)
        ax.text(.04, .81, "Autarky\npreferred", transform=ax.transAxes,
                ha="left", va="top")
        ax.text(.60, .15, "Repayment\npreferred", transform=ax.transAxes,
                ha="center", va="center")
        ax.set(xlim=(-1.18, 1.18), ylim=(-1.2, .9),
               xticks=[bound], xticklabels=[r"$B_i(n)$"], yticks=[0])
        heading = "Repayment gain, $\\Delta V_i$\n(utility units; schematic)"
        xlabel = "Asset payoff, $a_i$\n(goods)"
    else:
        transfer = np.linspace(-.4, .4, 401)
        growth1, growth2 = 1 + transfer, 1 - transfer
        m1, m2 = 1 / growth1, 1 / growth2
        price = np.maximum(m1, m2)
        assert np.all(growth1 > 0) and np.all(growth2 > 0)
        assert np.allclose(price, 1 / (1 - np.abs(transfer)))
        ax.plot(transfer, m1, "--", color="#0072B2", linewidth=1.2)
        ax.plot(transfer, m2, "-.", color="#D55E00", linewidth=1.2)
        ax.plot(transfer, price, color=".15", linewidth=2)
        ax.plot(0, 1, "o", color=".15", markersize=3)
        ax.text(-.39, 1.83, "Type 1 prices", ha="left", va="top", fontsize=8)
        ax.text(.39, 1.83, "Type 2 prices", ha="right", va="top", fontsize=8)
        ax.text(.28, .88, r"$c_1/c'_{1j}$", color="#0072B2",
                ha="center", va="bottom")
        ax.text(-.28, .88, r"$c_2/c'_{2j}$", color="#D55E00",
                ha="center", va="bottom")
        ax.set(xlim=(-.44, .44), ylim=(.65, 1.9),
               xticks=[-.4, 0, .4], yticks=[1, 1.5])
        heading = "Arrow price, $q_j/(\\beta\\pi_j)$\n(normalized units; log utility)"
        xlabel = "Consumption transfer, $d$\n(goods, toward type 1)"

    ax.text(0, 1.14, heading, transform=ax.transAxes, weight="bold", va="bottom")
    ax.text(1, -.28, xlabel, transform=ax.transAxes,
            weight="bold", ha="right", va="top")
    output = Path(__file__).with_name(name)
    for extension in ("pdf", "svg"):
        fig.savefig(output.with_suffix("." + extension),
                    metadata={"Creator": "EC442 lecture notes"})
    svg = output.with_suffix(".svg")
    svg.write_text("\n".join(line.rstrip() for line in svg.read_text().splitlines()) + "\n")
    plt.close(fig)

print("Saved borrowing_limit and arrow_price as vector PDF and SVG.")
