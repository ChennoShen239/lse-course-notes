"""Uncalibrated research-share experiment in a discrete-time Jones model."""

from pathlib import Path

import matplotlib
import numpy as np

matplotlib.use("Agg")
import matplotlib.pyplot as plt

plt.rcParams.update({
    "font.family": "DejaVu Serif",
    "font.size": 12,
    "mathtext.fontset": "dejavuserif",
    "pdf.fonttype": 42,
    "svg.fonttype": "path",
    "svg.hashsalt": "ec442-semi-endogenous-policy",
})

n, eta, phi = 0.02, 0.8, 0.5
share_before, share_after, policy_date = 0.05, 0.10, 40
g_bgp = (1 + n) ** (eta / (1 - phi)) - 1
chi = g_bgp / share_before ** eta
time = np.arange(301)
population = (1 + n) ** time
baseline = (1 + g_bgp) ** time
ideas = np.ones(len(time))
growth = np.empty(len(time) - 1)

for t in range(len(growth)):
    share = share_before if t < policy_date else share_after
    growth[t] = chi * (share * population[t]) ** eta * ideas[t] ** (phi - 1)
    ideas[t + 1] = ideas[t] * (1 + growth[t])

level_ratio = (share_after / share_before) ** (eta / (1 - phi))
blue = "#0072B2"
fig, axes = plt.subplots(1, 2, figsize=(8.4, 3.7))
fig.subplots_adjust(left=0.08, right=0.98, bottom=0.25, top=0.78, wspace=0.30)

axes[0].axhline(1, color="black", linestyle="--", linewidth=1.2)
axes[0].hlines(level_ratio, policy_date, 300, color="0.6", linestyle=":", linewidth=1)
axes[0].plot(time, ideas / baseline, color=blue, linewidth=1.8)
axes[0].text(295, 1.07, "Baseline", ha="right", va="bottom", fontsize=11)
axes[0].text(155, 2.35, "Higher research share", color=blue, fontsize=11)
axes[0].text(100, level_ratio + 0.07, "BGP level ratio", color="0.4", fontsize=11)
axes[0].set(ylim=(0.85, 3.35), yticks=[1, 2, 3])
axes[0].text(0, 1.08, "Stock of ideas, $A_t/A_t^{\\mathrm{base}}$\n(baseline = 1)",
             transform=axes[0].transAxes, weight="bold", va="bottom")

axes[1].axhline(100 * g_bgp, color="black", linestyle="--", linewidth=1.2)
axes[1].plot(time[:-1], 100 * growth, color=blue, linewidth=1.8)
axes[1].text(295, 2.98, "Baseline", ha="right", fontsize=11)
axes[1].text(90, 4.65, "Higher research share", color=blue, fontsize=11)
axes[1].set(ylim=(2.9, 6.1), yticks=[3, 4, 5, 6])
axes[1].text(0, 1.08, "Idea growth, $g_{A,t}$\n(% per period)",
             transform=axes[1].transAxes, weight="bold", va="bottom")

for ax in axes:
    ax.axvline(policy_date, color="0.65", linestyle=":", linewidth=0.9)
    ax.set(xlim=(0, 300), xticks=[0, 100, 200, 300])
    ax.text(1, -0.22, "Time, $t$\n(model periods)", transform=ax.transAxes,
            weight="bold", ha="right", va="top")
    ax.spines[["top", "right"]].set_visible(False)
    ax.tick_params(length=3, pad=5)

for extension in ["pdf", "svg"]:
    fig.savefig(Path(__file__).with_suffix(f".{extension}"),
                metadata={"Creator": "EC442 lecture notes"})
plt.close(fig)
