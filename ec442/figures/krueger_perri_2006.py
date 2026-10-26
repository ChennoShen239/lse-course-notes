"""Plot the Lecture 8 beta=0.5 example and its participation constraint."""

from pathlib import Path
import sys

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

beta = .5
peak = 1 - beta


def autarky(risk):
    return np.log1p(risk) + beta / (2 * (1 - beta)) * np.log1p(-risk**2)


def root(function, left, right):
    left_value = function(left)
    for _ in range(60):
        middle = (left + right) / 2
        value = function(middle)
        if left_value * value > 0:
            left, left_value = middle, value
        else:
            right = middle
    return (left + right) / 2


threshold = root(autarky, peak, 1 - 1e-12)
income_risk = np.unique(np.r_[np.linspace(0, .999, 700), peak, threshold])
consumption_risk = np.array([
    risk if risk <= peak else
    root(lambda x: autarky(x) - autarky(risk), 0, peak)
    if risk < threshold else 0
    for risk in income_risk
])
assert np.all((consumption_risk >= 0) & (consumption_risk <= income_risk))
assert np.all(autarky(consumption_risk) >= autarky(income_risk) - 1e-12)
assert abs(autarky(threshold)) < 1e-12

plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 10,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-krueger-perri-2006",
})

for name in (sys.argv[1:] or ("autarky", "risk", "mechanism")):
    fig, ax = plt.subplots(figsize=(6.2, 3.6))
    fig.subplots_adjust(left=.10, right=.96, bottom=.23, top=.77)
    if name == "autarky":
        ax.plot(income_risk, autarky(income_risk), color="#0072B2", linewidth=2)
        ax.axhline(0, color="#D55E00", linewidth=1.1)
        ax.vlines(peak, 0, autarky(peak), color=".5", linestyle="--", linewidth=.8)
        ax.text(.03, -.10, "Full insurance: $V_{FB}=0$", color="#D55E00")
        heading = "High-income exit value, $V_{aut}(\\epsilon)$\n(discounted log utility)"
        ax.set(ylim=(-.55, .34), yticks=[-.5, 0, .25])
    elif name == "risk":
        ax.plot(income_risk, consumption_risk, color="#0072B2", linewidth=2)
        ax.vlines(peak, 0, peak, color=".5", linestyle="--", linewidth=.8)
        ax.vlines(threshold, 0, .07, color=".5", linestyle="--", linewidth=.8)
        ax.text(.16, .32, "Autarky", ha="center")
        ax.text(.66, .49, "Partial insurance", ha="center")
        ax.text(.925, .14, "Full\ninsurance", ha="center")
        heading = "Consumption risk, $\\gamma(\\epsilon)$\n(goods units)"
        ax.set(ylim=(-.02, .55), yticks=[0, .25, .5])
    elif name == "mechanism":
        ax.plot(income_risk, autarky(income_risk), color=".25", linewidth=1.8)
        ax.axhline(0, color=".7", linewidth=.7)
        examples = []
        for risk, color, marker, linestyle in (
                (.6, "#0072B2", "o", "--"),
                (.8, "#D55E00", "s", "-.")):
            value = autarky(risk)
            gamma = root(lambda x: autarky(x) - value, 0, peak)
            assert abs(autarky(gamma) - value) < 1e-12
            examples.append((risk, gamma, value))
            ax.plot([gamma, risk], [value, value], color=color,
                    linestyle=linestyle, linewidth=1.2, marker=marker, markersize=5)
            ax.vlines([gamma, risk], 0, value, color=color, linewidth=.8, linestyle=":")
        (eps_a, gamma_a, value_a), (eps_b, gamma_b, value_b) = examples
        ax.annotate("", xy=(.50, value_b + .01), xytext=(.50, value_a - .012),
                    arrowprops={"arrowstyle": "->", "color": ".35", "lw": 1})
        ax.text(.53, .155, "Lower exit\nvalue", va="center", fontsize=9)
        for start, end in ((gamma_a, gamma_b), (eps_a, eps_b)):
            ax.annotate("", xy=(end, -.035), xytext=(start, -.035),
                        arrowprops={"arrowstyle": "->", "color": ".35", "lw": 1})
        heading = "High-income exit value, $V_{aut}(x)$\n(discounted log utility)"
        ax.set(ylim=(-.065, .32), yticks=[0, .1, .2, .3])
        print(f"epsilon {eps_a:.2f} -> gamma {gamma_a:.6f}; "
              f"epsilon {eps_b:.2f} -> gamma {gamma_b:.6f}")
    ax.text(0, 1.10, heading, transform=ax.transAxes, weight="bold", va="bottom")
    xlabel = ax.text(1, -.22, "Income risk, $\\epsilon$ (goods units)",
                     transform=ax.transAxes, weight="bold", ha="right", va="top")
    ax.set(xlim=(0, 1), xticks=[0, peak, threshold, 1],
           xticklabels=["0", r"$\epsilon^m=0.5$", r"$\bar\epsilon\approx0.839$", "1"])
    if name == "mechanism":
        xlabel.set_text("Risk spread, $x$ (goods units)")
        ax.set_xticks([0, gamma_b, gamma_a, eps_a, eps_b, 1],
                      ["0", "$\\gamma_B$\n" + f"{gamma_b:.3f}",
                       "$\\gamma_A$\n" + f"{gamma_a:.3f}",
                       "$\\epsilon_A$\n0.60", "$\\epsilon_B$\n0.80", "1"])
        xlabel.set_position((1, -.31))
    ax.spines[["top", "right"]].set_visible(False)
    ax.spines[["bottom", "left"]].set_color(".5")
    ax.tick_params(color=".5")
    output = Path(__file__).with_name("krueger_perri_" + name)
    for extension in ("pdf", "svg"):
        fig.savefig(output.with_suffix("." + extension),
                    metadata={"Creator": "EC442 lecture notes"})
    svg = output.with_suffix(".svg")
    svg.write_text("\n".join(line.rstrip() for line in svg.read_text().splitlines()) + "\n")
    plt.close(fig)

print(f"epsilon_m = {peak}; epsilon_bar = {threshold:.9f}")
print("All plotted allocations satisfy the participation constraint.")
