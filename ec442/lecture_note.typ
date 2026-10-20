// Based on Chen Gao's book/course-note template:
// https://github.com/ChennoShen239/typst_templates/blob/main/note.typ
#import "@preview/ilm:1.4.1": *
#import "@preview/ctheorems:1.1.3": *

#show: thmrules.with(qed-symbol: $square$)
#show link: set text(fill: orange)
#show math.equation: set text(font: "Libertinus Math")
#set text(lang: "en", font: "Libertinus Serif")

#show: ilm.with(
  title: [EC442: Lecture Notes],
  author: "Chen Gao",
  date: datetime.today(),
  // Add abstract: [...] or preface: [...] here when needed.
  abstract: [Notes on LSE EC442: Macroeconomics.],
  bibliography: bibliography("refs.bib", style: "apa"),
  figure-index: (enabled: true),
  table-index: (enabled: true),
  listing-index: (enabled: true),
)

#let theorem = thmbox("theorem", "Theorem", fill: red.lighten(90%), base_level: 2)
#let proposition = thmbox("proposition", "Proposition", fill: blue.lighten(90%), base_level: 2)
#let corollary = thmplain(
  "corollary",
  "Corollary",
  titlefmt: strong,
  base: "theorem",
)
#let lemma = thmbox("lemma", "Lemma", fill: orange.lighten(90%), base_level: 2)
#let definition = thmbox("definition", "Definition", base_level: 2, fill: teal.lighten(80%))
#let example = thmbox("example", "Example", titlefmt: strong, fill: green.lighten(90%), base_level: 2)
#let proof = thmproof("proof", "Proof")
#let algorithm = thmbox("algorithm", "Algorithm", fill: blue.lighten(95%), base_level: 2)

// Number equations by lecture; each top-level heading starts a new lecture.
#show heading.where(level: 1): it => {
  if it.numbering != none {
    counter(math.equation).update(0)
  }
  it
}
#set math.equation(numbering: n => context {
  numbering("(1.1)", counter(heading).get().first(), n)
})
#show ref: it => context {
  set text(fill: blue)
  let target = it.element
  if target != none and target.func() == math.equation and it.form == "normal" {
    // Read both counters at the cited equation, not at the reference.
    let loc = target.location()
    let supplement = it.supplement
    if supplement == auto { supplement = target.supplement }
    if type(supplement) == function { supplement = supplement(target) }
    let prefix = if supplement == none or supplement == [] { [] } else { [#supplement~] }
    show link: set text(fill: blue)
    link(it.target, [#prefix#numbering(
        "(1.1)",
        counter(heading).at(loc).first(),
        counter(math.equation).at(loc).first(),
      )])
  } else {
    it
  }
}

// Yellow boxes identify recording supplements; equations stay unnumbered.
#let lecture-addition(title, source: none, body) = block(
  width: 100%,
  breakable: false,
  fill: rgb("#fff6cc"),
  stroke: (left: 1.5pt + rgb("#bc8736")),
  inset: (x: 10pt, y: 8pt),
  radius: 2pt,
  above: 0.65em,
  below: 0.65em,
)[
  #set par(justify: false)
  #set math.equation(numbering: none)
  #text(weight: "semibold", fill: rgb("#805719"))[Lecture addition: #title]

  #body

  #if source != none [
    #text(size: 8pt, fill: luma(40%))[Recording: #source]
  ]
]

= Lecture 1 Sep. 29

== Why heterogeneity
Complete competitive markets under the welfare-theorem assumptions:
- Equilibrium allocations are Pareto efficient. Consider an interior planner
  allocation with fixed welfare weights $alpha_i > 0$.
- Common discounting; preferences $u(c) - v(n)$. Consumption FOCs:
  $
    alpha_i u'(c_t^i) = alpha_j u'(c_t^j)
    =>
    frac(u'(c_t^i), u'(c_t^j)) = alpha_j / alpha_i.
  $
  *Marginal-utility ratio* constant across time/states.
- Common CRRA: $u'(c) = c^(-sigma)$.
  $
    c_t^i / c_t^j = (alpha_i / alpha_j)^(1 / sigma).
  $
  Fixed consumption shares $->$ *perfect insurance* against idiosyncratic income shocks.
  Aggregate risk remains; unequal Pareto weights $->$ unequal consumption.
- With strictly convex labor disutility and an interior choice, an
  idiosyncratic productivity increase raises labor supply, holding aggregate
  shadow prices fixed. The consumption share is unchanged.

// BEGIN lecture addition G1
#lecture-addition("Intuition for Complete Markets", source: "00:13:54, 00:16:04")[
  - *Example*: 18 students trade state-contingent claims before earnings risk
    is realized. Their incomes can differ while consumption shares remain fixed.
  - *Marx analogy*: "From each according to ability, to each according to needs." The planner equalizes weighted marginal utilities; individual income does not determine consumption.
  - *Empirical test*: With common preferences and fixed Pareto weights,
    idiosyncratic earnings shocks should not change consumption shares after
    controlling for aggregate conditions. Excess sensitivity motivates
    incomplete-market models.
]
// END lecture addition G1

== How to model incomplete markets?
+ *Exogenous*: assume some markets absent.
  + e.g. save/borrow via noncontingent bonds; no state-contingent claims.
+ *Endogenous*: derive market incompleteness from frictions.
  + e.g. limited commitment (participation constraints), private information.
  + deeper but harder to do

// BEGIN lecture addition G4
#lecture-addition("Course Roadmap", source: "00:31:25, 00:33:02")[
  - *Methods*: Dynamic programming, numerical methods.
  - *Background*: Equilibrium and welfare theorems.
  - *Growth*: Basic models of economic growth.
  - *Incomplete markets*: Endogenous (participation constraints/limited commitment), exogenous (asset structure), search models.
]
// END lecture addition G4

// BEGIN lecture addition G6
#lecture-addition("Frictions for Endogenous Incompleteness", source: "00:22:10, 00:27:38")[
  - *Limited commitment*: Contracts unenforceable. E.g., US car insurance limits; agents flee jurisdiction (e.g., to Frankfurt) to avoid liability $->$ limits risk trading.
  - *Private information*: Effort/talent unobservable. Income sharing $->$ moral hazard (effort reduction) $->$ complete insurance inefficient/impossible.
]
// END lecture addition G6

== Planning problem
Set $n_t = A = 1$; $f(k) = F(k, 1)$. Given $k_0 >= 0$.
Discount factor $0 < beta < 1$; depreciation $0 <= delta <= 1$.

Choose sequences $c_t, k_(t+1) >= 0$:
$
  max sum_(t=0)^infinity beta^t u(c_t)
  "s.t."
  c_t + k_(t+1) = f(k_t) + (1 - delta) k_t.
$

- *Lagrangian*; current-value multipliers $lambda_t$:
  $
    cal(L) = sum_(t=0)^infinity beta^t
    [u(c_t) + lambda_t (f(k_t) + (1 - delta) k_t - c_t - k_(t+1))].
  $
- *Interior FOCs*:
  $
        c_t: & u'(c_t) = lambda_t, \
    k_(t+1): & lambda_t = beta lambda_(t+1)
               [f'(k_(t+1)) + 1 - delta].
  $
  Euler equation:
  $
    u'(c_t) = beta u'(c_(t+1)) [f'(k_(t+1)) + 1 - delta].
  $
- *Transversality condition*:
  $
    lim_(T -> infinity) beta^T lambda_T k_(T+1)
    = lim_(T -> infinity) beta^T u'(c_T) k_(T+1) = 0.
  $
  Discounted shadow value of terminal capital $->$ 0.
- Increasing, concave $u$; concave $f$; finite discounted utility:
  feasibility + FOCs + TVC $->$ global optimum. At corners, use KKT conditions.

== Towards a recursive formulation
- Sequence approach: infinitely many dated choices + optimality conditions.
- Repeated trade-off: consume today vs. save for tomorrow.
- Stationary problem; current capital $k_t$ summarizes relevant history.
- Recursion: continuation value summarizes future choices; same decision
  problem at every date.

*Value function*: maximal lifetime utility from initial capital $k_0$:
$
  v^*(k_0) = max_({c_t, k_(t+1)}_(t>=0))
  sum_(t=0)^infinity beta^t u(c_t).
$
Feasible sequences: $c_t, k_(t+1) >= 0$;
$c_t + k_(t+1) = f(k_t) + (1 - delta) k_t$, all $t >= 0$.

*Split date 0 from continuation*:
$
  v^*(k_0) = max_(c_0, k_1) [u(c_0) + beta
    max_({c_t, k_(t+1)}_(t>=1))
    sum_(t=1)^infinity beta^(t-1) u(c_t)].
$
- Outer max: $c_0, k_1 >= 0$;
  $c_0 + k_1 = f(k_0) + (1 - delta) k_0$.
- Inner max: given chosen $k_1$, same feasibility constraints for all $t >= 1$.
  Discounting restarts at date 1 $->$ inner value $v^*(k_1)$.

Continuation value absorbs future choices. *Bellman equation*
(current capital $k$, next-period capital $k'$):
$
  v^*(k) = max_(c, k') [u(c) + beta v^*(k')]
$
subject to
$
  c + k' = f(k) + (1 - delta) k,
  c, k' >= 0.
$
Infinite sequence $->$ one-period choice + discounted continuation value.
Stationarity $->$ same problem at every date.

Bellman equation = *functional equation*; unknown = function $v(k)$.

Questions:
- *Existence*: conditions for solution $v$?
- *Uniqueness*: conditions for unique $v$ within chosen function class?
- *Equivalence*: when does $v = v^*$, with maximizing policy solving
  original sequence problem?
Answer:
- _Recursive Macroeconomic Theory_ (RMT), “Dynamic Programming”
  @ljungqvist2018rmt[ch. 3].

// BEGIN lecture addition G2
#lecture-addition("Computational Advantage of DP", source: "01:06:37, 01:07:39")[
  - *Lagrangian*: Euler conditions give a difference equation. Shooting starts
    from a guessed initial control and checks the terminal condition.
  - *Recursive*: Bellman eq. $->$ direct computation of *global solution* via iteration.
  - *Convergence*: Under the contraction assumptions, VFI converges to a unique
    fixed point. A numerical discretization still introduces approximation error.
]
// END lecture addition G2

== Dynamic programming
*Bellman operator* $T$: candidate continuation value $v$ $->$ updated value $T v$.
$
  (T v)(k) = max_(c, k') [u(c) + beta v(k')]
$
subject to
$
  c + k' = f(k) + (1 - delta) k,
  c, k' >= 0.
$

Bellman solution = *fixed point*:
$
  T v = v <=> (T v)(k) = v(k) " for all feasible " k.
$
Fixed-point theorems give existence/uniqueness conditions within chosen
function space; assumptions matter.

== Contraction mapping theorem
#theorem("Contraction mapping theorem")[
  Let $(S, d)$ be a nonempty complete metric space and $T: S -> S$ a
  contraction: there exists $beta in (0, 1)$ such that
  $
    d(T x, T y) <= beta d(x, y)
    "for all " x, y in S.
  $
  Then $T$ has a unique fixed point $v in S$. For every $v_0 in S$ and
  $n = 0, 1, 2, dots$,
  $
    d(T^n v_0, v) <= beta^n d(v_0, v).
  $
  Hence $T^n v_0 -> v$ as $n -> infinity$, with geometric convergence.
  Here $T^n$ denotes $n$ successive applications of $T$, with $T^0$ the identity.
] <thm:cmt>

// BEGIN lecture addition G5
#lecture-addition("Intuition for Contraction Mapping", source: "00:59:06, 01:01:46")[
  - On a compact interval, $abs(g'(x)) <= beta < 1$ makes $g$ a contraction,
    provided it maps the interval into itself. Brouwer gives existence for a
    continuous self-map; contraction also gives uniqueness and convergence.
  - In function spaces, "slope" = contraction factor $beta$. Iterating operator moves points closer $->$ convergence to unique fixed point.
]
// END lecture addition G5

=== Application to planner
- Assume feasible capital remains in nonempty compact interval $K$.
- $S = C(K)$: continuous real-valued functions on $K$; automatically bounded.
- *Sup-norm metric*:
  $
    d(v, w) = norm(v - w)_infinity
    = sup_(k in K) abs(v(k) - w(k)).
  $
  $(S, d)$ complete.
- Must verify $T: S -> S$: updated values remain bounded and continuous.
  Then Bellman discounting gives
  $
    norm(T v - T w)_infinity <= beta norm(v - w)_infinity.
  $
  @thm:cmt $->$ unique fixed point in $S$; value iteration converges from any $v_0 in S$.

// BEGIN lecture addition G3
#lecture-addition("Economic Interpretation of VFI", source: "00:56:48, 00:58:31")[
  - $v^(0) = 0$ is a zero terminal payoff.
  - $T v^(0)$ solves a one-period problem: consume all current resources.
  - $T^2 v^(0)$ solves a two-period problem. Each application of $T$ adds
    one period; $T^n 0$ is the $n$-period value with zero terminal utility.
]
// END lecture addition G3

== Using the value function analytically
Assume $u$, $f$, and $v$ differentiable; optimal choices interior.
Substitute $c = f(k) + (1 - delta) k - k'$ into Bellman:
$
  v(k) = max_(k') [u(f(k) + (1 - delta) k - k') + beta v(k')],
$
over feasible $k'$.

- *FOC for $k'$*:
  $
    -u'(c) + beta v'(k') = 0
    => u'(c) = beta v'(k').
  $
- *Envelope condition*: differentiate w.r.t. $k$, holding optimal $k'$ fixed:
  $
    v'(k) = u'(c) [f'(k) + 1 - delta].
  $
- *Combine*: apply envelope condition next period $->$ usual Euler equation:
  $
    u'(c_t) = beta v'(k_(t+1))
    = beta u'(c_(t+1)) [f'(k_(t+1)) + 1 - delta].
  $
  Same condition as sequence problem. At corners, use KKT conditions.

== Using the value function numerically
Need numerical representation of $v(k)$.
- Simplest approach: restrict capital to finite grid
  $
    K_N = {k^1, k^2, dots, k^N} subset K.
  $
- Approximate value function by vector
  $
    bold(v) = (v_1, v_2, dots, v_N)^top in RR^N,
    v_i approx v(k^i).
  $
  One entry per capital grid point.

#algorithm("Value function iteration (VFI)")[
  + *Choose grid* $K_N = {k^1, dots, k^N}$. For each pair $(i, j)$, compute
    $
      c_(i j) = f(k^i) + (1 - delta) k^i - k^j.
    $
    Let $J_i$ contain choices $j$ with $c_(i j) >= 0$ and finite $u(c_(i j))$.
    Each $J_i$ must be nonempty.
  + *Initial guess*: any $bold(v)^(0) in RR^N$, e.g. all zeros.
    Set iteration $m = 0$ and tolerance $epsilon > 0$.
  + *Bellman update*: for every $i = 1, dots, N$,
    $
      v_i^(m+1) = max_(j in J_i) [u(c_(i j)) + beta v_j^(m)].
    $
    Use the old vector for all updates: $bold(v)^(m+1) = T_N bold(v)^(m)$.
  + *Convergence check*:
    $
      Delta_m = max_(1 <= i <= N) abs(v_i^(m+1) - v_i^(m)).
    $
    If $Delta_m <= epsilon$, stop and return $hat(bold(v)) = bold(v)^(m+1)$.
    Otherwise set $m <- m + 1$ and repeat step 3.
  + *Recover approximate policy*: for each $i$, choose
    $
      j_i in arg max_(j in J_i) [u(c_(i j)) + beta hat(v)_j].
    $
    Set $k'(k^i) = k^(j_i)$ and $c(k^i) = c_(i j_i)$.
] <alg:vfi>

*Why it converges*: $T_N$ is a $beta$-contraction in the sup norm.
@thm:cmt $->$ unique grid fixed point $bold(v)_N^*$;
@alg:vfi converges from any initial vector.
At stopping, value-error bound:
$
  norm(hat(bold(v)) - bold(v)_N^*)_infinity
  <= frac(beta, 1 - beta) Delta_m
  <= frac(beta, 1 - beta) epsilon.
$
This controls iteration error; grid approximation error remains.

// BEGIN lecture addition G7
#lecture-addition("Convergence in General Equilibrium", source: "01:14:16, 01:15:18")[
  - Under its assumptions, CMT guarantees convergence of individual value functions.
  - Heterogeneous GE: convergence of *distribution* of states (assets, income, human capital) required.
  - Distribution = higher-dimensional object; may have multiple fixed points $->$ more complex than single-agent VFI.
]
// END lecture addition G7

// BEGIN lecture addition G8
#lecture-addition("Curse of Dimensionality", source: "01:15:51, 01:16:53")[
  - Grid-based VFI suffers from *curse of dimensionality*: $n$ state variables $->$ $M^n$ grid points (exponential growth).
  - Large $n$ (e.g., 50) $->$ computationally intractable.
  - Sparse grids reduce the number of nodes. Mean field methods couple
    individual decisions with distribution dynamics; equilibrium convergence
    still requires its own argument.
]
// END lecture addition G8

// BEGIN lecture addition G9
#lecture-addition("Complexity vs. Reality", source: "01:17:25, 01:19:00")[
  - Model complexity driven by *expectation side*: agents anticipate others' actions $->$ complex fixed-point problems.
  - Evidence: real people not "fully forward-looking" as standard models assume.
  - *Responses*: (1) Develop computational tools for complex models; (2) Simplify models to match cognitive complexity (behavioral/limited rationality).
]
// END lecture addition G9

= Lecture 2 Oct 5

== Recall

=== Bellman equation for the standard growth model

$
  v(k) = max_(c, k') [u(c) + beta v(k')],
  u(c) = c^(1 - sigma) / (1 - sigma),
$
subject to
$
  c + k' = (1 - delta) k + k^alpha,
  c > 0, k' >= 0.
$
For $sigma = 1$, use $u(c) = log c$.

=== Contraction mapping theorem

On a nonempty complete metric space $(S, d)$, a contraction $T: S -> S$
with modulus $beta in (0, 1)$ has a unique fixed point $v$ (@thm:cmt):
$
  d(T x, T y) <= beta d(x, y), \
  d(T^n v_0, v) <= beta^n d(v_0, v).
$
Iteration from any $v_0 in S$ converges geometrically to $v$.

== Blackwell's sufficient conditions

#theorem("Blackwell's sufficient conditions")[
  Let $B(X)$ be the bounded real-valued functions on $X$, equipped with
  the sup norm, and let $T: B(X) -> B(X)$. Suppose:

  + *Monotonicity*: For all $f, g in B(X)$,
    $
      f(x) >= g(x) " for all " x in X
      ==> (T f)(x) >= (T g)(x) " for all " x in X.
    $
  + *Discounting*: There exists $beta in (0, 1)$ such that, for every
    $f in B(X)$ and $a >= 0$,
    $
      (T(f + a))(x) <= (T f)(x) + beta a
      "for all " x in X.
    $
    Here $(f + a)(x) = f(x) + a$.

  Then $T$ is a contraction with modulus $beta$:
  $
    norm(T f - T g)_infinity <= beta norm(f - g)_infinity.
  $
] <thm:blackwell>

=== Verification for the Bellman operator

Maximization preserves pointwise inequalities, so $f >= g ==> T f >= T g$.
Adding a constant to continuation utility gives
$
  (T(f + a))(k)
  = max_(c, k') [u(c) + beta f(k')] + beta a
  = (T f)(k) + beta a.
$
Both conditions hold; the self-map requirement $T: B(X) -> B(X)$
must also be verified.

== Blackwell's conditions for the standard model

Let $alpha, delta, beta in (0, 1)$. Resources and consumption:
$
      y(k) & = underbrace((1 - delta) k, "remaining capital")
             + underbrace(k^alpha, "output"), \
  c(k, k') & = y(k) - k'.
$
The invariant state space satisfies
$
  overline(k) & = delta^(-1 / (1 - alpha)), \
            X & = [0, overline(k)], \
    0 <= y(k) & <= y(overline(k)) = overline(k)
                "for all " k in X.
$

// BEGIN lecture addition G10
#lecture-addition("The capital ceiling", source: "00:07:02 - 00:07:39")[
  $overline(k)$ is the steady state with zero consumption: all output goes
  into investment, and $overline(k)^alpha = delta overline(k)$.
  The bound comes from feasibility alone. Starting in $X$, feasible savings
  remain in $X$.
]
// END lecture addition G10

Feasible savings and the Bellman operator:
$
  Gamma(k) & = {k' >= 0 : c(k, k') >= 0} subset.eq X, \
  (T f)(k) & = sup_(k' in Gamma(k))
             [underbrace(u(c(k, k')), "current utility")
               + beta underbrace(f(k'), "continuation value")].
$
Extend $u$ to $c = 0$ by its limit, possibly $-infinity$.
Replace $sup$ with $max$ when the optimum is attained.

=== Monotonicity

For $f, g in B(X)$ with $f >= g$ pointwise,
$
  (T f)(k) & = sup_(k' in Gamma(k)) [u(c(k, k')) + beta f(k')] \
           & >= sup_(k' in Gamma(k)) [u(c(k, k')) + beta g(k')] \
           & = (T g)(k).
$

// BEGIN lecture addition G11
#lecture-addition("Why the first inequality can be strict", source: "00:08:00 - 00:10:59")[
  If the maximum for $g$ is attained, let $k^star (k)$ be its optimal savings:
  $
    (T f)(k) & >= u(c(k, k^star (k))) + beta f(k^star (k)), \
             & >= u(c(k, k^star (k))) + beta g(k^star (k)), \
             & = (T g)(k).
  $
  The first step evaluates one feasible choice. It can be strict because
  $k^star (k)$ need not maximize the objective with continuation value $f$.
]
// END lecture addition G11

=== Discounting

For $f in B(X)$ and a constant $a >= 0$,
$
  (T(f + a))(k) & = sup_(k' in Gamma(k))
                  [u(c(k, k')) + beta f(k') + underbrace(beta a, "constant in " k')] \
                & = (T f)(k) + beta a.
$

=== Boundedness and conclusion

For $0 < sigma < 1$, $u(0) = 0$ and
$
    0 <= u(c(k, k')) & <= u(overline(k)) < infinity, \
  norm(T f)_infinity & <= u(overline(k)) + beta norm(f)_infinity < infinity.
$
Thus $T: B(X) -> B(X)$ on the complete sup-norm space $B(X)$.
By @thm:blackwell and @thm:cmt,
there is a unique $v in B(X)$ with $T v = v$, and for every $v_0 in B(X)$,
$
  norm(T^n v_0 - v)_infinity
  <= beta^n norm(v_0 - v)_infinity -> 0.
$

For $sigma >= 1$ (including log utility),
$
  k = 0 ==> Gamma(k) = {0} ==> (T f)(0) = -infinity.
$
The bounded-function theorem then requires a different state or function space.

== Formulating recursive models

Identify the state variables before writing the Bellman equation.

A *state variable*:
- Matters for the decision problem.
- Is taken as given by the decision maker at the time of choice.
- Varies over time or across states.

Other variables:
- *Choice variables*: chosen by the decision maker.
- *Parameters*: affect the problem but are fixed over time and across states.

The value function takes the state variables as its arguments.

// BEGIN lecture addition G12
#lecture-addition("A past choice can be a current state", source: "00:16:22 - 00:18:54")[
  The household chose today's capital in the past; it is fixed when today's
  consumption-saving decision is made. Models with habits or varying patience
  may require preference states. Here $beta$ and $sigma$ remain parameters
  because they are fixed.
]
// END lecture addition G12

=== How to determine the state

+ *Fix timing*: Specify what is observed before choices are made.
  A lagged choice may be today's state; a newly chosen quantity is a control.
+ *List candidates*: Retain inherited stocks and observed shocks that affect
  current constraints, utility, or forecasts. Separate fixed parameters.
+ *Check sufficiency*: Given state $s$ and choices $q$, specify
  $
                    q & in Gamma(s), \
    "current utility" & = U(s, q), \
                   s' & = G(s, q, epsilon').
  $
  Here $epsilon'$ is future uncertainty. Two histories with the same $s$
  must give the same feasible choices, current utility, and conditional
  distribution of $s'$ for every feasible $q$.
+ *Remove redundancy*: Drop a coordinate only if this sufficiency test
  still holds. A one-to-one change of coordinates gives an equivalent state.
+ *Write the Bellman equation*:
  $
    v(s) = sup_(q in Gamma(s))
    [underbrace(U(s, q), "current utility")
      + beta underbrace(bb(E)[v(s') | s, q], "expected continuation")].
  $
  Use $max$ when the optimum is attained; omit the expectation in a
  deterministic model.

*Reduction test*: If two candidate states have the same proposed summary
but different feasible choices, utility, or transition distributions,
the summary is insufficient.

=== Example: standard model with two sectors

Each period, allocate inherited capital $k$ and one unit of labor freely
between consumption ($c$) and investment ($i$) sectors.
Let $alpha, gamma in (0, 1)$.

Feasibility:
$
          c & = underbrace(k_c^alpha n_c^(1 - alpha), "consumption output"), \
         k' & = underbrace((1 - delta) k, "remaining capital")
              + underbrace(k_i^gamma n_i^(1 - gamma), "investment output"), \
  k_c + k_i & = k, \
  n_c + n_i & = 1.
$
All quantities are nonnegative.

*State identification*:
- $k$ is inherited; $(k_c, k_i, n_c, n_i)$ are chosen before production.
- Free reallocation removes dependence on the previous sectoral split.
- Given $k$ and current choices, utility and next-period $k'$ are determined.

Hence $s = k$ is sufficient.

The Bellman equation is
$
  v(k) = max_(c, k', k_c, k_i, n_c, n_i)
  [u(c) + beta v(k')],
$
subject to the constraints above, with $u$ as defined in Recall.

// BEGIN lecture addition G13
#lecture-addition("Timing and the sectoral split", source: "00:24:30 - 00:30:44")[
  Let $tilde(v)(k_c, k_i)$ be the value after capital has been allocated across
  sectors. Before allocation,
  $
    v(k) = max_(k_c + k_i = k) tilde(v)(k_c, k_i).
  $
  In this deterministic model, the future split can be planned a period
  earlier. Treating the initial allocation consistently gives the same
  choices. With $M$ grid points per state, retaining both stocks requires
  $M^2$ combinations; retaining total capital requires $M$.
]
// END lecture addition G13

=== Example: two sectors with irreversible investment

Capital is installed before the period and cannot move between sectors.
Choose labor allocations and new investment $x_c, x_i$ today;
investment becomes productive next period.

Feasibility:
$
          c & = k_c^alpha n_c^(1 - alpha), \
  x_c + x_i & = underbrace(k_i^gamma n_i^(1 - gamma), "investment output"), \
       k'_c & = (1 - delta) k_c + x_c, \
       k'_i & = (1 - delta) k_i + x_i, \
  n_c + n_i & = 1, \
   x_c, x_i & >= 0.
$
All other quantities are nonnegative. Irreversibility implies
$
  k'_j >= (1 - delta) k_j
  "for " j in {c, i}.
$
Sectoral capital can decline only through depreciation.

*State:* $(k_c, k_i)$. Two economies with the same total capital but
opposite sectoral splits face different current production possibilities
and different bounds on tomorrow's stocks. Total capital alone is insufficient.
Current labor and investment allocations are controls.

The Bellman equation is
$
  v(k_c, k_i) = max_(c, n_c, n_i, x_c, x_i)
  {u(c) + beta v((1 - delta) k_c + x_c, (1 - delta) k_i + x_i)},
$
subject to the feasibility constraints above.

// BEGIN lecture addition G14
#lecture-addition("Why the aggregate equation is insufficient", source: "00:32:20 - 00:34:45")[
  The state is $(k_c, k_i)$. Adding the accumulation equations leaves the
  separate restrictions $x_c, x_i >= 0$ in place. Dropping them would permit
  conversion of existing capital between sectors. They can bind when initial
  stocks are imbalanced or shocks change the desired sectoral mix.
]
// END lecture addition G14

// BEGIN lecture addition G15
#lecture-addition("Applications of multisector models", source: "00:20:42 - 00:20:53; 00:35:00 - 00:36:15")[
  Separate consumption and investment sectors allow general and
  investment-specific technological change to have different effects on
  business cycles. Larger models use input-output networks, with sectors
  buying CES aggregates of intermediate inputs, to study shock propagation.
]
// END lecture addition G15

=== Standard model with shocks

Productivity $z$ is i.i.d. over time. The resource constraint is
$
  c + k' = (1 - delta) k + z k^alpha.
$ <eq:shock-resources>
In all formulations, $c, k' >= 0$.

==== States $(k, z)$: after the shock

Observe $z$, then choose $c$ and $k'$:
$
  v(k, z) = max_(c, k')
  [u(c) + beta bb(E)_(z')[v(k', z')]],
$
subject to @eq:shock-resources. The expectation is over next period's shock $z'$.

==== State $x$: total resources

After observing $z$, define
$
  x = (1 - delta) k + z k^alpha.
$
Then
$
  w(x) = max_(c, k')
  [u(c) + beta bb(E)_(z')[w(x')]],
$
subject to
$
  c + k' & = x, \
      x' & = (1 - delta) k' + z' (k')^alpha.
$
$z'$ is independent of $z$, so the transition of $x'$ requires only $k'$.

#text(fill: red)[Note: This reduction to $x$ relies on $z$ being i.i.d. over time.]

// BEGIN lecture addition G16
#lecture-addition("The forecast matters with persistent shocks", source: "00:45:42 - 00:46:22")[
  Two states can have the same current resources $x$ but different productivity
  $z$. With persistence, their distributions of $z'$ differ, so their optimal
  savings can differ. Current $z$ carries information about tomorrow.
]
// END lecture addition G16

==== State $k$: before the shock

$V(k)$ is the value _before $z$ is observed._ Choices $c(z)$ and $k'(z)$
may _depend on its realization:_

*Choices.* _For a fixed $(k, z)$ or $x$, Options 1 and 2 maximize over scalar choices
$c,k'$. Their policy functions are $c(k,z),k'(k,z)$ or $c(x),k'(x)$;
state arguments are implicit. Option 3 maximizes over functions
$c(z),k'(z)$ for every possible $z$._

$
  V(k) = max_(c(z), k'(z))
  bb(E)_z [u(c(z)) + beta V(k'(z))],
$
subject to
$
  c(z) + k'(z) = (1 - delta) k + z k^alpha
  "for every " z.
$
$
  v(k, z) & = w((1 - delta) k + z k^alpha), \
     V(k) & = bb(E)_z [v(k, z)].
$

*Timing.*  Before observing $z$, $V(k)$ averages over its realization; i.i.d. shocks
make past productivity uninformative about $z$. After observing $z$, the
state records realized resources through $(k,z)$ or $x$. Decisions can
depend on observed $z$ in all three formulations.

// BEGIN lecture addition G17
#lecture-addition("Several values within one period", source: "00:51:25 - 00:52:16")[
  A model can use value functions at several stages of a period. A value
  before information arrives is linked to the later value by an expectation
  over the information revealed between those stages.
]
// END lecture addition G17

== Equilibrium

A social planner maximizes welfare subject to feasibility constraints.
In a decentralized economy, agents make their own choices, linked through
markets, institutions, and policies.

- How can decentralized outcomes be represented formally?
- How do equilibrium allocations relate to the planner's solution?
- Can decentralized equilibria be formulated recursively?

== What is a competitive equilibrium?

A competitive equilibrium consists of:
- An _allocation_: consumption, production, and factor inputs.
- A _price system_: prices in every market.

Two conditions:
- *Optimization*: households maximize utility within their budgets; firms
  maximize profits. Both take prices as given. Household wealth includes
  endowments and ownership shares of firm profits.
- *Market clearing*: demand equals endowments plus net production for every
  good. With free disposal, excess supply is permitted only at a zero price.

// BEGIN lecture addition G18
#lecture-addition("Trading dates and events", source: "01:02:26 - 01:03:56")[
  With complete markets, goods are distinguished by delivery date and event.
  The lecture's example is consumption in 2027 conditional on no rain in
  Australia. Suitable sequential asset markets can span the same contingent
  consumption trades as markets opened once at date 0.
]
// END lecture addition G18

== Sequential equilibrium

In the deterministic standard model, markets open each period.
The household owns capital $k_t$ and a fixed labor endowment $n_t = 1$.
It rents capital and supplies labor to the firm; both agents take prices as given.
Let $r_t$ be the net return on capital. The capital rental rate is
$r_t + delta$; the wage is $w_t$.

Given $k_0$, a sequential equilibrium consists of an allocation
$lr({c_t, n_t, k_(t+1)})_(t=0)^infinity$ and prices
$lr({r_t, w_t})_(t=0)^infinity$ satisfying the following conditions.

=== Household

Given the price paths, the household solves
$
  max_({c_t, k_(t+1)}_(t=0)^infinity)
  sum_(t=0)^infinity beta^t u(c_t),
$
subject to
$
  c_t + k_(t+1) & = underbrace((1 + r_t) k_t, "capital payoff")
                  + underbrace(w_t n_t, "labor income"), \
            n_t & = 1, \
            c_t & >= 0, \
        k_(t+1) & >= 0.
$

=== Firm

The firm chooses capital demand $K_t$ and labor demand $N_t$ each period:
$
  max_(K_t, N_t >= 0)
  [K_t^alpha N_t^(1 - alpha) - (r_t + delta) K_t - w_t N_t].
$

// BEGIN lecture addition G19
#lecture-addition("Representative agents and price taking", source: "01:06:36 - 01:08:06; 01:12:24 - 01:13:53")[
  The representative firm behaves as an atomistic price taker. Its labor
  demand $N_t$ is a choice; $N_t = 1$ is imposed through market clearing.
  Representative notation can stand for a continuum of identical agents.
  Separate demand and supply symbols make this distinction explicit.
]
// END lecture addition G19

=== Market clearing

$
            K_t & = k_t, \
            N_t & = n_t = 1, \
  c_t + k_(t+1) & = (1 - delta) k_t + k_t^alpha.
$
At positive inputs, the firm's first-order conditions imply
$
  r_t & = alpha k_t^(alpha - 1) - delta, \
  w_t & = (1 - alpha) k_t^alpha.
$

// BEGIN lecture addition G20
#lecture-addition("Depreciation and the quoted return", source: "01:10:41 - 01:11:28; 01:14:52 - 01:16:21")[
  An alternative convention quotes the capital rental rate
  $rho_t = r_t + delta$ and lets the household bear depreciation. Then
  $
          c_t + k_(t+1) & = (1 - delta + rho_t) k_t + w_t n_t, \
    "firm capital cost" & = rho_t K_t.
  $
  The net-return and rental-rate conventions describe the same payments.
]
// END lecture addition G20

=== No-Ponzi condition

If borrowing is allowed, replace $k_(t+1) >= 0$ with
$
  liminf_(t -> infinity)
  frac(k_(t+1), product_(s=1)^t (1 + r_s)) >= 0.
$
At an interior optimum with $u'(c_s) > 0$, the Euler equation gives
$
  1 + r_s = frac(u'(c_(s-1)), beta u'(c_s)).
$
Multiplying from $s = 1$ to $t$, marginal utilities cancel:
$
  product_(s=1)^t (1 + r_s) & = product_(s=1)^t frac(u'(c_(s-1)), beta u'(c_s)), \
                            & = frac(u'(c_0), beta^t u'(c_t)).
$
Hence
$
  frac(k_(t+1), product_(s=1)^t (1 + r_s))
  = frac(beta^t u'(c_t) k_(t+1), u'(c_0)).
$
Since $u'(c_0) > 0$ is constant, dividing by it preserves the sign
of the limit inferior. Thus the no-Ponzi condition is equivalent to
$
  liminf_(t -> infinity) beta^t u'(c_t) k_(t+1) >= 0.
$
The household cannot finance consumption by rolling over debt forever.

// BEGIN lecture addition G21
#lecture-addition("Physical capital and financial assets", source: "01:16:28 - 01:17:20; 01:18:29 - 01:19:47")[
  Physical capital is nonnegative. An individual's financial asset position
  can be negative when borrowing is allowed for consumption smoothing.
  Period budgets alone permit arbitrarily large debt followed by refinancing
  of principal and interest. A borrowing limit or no-Ponzi condition restricts
  those plans.
]
// END lecture addition G21

== Arrow-Debreu equilibrium

Sequential markets open each period. In an Arrow-Debreu equilibrium, markets
open once at date 0. Agents contract for goods delivered at each future date
(and state, under uncertainty). Delivery and production still occur each period.

Given $k_0$, an Arrow-Debreu equilibrium consists of an allocation
$lr({c_t, n_t, k_(t+1)})_(t=0)^infinity$ and prices
$lr({p_t, r_t, w_t})_(t=0)^infinity$ satisfying the conditions below.

#text(fill: red)[
  The additional price $p_t > 0$ is the date-0 price of one unit of the good
  delivered at date $t$, with $p_0 = 1$. It converts date-$t$ quantities into
  date-0 goods.
]

The wage $w_t$ and capital rental rate $r_t + delta$ remain measured in
date-$t$ goods. Their date-0 prices are $p_t w_t$ and $p_t (r_t + delta)$.

=== Household

The household solves
$
  max_({c_t, k_(t+1)}_(t=0)^infinity)
  sum_(t=0)^infinity beta^t u(c_t),
$
subject to $n_t = 1$, $c_t >= 0$, $k_(t+1) >= 0$, given $k_0$,
and a single present-value budget:
$
  sum_(t=0)^infinity p_t (c_t + k_(t+1))
  = sum_(t=0)^infinity p_t [(1 + r_t) k_t + w_t n_t].
$
The present-value sums are assumed finite.

=== Firm and market clearing

For each delivery date $t$, the firm solves
$
  max_(K_t, N_t >= 0)
  [K_t^alpha N_t^(1 - alpha) - (r_t + delta) K_t - w_t N_t].
$
Multiplying profits by $p_t > 0$ leaves the input choices unchanged.
Markets clear at every date:
$
            K_t & = k_t, \
            N_t & = n_t = 1, \
  c_t + k_(t+1) & = (1 - delta) k_t + k_t^alpha.
$

=== No arbitrage and the present-value budget

#definition("No arbitrage in capital")[
  In this deterministic Arrow-Debreu economy, one unit of $k_(t+1)$ costs
  $p_t$ at date 0 and pays $p_(t+1) (1 + r_(t+1))$ in date-0 goods.
  At positive capital holdings, no arbitrage requires
  $
    p_t - p_(t+1) (1 + r_(t+1)) & = 0, \
             frac(p_t, p_(t+1)) & = 1 + r_(t+1).
  $
]
Thus $p_t / p_(t+1)$ is the gross real return from $t$ to $t+1$.

// BEGIN recording additions 2026-10-06
#lecture-addition("Why positive capital requires no arbitrage", source: "2026-10-06, 00:00:46 - 00:03:31")[
  One extra unit of $k_(t+1)$ changes lifetime wealth by
  $
    p_(t+1) (1 + r_(t+1)) - p_t.
  $
  - If negative, the household chooses $k_(t+1) = 0$.
  - If positive, capital purchases generate unbounded wealth; there is no finite optimum.
  - If zero, the household is indifferent over capital holdings at these prices.

  An equilibrium with positive capital therefore requires equality.
  Future capital purchases and payoffs cancel; *initial capital* remains
  part of wealth because its acquisition cost is outside the lifetime budget.
]

With $p_0 = 1$,
$
  p_t = frac(1, product_(s=1)^t (1 + r_s)).
$
Capital purchases and their future payoffs cancel from the lifetime budget:
$
  sum_(t=0)^infinity p_t c_t
  = underbrace((1 + r_0) k_0, "initial capital wealth")
  + underbrace(sum_(t=0)^infinity p_t w_t, "lifetime labor income").
$
The lifetime budget makes a separate no-Ponzi condition unnecessary.

#lecture-addition("Valuing other assets", source: "2026-10-06, 00:04:08 - 00:05:13")[
  Date prices also value a claim to a dividend stream $d_t$:
  $
    q_0 = sum_(t=1)^infinity p_t d_t.
  $
  The same method prices a bond by multiplying each payoff by its delivery-date
  price. With uncertainty, use *state-contingent prices*. This is why
  Arrow-Debreu notation is convenient for asset pricing.
]

== Recursive equilibrium

Recursive methods apply to *decentralized economies* as well as planning
problems. Build on *sequential equilibrium*: agents choose each period,
and state variables evolve over time.

In the standard model, distinguish two states:
- $k$: *individual capital*, which determines household wealth.
- $K$: *aggregate capital*, which determines prices and their future path.

The household chooses $k'$ taking $K' = g(K)$ and the associated prices
_as given_. In equilibrium, $k = K$, but keeping both states in the
household problem preserves *price-taking*. With heterogeneity,
individual and aggregate states generally differ.

#lecture-addition(
  "Whose saving moves tomorrow's prices?",
  source: "2026-10-06, 00:07:30 - 00:08:48; 00:11:18 - 00:11:46",
)[
  Think of the representative household as one of many identical, tiny households.
  More *aggregate* saving lowers tomorrow's return to capital and raises wages.
  One household's saving has no effect on either price.

  Thus $K' = g(K)$ is taken as given inside the household problem.
  Impose $g(K) = k'(K, K)$ when checking equilibrium consistency.
]

=== Standard model

A recursive competitive equilibrium consists of:
- *Value function:* $v(k, K)$.
- *Policy functions:* $c(k, K)$ and $k'(k, K)$.
- *Price functions:* $r(K)$ and $w(K)$.
- *Aggregate law of motion:* $g(K)$.

These functions satisfy four conditions:

+ *Household optimality.* Given $r$, $w$ and $g$, the value function solves
  $
    v(k, K) = max_(c, k' >= 0) {u(c) + beta v(k', K')},
  $
  subject to
  $
    c + k' & = (1 + r(K)) k + w(K), \
        K' & = g(K).
  $
  The policies $c(k, K)$ and $k'(k, K)$ attain this maximum.

+ *Firm optimality.* With aggregate labor equal to one and $K > 0$,
  $
    r(K) & = alpha K^(alpha - 1) - delta, \
    w(K) & = (1 - alpha) K^alpha.
  $
  Here $r(K)$ is the _net return_; the capital rental rate is $r(K) + delta$.

+ *Market clearing.* For every admissible $K$,
  $
    c(K, K) + k'(K, K) = (1 - delta) K + K^alpha.
  $

+
  *Consistency.* The _perceived_ aggregate law must equal the law
  _generated_ by optimal household saving:

  $
    g(K) = k'(K, K).
  $

== The First Welfare Theorem

#theorem("First Welfare Theorem")[
  With *locally nonsatiated preferences*, *complete competitive markets*
  and *no externalities*, every competitive equilibrium allocation is
  *Pareto efficient*. This formulation assumes finitely many consumers
  and well-defined lifetime budgets.
]<thm:fwt>

_Pareto efficiency_ means that no feasible allocation makes everyone
weakly better off and at least one person strictly better off.

=== Key assumptions

- *Local nonsatiation:* every neighborhood of a consumption bundle
  contains a strictly preferred bundle.
- *Complete markets:* all relevant goods, delivery dates and states
  can be traded.
- *No externalities:* effects on others operate through market prices
  and trades.

*Convexity is not required.* Economies with _infinitely many overlapping
generations_ lie outside this finite-consumer result; competitive equilibria
can be inefficient.

#lecture-addition("Why overlapping generations are an exception", source: "2026-10-06, 00:18:10 - 00:21:32")[
  In a two-period OLG economy, infinitely many generations can trade an
  intrinsically worthless asset. The young give goods to the old for money,
  then sell that money to the next young generation when they retire.
  Under suitable conditions, this transfer scheme can improve on a nonmonetary
  equilibrium.

  *A last generation breaks the argument:* it cannot sell the money onward
  and loses from accepting it. The infinite sequence of consumers matters
  for this exception to the First Welfare Theorem.
]

=== Proof by contradiction of @thm:fwt

#proof[
  Let $p >= 0$ denote equilibrium prices and $omega$ aggregate endowments.
  At equilibrium, consumer $i$ consumes $x_i^star$ and has wealth $m_i$
  from endowments and distributed profits; firm $j$ produces $y_j^star$.

  Suppose $(tilde(x_i), tilde(y_j))$ is a feasible Pareto improvement:
  every consumer weakly prefers $tilde(x_i)$ to $x_i^star$, and consumer
  $h$ strictly prefers $tilde(x_h)$ to $x_h^star$.

  + *Consumer optimality.*
    - *Strict improvement:* the bundle must cost more than $m_i$;
      otherwise it was affordable.
    - *Weak improvement:* the bundle cannot cost less than $m_i$.
      With _budget slack_, local nonsatiation gives a nearby, strictly
      better bundle that remains affordable.
    Either violation contradicts optimality. Hence
    $
      p dot tilde(x_i) & >= m_i "for every" i, \
      p dot tilde(x_h) & > m_h "for the strictly improved consumer" h.
    $
    Summing gives
    $
      sum_i p dot tilde(x_i) > sum_i m_i.
    $

  + *Feasibility and firm optimality.*
    Consumption is bounded by endowments plus production.

    Profit maximization implies $p dot tilde(y_j) <= p dot y_j^star$
    for each firm. Therefore

    $
      sum_i p dot tilde(x_i) & <= p dot omega + sum_j p dot tilde(y_j) "(feasibility)", \
                             & <= p dot omega + sum_j p dot y_j^star "(profit maximization)", \
                             & = sum_i m_i "(endowments + distributed profits)".
    $

  + *Contradiction.* Total cost cannot be both _greater than_ and
    _at most_ aggregate wealth. No feasible Pareto improvement exists.
]

=== Implication for the standard model

In the *representative-agent standard model*, a competitive equilibrium
allocation solves the planner's problem. _If the planner's solution is
unique and equilibrium exists_, the allocations coincide. Recover prices
from firms' marginal products.

== The Second Welfare Theorem

#theorem("Second Welfare Theorem")[
  With complete competitive markets, no externalities and the conditions
  below, any *Pareto-efficient allocation* can be supported as a
  *competitive equilibrium* after *lump-sum wealth transfers*.
]<thm:swt>

=== Sufficient conditions

- *Consumers:* a finite set.
- *Consumption:* each consumption set $X_i$ is convex.
- *Preferences:* $u_i$ is continuous and locally nonsatiated. For
  $x, x' in X_i$ and $0 < lambda < 1$, assume
  $
    u_i (x) > u_i (x')
    ==> u_i (lambda x + (1 - lambda) x') > u_i (x').
  $
- *Production:* the aggregate production set $Y = sum_j Y_j$ is convex.
- *Separation:* the commodity space $S$ is finite-dimensional, or
  $Y$ has a nonempty interior.
-
  *Budget regularity:* at supporting prices $p$, each consumer has
  a feasible bundle $x_i^0 in X_i$ with

  $
    p dot x_i^0 < p dot x_i^star.
  $

Convexity alone guarantees only a _quasi-equilibrium_: a strictly
preferred bundle may cost exactly the consumer's wealth.#footnote[
  See #link("https://scottcondie.github.io/teaching/580/chapters/ge-welfare.html")[
    Condie's welfare-theorem notes, Proposition 6.1
  ] for the budget condition. In an infinite-dimensional commodity space,
  $p dot x$ denotes the continuous price functional applied to $x$.
]

=== Wealth transfers

At supporting prices, $m_i$ includes original endowments and profits at
the target production plan.
For target consumption $x_i^star$, choose *transfers* $T_i$:
$
        T_i & = underbrace(p dot x_i^star, "target wealth")
              - underbrace(m_i, "original wealth"), \
  p dot x_i & <= m_i + T_i = p dot x_i^star, \
  sum_i T_i & = 0.
$
Feasibility and profit distribution imply
$sum_i p dot x_i^star = sum_i m_i$, so transfers sum to zero.
*Lump-sum* transfers are _independent of choices_, leaving marginal
incentives unchanged.

=== Supporting prices

+ *Separation:* convexity permits a separating hyperplane between feasible
  aggregate resources and aggregate bundles that improve welfare.
+ *Prices:* the separating functional defines the price system $p$.
+ *Optimization:* firms maximize profits at these prices; budget regularity
  ensures consumers optimize their transfer-adjusted budgets.

== How do the welfare theorems matter?

- *Markets and information:* under the welfare-theorem assumptions,
  equilibrium prices coordinate decentralized choices into an efficient
  allocation. _The Use of Knowledge in Society_ @hayek1945knowledge
  explains how prices communicate _dispersed information_.
- *Policy:* diagnose failed assumptions, such as externalities, market power
  or missing markets. Under the second theorem's conditions, _lump-sum
  redistribution_ can implement different efficient distributions without
  changing marginal incentives.
- *Computing equilibrium:* in the standard model, solve the planner's
  Bellman equation, then recover prices from marginal products. With
  heterogeneity, a planner allocation may require _wealth transfers_ to
  be decentralized.

#lecture-addition("Diagnosing a policy problem", source: "2026-10-06, 00:27:40 - 00:29:30")[
  Ask which welfare-theorem assumption fails in the proposed application.
  - *Pollution:* an upstream producer harms downstream users without paying
    for that harm. A market for the relevant rights can price the externality.
  - *Health insurance:* adverse selection can prevent useful insurance markets
    from forming. A missing market may justify intervention, but the underlying
    information problem still needs to be addressed.
]

#lecture-addition("What should an economist remember?", source: "2026-10-06, 00:32:07 - 00:39:19")[
  The class proposed equilibrium, Nash equilibrium, supply and demand, and
  economy-wide resource constraints. *Nash equilibrium* concerns individual
  best responses; maximizing total welfare is a different condition.

  Economics often starts from *purposeful choices*: agents have objectives
  and face constraints. Macroeconomics asks how these choices interact and
  add up. Giving one group more resources requires accounting for where
  those resources come from.
]

= Lecture 3 Oct 6

== Fundamental models of economic growth

The *standard model* is a Solow growth model with _optimizing consumers_.
It matches long-run growth facts for high-income countries, but growth
models should also explain:
- Economic development beyond the period described by the Kaldor facts.
- Income and growth differences across _all countries_.
- The origin of productivity growth.

#definition("Kaldor's growth facts")[
  Kaldor's six *stylized facts* @kaldor1961growth summarize long-run
  growth patterns, originally observed in industrialized economies:

  + *Output per worker* $Y_t / N_t$ grows at a roughly constant positive rate.
  + *Capital per worker* $K_t / N_t$ grows over time.
  + The *return to capital* is roughly constant.
  + The *capital-output ratio* $K_t / Y_t$ is roughly constant.
  + *Labor and capital income shares* are roughly constant.
  + *Output-per-worker growth rates* differ substantially across countries.
]<def:kaldor-facts>

== Solow

=== Setup

Output combines capital $K_t$ and effective labor $A_t N_t$:
$
  Y_t = K_t^alpha (A_t N_t)^(1 - alpha), 0 < alpha < 1.
$
Here $N_t$ is population (and labor supply); $A_t$ is *labor-augmenting
productivity*. Both grow _exogenously_:
$
  A_(t+1) & = (1 + g) A_t, \
  N_(t+1) & = (1 + n) N_t.
$
Assume $g, n >= 0$. A *fixed saving rate* $0 < s < 1$ determines investment:
$
  K_(t+1) & = (1 - delta) K_t + s Y_t, \
      C_t & = (1 - s) Y_t,
$
where $0 <= delta <= 1$ is depreciation. In the _standard model_,
households instead choose saving optimally.

=== Capital per effective worker

Normalize by effective labor:
$
  k_t & = frac(K_t, A_t N_t), \
  y_t & = frac(Y_t, A_t N_t) = k_t^alpha, \
  c_t & = frac(C_t, A_t N_t) = (1 - s) k_t^alpha.
$
Divide capital accumulation by $A_t N_t$ and use
$A_(t+1) N_(t+1) = (1 + g)(1 + n) A_t N_t$:
$
  k_(t+1) (1 + g)(1 + n) & = (1 - delta) k_t + s k_t^alpha, \
           k_(t+1) - k_t & = frac(
                             s k_t^alpha - (delta + g + n + g n) k_t,
                             (1 + g)(1 + n)
                           ).
$
*Effective capital rises* when investment exceeds depreciation and the
capital needed to keep up with population and productivity growth.
The term $g n$ is retained because time is _discrete_.

=== Balanced growth path

On a *balanced growth path (BGP)*, capital per effective worker is constant:
$
  s overline(k)^alpha & = (delta + g + n + g n) overline(k), \
          overline(k) & = (frac(s, delta + g + n + g n))^(1 / (1 - alpha)).
$
This positive steady state requires $delta + g + n + g n > 0$.
For $k_0 > 0$, diminishing returns imply convergence: $k_t$ rises below
$overline(k)$ and falls above it.

- *Aggregate quantities:* $K_t$, $Y_t$ and $C_t$ grow at rate
  $(1 + g)(1 + n) - 1$.
- *Per capita quantities:* $K_t / N_t$, $Y_t / N_t$ and $C_t / N_t$
  grow at rate $g$.
- *Growth facts:* the capital-output ratio, factor income shares and
  the marginal product of capital are constant; real wages grow at rate $g$.

A higher saving rate raises the BGP *level* of income per capita, not its
*growth rate* $g$. With $g > 0$, the BGP matches Kaldor's first five facts.
Cross-country differences in long-run growth require different _exogenous_
productivity growth rates $g$.

#lecture-addition("Growth during the transition", source: "2026-10-06, 00:46:30 - 00:46:49; 00:48:04 - 00:48:30")[
  Constant $k_t = K_t / (A_t N_t)$ does not mean constant $K_t$: on the BGP,
  aggregate capital grows with effective labor.

  Cobb-Douglas *factor income shares* are constant even outside the BGP.
  Starting below $overline(k)$, $k_t$ rises, so
  $
    frac(K_t, Y_t) & = k_t^(1 - alpha) " rises", \
           "MPK"_t & = alpha k_t^(alpha - 1) " falls".
  $
  Constant capital-output ratios and returns are properties of the BGP,
  rather than every point along the transition.
]

#lecture-addition("What the fixed saving rate assumes", source: "2026-10-06, 00:50:44 - 00:52:16")[
  The Solow model imposes the consumption-saving choice through $s$.
  It is a *reduced-form behavioral assumption*. The standard model derives
  this choice from household optimization.

  A steady ratio in effective units still permits growth in levels and
  transitional dynamics. The version here is deterministic because it
  contains no shocks.
]

=== Limitations

- Persistent cross-country income gaps require _exogenous differences_
  in productivity, saving or population growth.
- Baseline calibrations can imply faster convergence than observed,
  even among high-income countries.
- Productivity growth is unexplained; the model also lacks a mechanism
  for the historical transition from long-run stagnation to sustained growth.

== Malthus

=== Setup

The model describes a preindustrial economy with population $N_t$ and
*fixed land* $X > 0$:
$
  Y_t = N_t^alpha (A_t X)^(1 - alpha), 0 < alpha < 1.
$
Productivity grows exogenously at rate $g >= 0$:
$
  A_(t+1) = (1 + g) A_t.
$
*Population growth responds to income per capita*:
$
  frac(N_(t+1), N_t) & = s frac(Y_t, N_t), \
             N_(t+1) & = s Y_t.
$
Here $s > 0$ is a demographic parameter. Higher income raises fertility
or reduces mortality. Population increases when $s Y_t / N_t > 1$.

#lecture-addition(
  "Two routes from income to population",
  source: "2026-10-06, 00:57:22 - 00:59:04; 01:00:08 - 01:00:14",
)[
  Higher income can raise demand for children or improve survival through
  better nutrition, especially in infancy. Either route gives a positive
  income-population feedback.

  Unlike Solow's saving rate, this $s$ is *not a fraction of output saved*;
  the model does not require $s < 1$. Its demographic interpretation differs
  even though it occupies the same place in the accumulation equation.
]

=== Population per effective land unit

Normalize by effective land $A_t X$:
$
               n_t & = frac(N_t, A_t X), \
  frac(Y_t, A_t X) & = n_t^alpha, \
    frac(Y_t, N_t) & = n_t^(alpha - 1).
$
Using $N_(t+1) = s Y_t$ gives
$
  n_(t+1) (1 + g) & = s n_t^alpha, \
          n_(t+1) & = frac(s, 1 + g) n_t^alpha.
$
Since $alpha < 1$, income per person falls as population grows relative
to effective land.

=== Balanced growth path

On the BGP, $n_t = overline(n)$ is constant:
$
  overline(n) (1 + g) & = s overline(n)^alpha, \
          overline(n) & = (frac(s, 1 + g))^(1 / (1 - alpha)).
$
For $n_0 > 0$, $n_t$ converges to $overline(n)$: it rises below the steady
state and falls above it.

BGP income per capita and population density are
$
  frac(Y_t, N_t) & = overline(n)^(alpha - 1) = frac(1 + g, s), \
    frac(N_t, X) & = A_t overline(n).
$
- Population and aggregate output grow at rate $g$.
- #text(fill: red)[*Income per capita is constant*, even with positive productivity growth.]
- Holding $s$ and $g$ fixed, higher productivity levels imply greater
  population density and the same BGP income per capita.

A permanent increase in the _level_ of productivity initially raises
income per person. Higher income accelerates population growth. As
population rises relative to land, diminishing returns bring income per
person back toward $(1 + g) / s$.

#lecture-addition("Lower fertility raises levels, not long-run growth", source: "2026-10-06, 01:07:11 - 01:09:19")[
  Holding $g$ fixed, a lower demographic parameter $s$ raises BGP income
  per person, $(1 + g) / s$, while per capita growth remains zero.
  The lecture used *later marriage* as an example: fewer childbearing years
  can lower fertility at a given income and support higher living standards
  within the Malthusian regime.
]

#lecture-addition("What if land expands?", source: "2026-10-06, 01:09:24 - 01:11:28")[
  Fixed land creates diminishing returns to population. If land instead
  grows exogenously, the same normalization uses $A_t X_t$.
  With $X_(t+1) / X_t = 1 + g_X$, effective land grows at
  $
    1 + g_(A X) = (1 + g)(1 + g_X).
  $
  Replacing $g$ by $g_(A X)$ gives BGP income per person
  $(1 + g_(A X)) / s$. Frontier expansion can raise this *level* and sustain
  faster population growth; a constant expansion rate still leaves
  long-run income per person constant.
]

The model captures long preindustrial periods of stagnant income per person.

=== Malthus versus Solow

Solow accumulates *capital*; Malthus accumulates *population*. On the BGP,
the return to the accumulated factor is constant. With competitive factor
pricing, Malthus implies
$
    w_t & = alpha frac(Y_t, N_t) = alpha frac(1 + g, s), \
  r_t^X & = (1 - alpha) frac(Y_t, X),
$
where $r_t^X$ is the rental rate of land. _Wages are constant and land rents
grow at rate $g$._

In Solow, the return to capital is constant and wages
grow at rate $g$.

=== From Malthus to Solow

Malthus describes preindustrial stagnation; Solow describes sustained
growth in modern economies. Neither model alone explains the transition.

#lecture-addition("What must change to escape stagnation?", source: "2026-10-06, 01:13:28 - 01:15:52")[
  The lecture outlined three mechanisms for the next class:
  - *Structural change:* move production from land-dependent agriculture
    toward industry and services, whose capital and labor inputs can expand.
  - *Demographic change:* weaken the positive income-fertility relationship;
    richer modern economies generally have lower birth rates.
  - *Productivity growth:* explain why it accelerates and how it interacts
    with the other mechanisms.

  A student also raised the scale effect in endogenous growth:
  more people can produce more ideas. The lecturer noted that this is
  another mechanism studied in the literature.
]
// END recording additions 2026-10-06

_Malthus to Solow_ @hansen2002malthus combines both technologies in one
economy. Firms choose which to operate as productivity grows.

==== Technologies and resources

Both technologies are available in every period and produce the *same good*:
$
  Y_(M,t) & = A_(M,t) K_(M,t)^alpha_1 N_(M,t)^alpha_2 X^(1 - alpha_1 - alpha_2), \
  Y_(S,t) & = A_(S,t) K_(S,t)^theta N_(S,t)^(1 - theta).
$
The Malthus sector $M$ uses land; the Solow sector $S$ uses only capital
and labor. Assume $alpha_1, alpha_2 > 0$, $alpha_1 + alpha_2 < 1$ and
$0 < theta < 1$. Sectoral *TFP* grows exogenously:
$
  A_(j,t+1) = gamma_j A_(j,t), quad j in {M, S}.
$
Here $gamma_M >= 1$ and $gamma_S > 1$ are gross growth factors.
Competitive firms allocate capital and labor freely across sectors:
$
  K_t & = K_(M,t) + K_(S,t), \
  N_t & = N_(M,t) + N_(S,t), \
    X & = 1.
$
One period represents a generation, so capital depreciates fully ($delta = 1$).
Land does not depreciate. Aggregate feasibility is
$
  C_t + K_(t+1) = Y_(M,t) + Y_(S,t).
$

==== Households and population

Households live for two periods and work only when young. A household
born at $t$ chooses positive consumption and nonnegative capital $k_(t+1)$
and land $x_(t+1)$. With $beta > 0$, its objective is
$
  max log c_(1,t) + beta log c_(2,t+1),
$
subject to
$
  c_(1,t) + k_(t+1) + q_t x_(t+1) & = w_t, \
                        c_(2,t+1) & = r_(t+1)^K k_(t+1) + (r_(t+1)^X + q_(t+1)) x_(t+1).
$
Here $q_t$ is the land price and $r_t^K$, $r_t^X$ are capital and land
rental rates. With full depreciation, $r_(t+1)^K$ is the entire payoff
from one unit of capital saved at $t$.

There are $N_t$ young households at $t$. Population follows a *calibrated*
function $G$:
$
  N_(t+1) = G(c_(1,t)) N_t.
$
$G$ rises with consumption at low living standards and falls at high
living standards. Each young household supplies one unit of labor.
Asset and goods markets clear when
$
  K_(t+1) & = N_t k_(t+1), \
        1 & = N_t x_(t+1), \
      C_t & = N_t c_(1,t) + N_(t-1) c_(2,t).
$
With interior asset holdings, household optimality gives
$
        c_(1,t) & = frac(w_t, 1 + beta), \
  q_t r_(t+1)^K & = r_(t+1)^X + q_(t+1), \
        K_(t+1) & = N_t frac(beta, 1 + beta) w_t - q_t.
$
The second equation equates the returns on capital and land. The third
subtracts land purchases from the young generation's total saving.

==== Solow sector entry

Normalize the output price to one. At given factor prices, the minimum
cost of producing one unit with the Solow technology is
$
  frac(1, A_(S,t))
  (frac(r_t^K, theta))^theta
  (frac(w_t, 1 - theta))^(1 - theta).
$

To test entry, evaluate this cost at the *Malthus-only* factor prices
$r_(M,t)^K$ and $w_(M,t)$. Entry is profitable when

$
  A_(S,t) >
  underbrace(
    (frac(r_(M,t)^K, theta))^theta
    (frac(w_(M,t), 1 - theta))^(1 - theta),
    "entry threshold"
  ).
$
If $A_(S,0) = 1$, then $A_(S,t) = gamma_S^t$; the slide's factor
$1/gamma_S^t$ is therefore $1/A_(S,t)$.

Once entry occurs, factor prices adjust. If both sectors operate,
their marginal products of capital and labor must coincide:
$
  r_t^K & = alpha_1 frac(Y_(M,t), K_(M,t)) = theta frac(Y_(S,t), K_(S,t)), \
    w_t & = alpha_2 frac(Y_(M,t), N_(M,t)) = (1 - theta) frac(Y_(S,t), N_(S,t)).
$
The Malthus sector remains active at every finite date. With fixed land,
scaling its capital and labor down together makes their marginal products
arbitrarily large, so allocating a small amount to this sector remains worthwhile.

==== Transition

+ Initially, only the Malthus technology operates. Population growth
  absorbs productivity gains, keeping living standards constant.
  Solow productivity continues to grow while that sector is unused.
+ On the Malthusian growth path, wages and capital rental rates are
  constant, so the entry threshold is fixed. Rising $A_(S,t)$ eventually
  crosses it, and firms allocate capital and labor to the Solow sector.
+ The Solow sector has constant returns in capital and labor, with no
  fixed land input. In the calibrated economy, its share expands and
  income per person grows. The Malthus sector's share tends to zero.
  Population growth eventually falls through the assumed function $G$.

==== Limitations

- Productivity growth remains exogenous.
- The demographic transition comes from the calibrated function $G$;
  fertility and mortality decisions are not derived from household choices.
- The two technologies produce the same good. Requiring a separate
  agricultural good for subsistence would change the mechanism.

= Lecture 4 Oct 12

== Consumption, heterogeneity and policy

// BEGIN recording additions 2026-10-12
#lecture-addition("Consumption functions and consumption smoothing", source: "2026-10-12, 00:08:21 - 00:16:02")[
  In the simple Keynesian example, consumption responds mechanically to current
  income. An illustrative marginal propensity to consume of 0.8 gives
  $
    "multiplier" = frac(1, 1 - "MPC") = frac(1, 1 - 0.8) = 5.
  $
  An optimizing household instead considers lifetime resources:
  - A permanent income gain supports a larger increase in consumption.
  - A one-off windfall is spread across future periods through saving.
  - An announced future income change can affect consumption today.

  The saving-and-borrowing example assumes *incomplete insurance*.
  With complete markets, idiosyncratic windfalls would be shared through
  state-contingent claims.
]

#lecture-addition("Hall's consumption test", source: "2026-10-12, 00:16:03 - 00:22:07")[
  Consumption already incorporates information about expected future income.
  Hall's test asks whether other current information helps forecast its next
  change @hall1978stochastic.

  For the exact random-walk benchmark, assume an unconstrained interior choice,
  a constant gross return $R$, $beta R = 1$ and quadratic utility
  $u'(c) = a - b c$, with $b > 0$. The Euler equation gives
  $
                u'(c_t) & = beta R E_t [u'(c_(t+1))], \
              a - b c_t & = a - b E_t [c_(t+1)], \
    E_t [c_(t+1) - c_t] & = 0.
  $
  Quadratic utility gives certainty equivalence. Precautionary saving can
  break the exact random-walk result.

  *Paper detail:* Hall used aggregate US data. Current income did not help
  predict consumption once current consumption was controlled for, but stock
  prices did. The original empirical conclusion was therefore qualified.
]

#lecture-addition("From New Keynesian models to HANK", source: "2026-10-12, 00:24:00 - 00:31:09")[
  Woodford combines optimizing households with nominal price or wage rigidities
  @woodford2003interest. Interest rates and expected future rates affect
  consumption through households' Euler equations.

  Households differ in wealth, liquidity and debt exposure. A household facing
  mortgage repricing can react differently from a wealthy saver. *HANK*
  (Heterogeneous Agent New Keynesian) models incorporate these differences;
  the paper discussed was _Monetary Policy According to HANK_
  @kaplan2018monetary.
]

#lecture-addition("Debt deflation", source: "2026-10-12, 00:32:24 - 00:34:35")[
  With fixed nominal debt $D$, a fall in the price level raises its real value:
  $
    P' = P / 2 quad => quad frac(D, P') = 2 frac(D, P).
  $
  Bankruptcies can disrupt production and access to finance. The lecturer
  suggested this could be an important channel behind severe downturns,
  possibly more important than a household demand shortfall.
  A related model of firm borrowing and collateral is _Credit Cycles_
  @kiyotaki1997credit.
]

#lecture-addition("Ricardian equivalence as a benchmark", source: "2026-10-12, 00:34:45 - 00:37:03")[
  Hold government spending fixed. Debt finance postpones taxes. If households
  are unconstrained, forward looking and bear the future tax liabilities,
  changing the timing of taxes leaves lifetime wealth unchanged
  @barro1974bonds.

  Borrowing constraints, finite horizons and limited foresight can break this
  neutrality. The benchmark helps identify which assumptions make the timing
  of taxes matter.
]
// END opening discussion 2026-10-12

== Facts on growth and demographics

Figures from Lecture 5, slides 4--7.
- Income and population data: Maddison Project Database 2023 @bolt2024maddison.
- Fertility data: UN World Population Prospects @un2024wpp,
  via #link("https://ourworldindata.org/grapher/children-per-woman-un")[Our World in Data].

#let figure-note(body) = block(width: 100%, above: 7pt, below: 0.5em)[
  #set text(size: 9pt)
  #set par(justify: false)
  _Note:_ #body
]

=== Income per capita over the long run

Income remains low for centuries, then takes off. Takeoff dates differ across
countries; modern income gaps are large.

#figure(
  image("figures/income_long_run.svg", width: 100%),
  caption: [Income per capita over the long run.],
)<fig:long-run-income>

#figure-note[
  $y_t = Y_t / N_t$: income per capita in 2011 international dollars.
]

=== Population growth

Population growth has a hump shape in many regions, with peaks at different
dates. Births, deaths and migration all matter.

#figure(
  image("figures/population_growth.svg", width: 100%),
  caption: [Population growth by region.],
)<fig:population-growth>

#figure-note[
  $g_N$: average annual population growth (% per year) between benchmark
  years, plotted at interval midpoints.
]

=== Fertility over time

_Total fertility rate (TFR)_ is lifetime births per woman at current
age-specific fertility rates. Fertility declines at different times;
several countries fall below replacement.

#figure(
  image("figures/fertility_history.svg", width: 100%),
  caption: [Fertility over time.],
)<fig:fertility-history>

#figure-note[
  $"TFR"_t$: total fertility rate (births per woman).
  Dashed line: replacement benchmark, about 2.1 births per woman.
]

=== Fertility and income across countries

In 2022, richer countries generally have lower fertility. Israel lies
above the high-income cluster.

#figure(
  image("figures/fertility_income_2022.svg", width: 100%),
  caption: [Fertility and income, 2022.],
)<fig:fertility-income>

#figure-note[
  $"TFR"$: births per woman; $y = Y / N$: income per capita in 2011
  international dollars (log scale). Countries with population above one million.
]

== Malthus to Solow: simulated transition

#figure(
  image("figures/malthus_solow_transition.svg", width: 100%),
  caption: [Simulated transition from Malthus to Solow.],
)<fig:malthus-solow-transition>

#figure-note[
  Left: income per capita $y = Y / N$ (model units, log scale).
  Middle: Solow output share $Y_S / (Y_M + Y_S)$.
  Right: population growth $g_N$ (% per year). Time is in years; one model period
  is 35 years. Parameters: $(alpha_1, alpha_2, theta) = (0.1, 0.6, 0.4)$;
  gross TFP growth factors per period: $(gamma_M, gamma_S) = (1.032, 1.518)$.
  Lecture 5, slide 12: simplified simulation using Hansen--Prescott technology
  parameters and population function @hansen2002malthus, with a fixed saving
  rate in place of the OLG saving problem.
]

+ Initially, only the *Malthus sector* operates. Income per capita is flat;
  productivity gains raise population.
+ Rising Solow productivity crosses the *entry threshold*. The Solow sector's
  output share increases and income per capita starts to grow.
+ Population growth first rises, then falls. The decline comes from the
  *calibrated population function*; fertility choices are not derived here.

#lecture-addition("Why an unused technology can improve", source: "2026-10-12, 00:54:30 - 00:56:12")[
  Solow-sector productivity grows even before the sector operates. The lecture
  interpreted this as accumulated knowledge from other activities: precise
  metalworking and other complementary skills eventually make industrial
  production viable. The steam engine illustrates how an invention can depend
  on many earlier improvements. Productivity growth is still exogenous in
  the model.
]

#lecture-addition("Trade and the return to education", source: "2026-10-12, 00:59:39 - 01:01:58")[
  A student asked how trade affects the transition. Galor and Mountford
  @galor2008trading study specialization and demographic change:
  - An early industrializer specializes in activities intensive in human
    capital and imports food. Higher returns to education favor investment
    per child.
  - A later industrializer specializes in agriculture. Lower returns to
    education favor higher fertility and can delay its transition.

  Trade can therefore widen differences in income per person and population
  growth through the quantity-quality choice.
]

#lecture-addition("Food and structural change", source: "2026-10-12, 01:02:24 - 01:03:03")[
  Hansen and Prescott treat the two sectors' outputs as perfect substitutes.
  If food must instead come from agriculture, a growing population may draw
  workers back into the land-dependent sector. Feeding the population then
  becomes a constraint on the expansion of industry.
]

== Becker, Murphy and Tamura (1990)

_Human Capital, Fertility, and Economic Growth_ @becker1990human.
Lecture 5, slides 14 to 28 use a simplified version without physical capital.

Parents choose the number of children and education per child: the
_quantity-quality choice_. The model can have two stable regimes:
*high fertility and stagnation*, or *lower fertility and sustained growth*.
Escaping stagnation requires a sufficiently large shock.

=== Demographics, state and choices

People live for two periods: childhood, then adulthood. Adults work and
consume, and spend time raising and teaching the next generation.

- State: acquired human capital $H >= 0$. Every adult also has raw-labor
  productivity $H_0 > 0$; total productivity is $H_0 + H$.
- Choices: consumption $c > 0$, number of children $n > 0$ (continuous),
  and teaching time per child $h >= 0$.
- Next state: each child inherits the same human capital $H'$.
- Adult time endowment is one. Each child requires fixed childcare time
  $v > 0$ and a goods cost $f >= 0$.

This version has no assets or aggregate shocks. $H_0$ is fixed raw-labor
productivity, distinct from the initial value of $H$.

=== Dynastic preferences

Parents value their own consumption and their children's utility:
$
  u(c) & = frac(c^sigma, sigma), quad 0 < sigma < 1, \
  a(n) & = alpha n^(-epsilon), quad alpha > 0, quad 0 < epsilon < 1, \
  V(H) & = u(c) + a(n) n V(H') \
       & = frac(c^sigma, sigma) + alpha n^(1 - epsilon) V(H').
$

- Altruism *per child*, $a(n)$, falls with fertility; total weight on children,
  $alpha n^(1 - epsilon)$, rises.
- $epsilon = - frac(d log a(n), d log n)$ measures how altruism per child
  falls with fertility. Relative risk aversion is $1 - sigma$.

Assume finite dynastic utility. The continuation weight varies with $n$.

#lecture-addition(
  "The continuation value belongs to the child",
  source: "2026-10-12, 01:06:07 - 01:08:09; 01:11:08 - 01:11:59",
)[
  $V(H')$ is the child's adult utility, including that child's concern for the
  next generation. Parents care about their children's actual welfare.
  If $H'$ differs from parental human capital, the child can choose different
  fertility and education. Identical people within a generation need not make
  identical choices across generations.
]

=== Resources and human-capital production

Childcare and teaching leave $1 - n(v + h)$ units of working time:
$
   c + f n & = [1 - n(v + h)] (H_0 + H), \
        H' & = A h (H_0 + H), quad A > 0, \
  n(v + h) & <= 1.
$

$A$ is teaching productivity. Higher parental human capital raises both the
opportunity cost of time and the amount a parent can teach.

Eliminate $h$ to write the problem in $(n, H')$:
$
            h & = frac(H', A(H_0 + H)), \
  c(H, n, H') & = (1 - n v)(H_0 + H) - frac(n H', A) - f n.
$

The Bellman equation is
$
  V(H) = max_(n > 0, H' >= 0)
  {frac(c(H, n, H')^sigma, sigma) + alpha n^(1 - epsilon) V(H')},
  quad c(H, n, H') > 0.
$

More children raise the total cost of providing a given education per child.

=== Optimal education: corner condition and Euler equation

At a differentiable optimum, the marginal benefit cannot exceed the marginal
cost at zero investment; they are equal at positive investment:

$
                                  alpha n^(1 - epsilon) V'(H') & <= frac(n c^(sigma - 1), A), \
  H' [frac(n c^(sigma - 1), A) - alpha n^(1 - epsilon) V'(H')] & = 0.
$

The envelope condition is
$
  V'(H) = c^(sigma - 1) (1 - n v).
$

Holding $H'$ fixed keeps teaching cost $n H'/A$ independent of $H$.
The envelope coefficient $1 - n v$ therefore differs from working time
$1 - n(v + h)$.

Let $c'$ and $n'$ denote the child's adult choices. Substitute the child's
envelope condition into the education FOC:
$
  alpha n^(1 - epsilon) (c')^(sigma - 1) (1 - n' v) & <= frac(n c^(sigma - 1), A), \
  underbrace(
    frac(n^epsilon, alpha) (frac(c', c))^(1 - sigma),
    "consumption MRS"
  )                                                 & >= underbrace(A(1 - n' v), "education return").
$

Equality holds if $h > 0$. High fertility raises $n^epsilon / alpha$ and
discourages investment in each child's future consumption.

#lecture-addition("Why education can be zero", source: "2026-10-12, 01:14:03 - 01:16:24")[
  Children receive $H_0$ without teaching. When acquired human capital is low,
  a small addition to $H'$ gives a small proportional gain in their future
  productivity, while teaching immediately reduces parental working time.
  Because parents also pay the fixed food cost $f n$, the percentage loss in
  their consumption can exceed the percentage loss in earnings.

  When acquired skills account for most of children's future earnings,
  education has a much larger effect on their welfare. This is the intuition
  behind the two investment regimes.
]

=== Optimal fertility

For an interior fertility choice, differentiate the Bellman equation with
respect to $n$:
$
  underbrace((1 - epsilon) alpha n^(-epsilon) V(H'), "benefit of another child")
  = underbrace(
    c^(sigma - 1) [(v + h)(H_0 + H) + f],
    "goods and time cost"
  ).
$

Higher $H$ makes childcare and teaching time more expensive. The substitution
effect favors fewer children and more education per child. Higher income also
raises demand for children, so the net fertility response depends on both effects.

#lecture-addition("Positive fertility and the quantity-quality choice", source: "2026-10-12, 01:16:24 - 01:18:34")[
  At a fixed continuation value $V(H') > 0$, the marginal benefit of children
  diverges as fertility approaches zero:
  $
    (1 - epsilon) alpha n^(-epsilon) V(H') -> infinity
    quad "as" quad n -> 0.
  $
  This supports positive fertility under the model's assumptions, even when
  teaching is zero.

  Planning more education per child raises the time cost of every additional
  child through $(v + h)(H_0 + H)$. Education choices make children more
  expensive and can reduce fertility.
]

=== Malthusian steady state

Every generation chooses zero education:
$
    H & = H' = h = 0, \
  c_M & = H_0 - n_M (v H_0 + f) > 0.
$

With constant consumption and fertility,
$
  V(0) & = frac(c_M^sigma, sigma) + alpha n_M^(1 - epsilon) V(0), \
       & = frac(c_M^sigma, sigma [1 - alpha n_M^(1 - epsilon)]).
$

Finite utility requires $alpha n_M^(1 - epsilon) < 1$.
Fertility $n_M$ satisfies the FOC below; substituting $V(0)$ gives its second form:

$
  (1 - epsilon) alpha n_M^(-epsilon) V(0)
  = c_M^(sigma - 1) (v H_0 + f).
$

$
  frac(
    (1 - epsilon) alpha n_M^(-epsilon) c_M,
    sigma [1 - alpha n_M^(1 - epsilon)]
  ) = v H_0 + f.
$

For a *strict no-investment corner*, the Euler condition becomes
$
  frac(n_M^epsilon, alpha) > A(1 - n_M v).
$

- High fertility raises the left side and lowers the right side. Suitable
  $v$, $f$ and preference parameters support the no-investment corner.
- When the zero-investment policy is strictly optimal and remains so near
  $H = 0$, small increases in $H$ lead back to $H' = 0$ in one generation.
  The Euler inequality alone is a local condition, not a global optimality proof.
- Consumption per adult stays constant. Under the model's one-adult household
  convention, $N_(t+1) = n_M N_t$; population grows if $n_M > 1$.

=== Balanced growth path

For sufficiently large $H$, education can sustain growth. Along a growing
path, $H_0/H -> 0$ and $f/c -> 0$. Set $H_0 = f = 0$ in the limiting problem:
$
   c & = [1 - n(v + h)] H, \
  H' & = A h H.
$

On the *balanced growth path* (BGP), $n$ and $h$ are constant. Define the
gross growth factor $1 + g$:
$
  1 + g = frac(c', c) = frac(H', H) = A h.
$

Homogeneity implies $V(H) = C H^sigma$, with $C > 0$, so
$
  frac(V'(H') H', V(H')) = sigma.
$

The interior FOCs for teaching and fertility are
$
             A alpha n^(-epsilon) V'(H') & = c^(sigma - 1), \
  (1 - epsilon) alpha n^(-epsilon) V(H') & = c^(sigma - 1) (v + h) H.
$

Divide the first by the second, then multiply by $H'$:
$
  frac(1, 1 - epsilon) frac(V'(H') H', V(H')) & = frac(H', A H(v + h)), \
                     frac(sigma, 1 - epsilon) & = frac(h, v + h), \
                      (1 - epsilon - sigma) h & = sigma v.
$

$
      h & = frac(sigma v, 1 - epsilon - sigma), \
  1 + g & = frac(A sigma v, 1 - epsilon - sigma).
$

Positive teaching requires $1 - epsilon - sigma > 0$; positive growth requires
$1 + g > 1$. These conditions describe the limiting growth regime.
An economy starting near $H = 0$ can still remain in stagnation.

Fertility on the BGP satisfies the Euler equation
$
  frac(n^epsilon, alpha) (1 + g)^(1 - sigma) & = A(1 - n v), \
                                   n^epsilon & = alpha A(1 - n v) (1 + g)^(sigma - 1).
$

The candidate must also satisfy
$
                             n(v + h) & < 1, \
  alpha n^(1 - epsilon) (1 + g)^sigma & < 1.
$

The first condition leaves time for production and positive consumption.
The second ensures finite dynastic utility as consumption grows:
$
  V(H) = frac(
    [1 - n(v + h)]^sigma H^sigma,
    sigma [1 - alpha n^(1 - epsilon) (1 + g)^sigma]
  ).
$

- On an interior feasible BGP, higher fixed childcare time $v$ raises teaching
  time per child and the growth rate.
- $alpha$ affects BGP fertility; it drops out of the growth formula.
- Growth is *endogenous*: parents choose teaching while $A$ stays constant.
  With $H_0 > 0$ or $f > 0$, the BGP formulas hold asymptotically.

#lecture-addition("Mass schooling and fertility", source: "2026-10-12, 01:24:05 - 01:25:02")[
  The lecture linked falling fertility in today's high-income countries to
  the expansion of mass schooling in the late nineteenth century. Education
  increased the investment families made in each child, motivating the
  quantity-quality mechanism in these growth models.
]

=== Two regimes and the transition threshold

#align(center)[

  #figure(
    image("figures/bmt_two_regimes.svg", width: 75%),
    caption: [Human capital and the two regimes.],
  )<fig:bmt-two-regimes>
]
#figure-note[
  $H_t$ and $H_(t+1)$: acquired human capital per adult in successive
  generations (model units). Dashed line: $H_(t+1) = H_t$.
  $H^*$: threshold separating stagnation and growth in the schematic.
  Lecture 5, slide 27. The curve is a schematic, not a calibrated policy function.
]

- Near zero, $h = 0$ and $H_(t+1) = 0$.
- Below the threshold, positive education can still be insufficient to replace
  parental human capital: $H_(t+1) < H_t$.
- Above the threshold, $H_(t+1) > H_t$; the economy approaches the BGP.
  Fertility is lower and teaching per child is higher in the growth regime.
- A large enough shock to human capital or technology can change the eventual
  regime. A small temporary increase in $H$ may leave it unchanged.

On the BGP, *growth rates and time allocation* stay constant while human capital
keeps rising. The smooth threshold crossing is schematic: a nonconcave problem
can have a policy jump or a kink in $V$. FOCs alone do not establish the global
optimum.

= Lecture 5 Oct 13

== Becker, Murphy and Tamura: assessment

- Cheap parental time favors many children. Costly time and productive teaching
  favor more investment per child.
- The _Malthusian_ regime has high fertility and stagnant income per adult.
  Land is absent, and there is no exogenous productivity trend whose gains
  are absorbed by population growth.
- A large shock can start sustained growth. Its historical origin is outside
  the model.
- Stagnation can be optimal for a dynasty under these preferences and
  constraints. Pareto efficiency across generations requires a specified
  welfare criterion; it does not follow from household optimality alone.
- The dynastic-altruism framework remains widely used to model fertility
  in macroeconomics.

== Unified growth theory: Galor and Weil (2000)

_Population, Technology, and Growth: From Malthusian Stagnation to the
Demographic Transition and Beyond_ @galor2000population.
Lecture 5, slides 29 to 33.

Population growth speeds up technological progress. Faster technological
change raises the return to education, shifting parents toward fewer,
better-educated children. The transition to modern growth is *endogenous*.

=== Households and child quality

People live for two periods: childhood, then adulthood. Each adult has one
unit of time and chooses consumption $c_t$, fertility $n_t$, and education
per child $e_(t+1) >= 0$.

- $L_t$: adult population; land $X$ is fixed.
- $A_t$: technology; $g_(t+1) = A_(t+1)/A_t - 1$ is technological progress
  per generation.
- $h_t$: human capital per adult; $w_t$: wage per efficiency unit of labor.
  Potential income, before childcare, is $z_t = w_t h_t$.
- Each child costs $tau^q > 0$ units of parental time; each unit of education
  costs another $tau^e > 0$ units. Write $tau(e) = tau^q + tau^e e$.

Preferences and the budget constraint are
$
                         u_t & = (1 - gamma) log c_t + gamma log(n_t h_(t+1)), \
  c_t + z_t n_t tau(e_(t+1)) & = z_t, \
                         c_t & >= tilde(c) > 0, quad 0 < gamma < 1.
$

Parents value the number and human capital of their children. Here $gamma$
is the preference weight on children, and $tilde(c)$ is subsistence consumption.
The lecture suppresses the child's future wage in utility: an individual
parent takes it as given, so it does not affect the choices.

// BEGIN recording additions 2026-10-13
#lecture-addition("Child quality in preferences", source: "2026-10-13, 00:04:01 - 00:04:31")[
  Becker, Murphy and Tamura value children's continuation utility. Galor and
  Weil put $n_t h_(t+1)$ directly into parental utility. This reduced-form
  specification avoids solving the children's dynastic problem.
]

=== Fertility and subsistence

If the subsistence constraint is slack, the fertility FOC gives

$
  frac(gamma, n_t) & = frac((1 - gamma) z_t tau(e_(t+1)), c_t), \
  n_t tau(e_(t+1)) & = gamma, \
               c_t & = (1 - gamma) z_t.
$

This requires $z_t >= tilde(z) := tilde(c)/(1 - gamma)$.
For $z_t > tilde(c)$, the full solution is
$
  n_t tau(e_(t+1)) = cases(
    1 - frac(tilde(c), z_t) & "if" tilde(c) < z_t < tilde(z),
    gamma & "if" z_t >= tilde(z),
  ).
$

- Below $tilde(z)$, $c_t = tilde(c)$. Higher income frees time from work
  and raises fertility, holding education fixed.
- Above $tilde(z)$, the fraction of time spent on children is constant:
  $n_t = gamma/(tau^q + tau^e e_(t+1))$. More income alone does not raise
  fertility; more education lowers it.

#lecture-addition("Population growth requires a parameter restriction", source: "2026-10-13, 00:12:29 - 00:13:49")[
  At zero education, unconstrained fertility is
  $
    n_t^("unconstrained") = frac(gamma, tau^q).
  $
  Population growth in this regime requires $gamma/tau^q > 1$.
  A ratio below one gives declining population even when subsistence is slack.
  The income-fertility feedback comes from *binding subsistence*; unconstrained
  fertility is constant at fixed education.
]

=== Education and technological change

Children's human capital is
$
  h_(t+1) = h(e_(t+1), g_(t+1)), quad h > 0, \
  h_e > 0, quad h_(e e) < 0, quad h_g < 0, quad h_(e g) > 0.
$

Education raises human capital with diminishing returns. Technological
change makes existing skills less useful; education reduces this loss.
The paper assumes the productivity gain still raises potential earnings.

After substituting optimal fertility, the education choice in either income
regime is
$
  e_(t+1) in arg max_(e >= 0)
  frac(h(e, g_(t+1)), tau^q + tau^e e).
$

For positive education, the marginal gain in child quality equals the
proportional increase in the time cost per child:
$
  frac(h_(e)(e, g), h(e, g)) = frac(tau^e, tau^q + tau^e e).
$
At $e = 0$, the left side is no larger than the right side.

Define $F(e, g) = tau(e) h_(e)(e, g) - tau^e h(e, g)$. At an interior optimum,

$
            F(e, g) & = 0, \
                F_e & = tau(e) h_(e e) < 0, \
                F_g & = tau(e) h_(e g) - tau^e h_g > 0, \
  frac(d e(g), d g) & = -frac(F_g, F_e) > 0.
$

The model assumes a threshold $hat(g)$ satisfying $F(0, hat(g)) = 0$:
$
  e_(t+1) & = e(g_(t+1)), \
     e(g) & = 0, quad "if" g <= hat(g), \
     e(g) & > 0, quad e'(g) > 0, quad "if" g > hat(g).
$

Slow technological change gives an *education corner*. Faster change makes
education worth its time cost, even though preferences stay fixed.

=== Technology and population dynamics

Technological progress depends on the education of the current adults and
the size of the population:
$
  g_(t+1) & = g(e_t, L_t), \
  A_(t+1) & = (1 + g_(t+1)) A_t, \
  e_(t+1) & = e(g_(t+1)), \
  h_(t+1) & = h(e_(t+1), g_(t+1)), \
  L_(t+1) & = n_t L_t.
$

The technology function is increasing in both arguments: educated adults
generate more ideas, and a larger population means more potential inventors.
$n_t = 1$ means replacement fertility under this population normalization.
Each $t$ is a generation, not a year.

Parents take $z_t$ and $g_(t+1)$ as given when choosing $n_t$ and $e_(t+1)$.
Their children's education affects technological progress in $t + 2$.
Fixed land holds down income per adult as population expands, unless
technology and human capital grow fast enough to offset it.

#lecture-addition(
  "The population relevant for scale effects",
  source: "2026-10-13, 00:06:30 - 00:07:12; 00:22:37 - 00:23:43",
)[
  The relevant population is the network exchanging ideas. Small countries
  can use knowledge from abroad, so national population need not predict
  national technological progress. Kremer's historical comparisons concern
  connected and isolated populations. In a small isolated group, a skill
  can disappear when its few practitioners die.
]

=== From stagnation to modern growth

Conditional on a fixed $L$, the education-technology intersections satisfy
$
  e^* = e(g^*), quad g^* = g(e^*, L).
$
These are *conditional steady states* for $(e, g)$; technology levels and
population need not be constant along the full transition.

+ *Malthusian regime.* Small $L$ gives slow technological progress and
  $e = 0$, the unique stable conditional steady state. Technology gains
  mostly raise population; income per adult remains near subsistence.
  Population growth gradually raises $g(0, L)$.
+ *Post-Malthusian regime.* Larger $L$ accelerates technological progress.
  The diagram has multiple conditional steady states; the economy initially
  remains near the low-education one. Income per adult starts rising, but
  population growth still absorbs part of the output gain. While subsistence
  binds, higher income also raises the time available for children.
+ *Modern growth regime.* Once $g(0, L) > hat(g)$, zero education cannot
  remain optimal. Education and technological progress reinforce each other.
  Education per child rises, fertility falls, and income per adult grows
  persistently.

Rising population shifts the technology locus to the right in the lecture's
$(g, e)$ diagram. The low-education steady state eventually disappears.

=== Assessment

- Rising returns to education drive the demographic transition. Above
  subsistence, income alone leaves fertility unchanged at fixed education.
- The transition can occur without a large outside shock to human capital.
  It relies on the assumed population scale effect in technological progress.
- Technological progress is a reduced-form function of education and
  population. Structural change and institutions are outside these equations;
  the model is difficult to quantify against historical data.

#lecture-addition("Structural change and the demand for literacy", source: "2026-10-13, 00:15:31 - 00:16:25")[
  On a family farm, practical knowledge can pass directly from parents to
  children. Large organizations require bookkeeping, accounting and written
  instructions. Even a delivery driver needs to read addresses and
  instructions. Changing production organization can therefore raise the
  return to literacy and formal schooling.
]

== Dynamics of education and technology

Hold $L$ fixed within each panel:
- Blue solid curve: parents' education choice, $e = e(g)$.
- Orange dashed curve: technological progress, $g = g(e, L)$.
- Filled points are locally stable; hollow points are unstable.

An intersection is a conditional steady state. Education evolves according to
$
  e_(t+1) = e(g(e_t, L)).
$
At a positive-education intersection, the response to a small change in $e_t$ is
$
  frac(d e_(t+1), d e_t) = e'(g^*) g_(e)(e^*, L).
$
The steady state is locally stable if this response is below one, unstable if
it exceeds one. A larger population shifts the technology locus right;
the education-choice curve stays fixed.

=== Malthusian regime

#align(center)[

  #figure(
    image("figures/gw_malthusian.svg", width: 80%),
    caption: [Malthusian regime.],
  )<fig:gw-malthusian>
]
#figure-note[
  Redrawn schematic based on Lecture 5, slide 32, first overlay.
  $g_0 = g(0, L) < hat(g)$; education is zero.
  The technology locus is adjusted to give the unique intersection described
  in the slide's text. The curves are illustrative, not calibrated.
]

- Small population gives slow technological progress. The only conditional
  steady state is $(g_0, 0)$; small education increases die out.
- Technology can still raise population while education stays zero.
  As $L$ grows, the technology locus moves right.

=== Post-Malthusian regime

#align(center)[

  #figure(
    image("figures/gw_post_malthusian.svg", width: 80%),
    caption: [Post-Malthusian regime.],
  )<fig:gw-post-malthusian>
]
#figure-note[
  Redrawn schematic based on Lecture 5, slide 32, second overlay.
  $(g_u, e_u)$ is unstable; $(g_h, e_h)$ is the stable high-education state.
  The curves are illustrative, not calibrated.
]

- Three intersections: the zero-education and high-education states are
  stable; the middle state is unstable.
- At fixed $L$, $e_u$ separates the two basins of attraction. Below it,
  education returns to zero; above it, education approaches $e_h$.
- The economy can remain near the low state while population expands and
  technology accelerates. The threshold itself moves as $L$ changes.

=== Modern growth regime

#align(center)[

  #figure(
    image("figures/gw_modern.svg", width: 80%),
    caption: [Modern growth regime.],
  )<fig:gw-modern>
]
#figure-note[
  Redrawn schematic based on Lecture 5, slide 32, third overlay.
  The only intersection is $(g^*, e^*)$, with positive education.
  The curves are illustrative, not calibrated.
]

- With $g(0, L) > hat(g)$, zero education is no longer optimal. The low
  conditional steady state disappears; education moves toward $e^* > 0$.
- Faster technological change raises education; educated adults generate
  faster technological progress. Once subsistence is slack,
  $n_t = gamma/(tau^q + tau^e e_(t+1))$: more education lowers fertility.
- The population need not shrink when fertility falls. Income per adult
  grows as technology and human capital outpace the pressure on fixed land.

== The transition: other contributions

Lecture 5, slide 34.

- @kremer1993population: _more people generate more
  nonrival ideas; better technology supports a larger population under the
  Malthusian land constraint. The model predicts population growth increasing
  with population size over much of history. Historical population data and
  comparisons of technologically isolated societies support this scale effect._

- @jones2001industrial: _combines idea production,
  endogenous fertility and mortality, and fixed land. Under suitable returns
  to accumulable factors, population and ideas can generate a takeoff followed
  by a demographic transition. In the quantitative model, stronger rewards to
  inventors, interpreted as improvements in innovation-promoting institutions,
  substantially advance the takeoff. Its timing depends on these incentives._

- @galor2002selection: _preferences for child quality
  differ across heritable types. In the Malthusian regime, quality-oriented
  families can earn more and afford more children, giving their
  type an evolutionary advantage. Their growing population share raises
  investment in human capital and technological progress. The distribution
  of preferences therefore evolves within the model._

- @greenwood2002demographic: _a quantitative model of
  the U.S. demographic transition with agriculture and manufacturing.
  Productivity growth raises wages and the time cost of children. As
  agriculture contracts, parents increasingly educate children for skilled
  manufacturing work. Costly education favors fewer children; movement from
  high-fertility rural households to lower-fertility urban households also
  reduces aggregate fertility._

- @doepke2004fertility: _a quantitative transition model
  linking structural change, fertility, education, and child labor. Restricting
  child labor removes children's potential earnings, raising the net cost of
  having many children. In the calibrated model, child labor restrictions have
  much larger effects on fertility decline than education subsidies. Policies
  also affect the evolving income distribution._

- @galor2008trading: _trade changes the returns to child
  quantity and quality through specialization. Industrial economies specialize
  in goods intensive in human capital, encouraging education and lower
  fertility. Agricultural exporters face weaker incentives to educate and
  can have a delayed fertility transition. Trade can widen income and
  population-growth differences across countries._

== The transition: recent research

Lecture 5, slide 35.

=== Human capital and the Industrial Revolution

- @squicciarini2015human: _distinguishes average literacy
  from upper-tail knowledge. Subscriptions to the eighteenth-century
  Encyclopédie proxy the presence of knowledge elites in French cities.
  Subscriber density predicts growth after industrialization begins. Initial
  literacy is associated with development levels, but does not predict growth.
  The mechanism is higher productivity in innovative industrial technology._

- @delacroix2018clans: _emphasizes tacit knowledge
  passed from master to apprentice. Institutions determine who can learn
  from whom. Their model shows how guilds, journeymanship, and apprenticeship
  markets spread skills beyond closed family or clan networks, helping explain
  Europe's preindustrial technological advantage._

- @kelly2023mechanics: _studies English counties between
  the 1760s and 1830s. High initial mechanical skills and low wages predict
  industrialization. Literacy, banks, and proximity to coal have little
  explanatory power in their regressions._

=== Unified growth and cross-country evidence

@cervellati2023empirics

#emph[
  The model combines endogenous physical capital, human capital, population,
  and technology. Physical and human
  capital are complementary; technology diffuses internationally. A quantitative
  multi-country version matches several patterns of long-run growth and
  comparative development within the same model.

  Growth accelerates around the demographic transition and can temporarily
  exceed its eventual BGP rate as factors accumulate. The model also reproduces
  patterns in cross-country growth regressions using simulated panel data.
  Different transition dates help explain differences in income and growth
  across countries.
]

=== Demographic transitions across time and space

@delventhal2024demographic

#emph[
  The study covers birth and death rates for *186 countries over more than
  250 years* (CEMFI Working Paper 2402).
  The transition from high fertility and mortality to low fertility and
  mortality is completed or underway in nearly every country.

  - Later demographic transitions are faster.
  - Having more neighbors that have started the transition is associated with
    a higher probability of starting one's own transition.

  Their quantitative model combines parents' quantity-quality choices with
  the geographic diffusion of production and medical technologies from Great
  Britain. It matches the differing transition dates, increasing transition
  speeds, and the association between faster fertility decline and rising
  schooling.
]

#lecture-addition("What explains recent fertility declines?", source: "2026-10-13, 00:16:59 - 00:19:18")[
  - Rising schooling and declining child labor increase the cost of children
    relative to their earnings contribution.
  - Mothers' labor-force participation can raise the time cost of children.
    The lecture noted rapid fertility decline in several countries without
    the large participation increase seen during the Western transition.
  - Exposure to different family norms through modern media was suggested
    as a possible additional mechanism. This was an open hypothesis.
]

== From Solow to Lucas

Structural change and endogenous population growth can account for the
transition from Malthusian stagnation to Solow-style growth. We still need
to explain large, persistent differences in income per worker across countries.
Lecture 5, slides 36 to 37.

=== Predictions of the capital-only model

The lecture keeps Cobb-Douglas production as the benchmark:
$
                Y & = A K^alpha N^(1 - alpha), quad 0 < alpha < 1, \
  y := frac(Y, N) & = A (frac(K, N))^alpha, \
            "MPK" & = frac(partial Y, partial K)
                    = alpha A (frac(K, N))^(alpha - 1).
$
Here $A$ is *total factor productivity*. The labor-augmenting $A_t$ in the
earlier Solow section would enter this expression as $A_t^(1 - alpha)$.
Competitive factor income shares are $alpha$ and $1 - alpha$.

+ *Conditional convergence.* With the same productivity path, saving rate,
  population growth, and depreciation, countries below the common BGP grow
  faster through capital accumulation. Different fundamentals can instead
  imply different BGP targets. Controlling only for population growth does
  not establish a common target.
+ *Capital returns.* At a given $A$ and labor quality, lower $K/N$ raises
  MPK because $alpha - 1 < 0$. Explaining poverty entirely by low physical
  capital therefore predicts high capital returns in poor countries.

The lecture's puzzles are slow catch-up and persistent income gaps, together
with the absence of the very large return differences implied by capital
scarcity alone. Allowing different $A$ can fit income differences, but leaves
their source unexplained.

#lecture-addition("The capital-flow puzzle", source: "2026-10-13, 00:29:55 - 00:30:24")[
  If countries differ only in physical capital, high MPK should draw capital
  toward poor countries. The lecture contrasts this prediction with capital
  flows concentrated within and between rich countries. Explaining income
  gaps by physical-capital scarcity alone also has to explain these flows.
]

=== What can explain the income gaps?

- *Human capital:* workers differ in skills and productive knowledge,
  accumulated through education and learning. Omitting these inputs puts
  their contribution into measured TFP.
- *Endogenous productivity:* incentives to create and adopt ideas determine
  technological progress. R&D-based models are the next lecture's topic.
- *Misallocation:* frictions prevent labor and capital from reaching their
  most productive uses, reducing aggregate output for given resources.

_Human capital is an input that can be accumulated_ @lucas1988mechanics.
_With productive human capital $h$ per worker,_
$
      Y & = A K^alpha (h N)^(1 - alpha), \
  "MPK" & = alpha A (frac(K, h N))^(alpha - 1).
$
_The relevant scarcity is now $K/(h N)$. At a common $A$, increasing $K/N$
and $h$ by the same proportion raises income per worker by that proportion
while leaving MPK unchanged._

// END recording additions 2026-10-12

== Main idea of Lucas (1988)

_On the Mechanics of Economic Development_ @lucas1988mechanics.
Lecture 5, slides 38 to 40 use a simplified discrete-time planner problem
without human-capital externalities.

Human capital is a factor that can be accumulated. The worker divides
productive capacity between making goods and learning. Both technology
parameters, $A$ and $B$, are constant.

=== States, choices, and resources

- States: physical capital $k > 0$ and human capital $h > 0$.
  Population is fixed and normalized to one.
- Choices: consumption $c > 0$, next-period physical capital $k' >= 0$,
  and human-capital allocations $h_1, h_2 >= 0$.
- $h_1$ is used in goods production; $h_2$ is used in learning.
  They satisfy $h_1 + h_2 = h$.
- Next-period human capital is $h' = B h_2$, where $B > 0$ is learning
  productivity. This is the whole human-capital transition in this specification.

Preferences are CRRA:
$
  u(c) = cases(
    frac(c^(1 - sigma), 1 - sigma) & "if" sigma != 1,
    log c & "if" sigma = 1,
  ), quad sigma > 0.
$
Assume $0 < beta < 1$, $0 < alpha < 1$, $A > 0$, and $0 <= delta <= 1$.
Here $sigma$ is relative risk aversion.

=== Bellman equation

The social planner solves
$
  v(k, h) = max_(c, k', h_1, h_2)
  {u(c) + beta v(k', B h_2)}
$
subject to
$
  c + k' & <= (1 - delta) k + A k^alpha h_1^(1 - alpha), \
      h' & = B h_2, \
       h & = h_1 + h_2, \
       c & > 0, quad k', h_1, h_2 >= 0.
$
The goods constraint binds because utility is increasing in consumption.
More $h_1$ raises current output; more $h_2$ raises next period's productive
capacity.

#lecture-addition("Why exact linearity matters", source: "2026-10-13, 00:35:45 - 00:37:24")[
  Learning mainly uses learners' and teachers' time. In the EC442 example,
  forgone earnings are the main cost; classroom equipment is secondary.

  To see the role of *linearity*, hold the learning share $s = h_2/h$ fixed
  and compare a diminishing-returns technology:
  $
             h' & = B h_2^eta, quad 0 < eta < 1, \
    frac(h', h) & = B s^eta h^(eta - 1).
  $
  This growth factor falls as $h$ rises. The linear case $eta = 1$ preserves
  a constant return and permits sustained growth from human-capital accumulation.
]

=== Optimality conditions

Write goods production and its marginal products as
$
        f(k, h_1) & = A k^alpha h_1^(1 - alpha), \
    f_(k)(k, h_1) & = alpha A (frac(h_1, k))^(1 - alpha), \
  f_(h_1)(k, h_1) & = (1 - alpha) A (frac(k, h_1))^alpha.
$

Eliminating $h_2$ gives $h_1 = h - h'/B$. At an interior optimum, the FOCs
for $k'$ and $h'$ are
$
                  u'(c) & = beta v_(k)(k', h'), \
  u'(c) f_(h_1)(k, h_1) & = beta B v_(h)(k', h').
$
The second condition equates the output lost by shifting human capital into
learning with the discounted value of the human capital it creates.

The envelope conditions are
$
  v_(k)(k, h) & = u'(c) [1 - delta + f_(k)(k, h_1)], \
  v_(h)(k, h) & = u'(c) f_(h_1)(k, h_1).
$

Substitute next period's envelope conditions into the FOCs and use
$u'(c) = c^(-sigma)$:
$
  (frac(c', c))^sigma & = beta [1 - delta
                          + alpha A (frac(h'_1, k'))^(1 - alpha)], \
  (frac(c', c))^sigma & = beta B
                        (frac(k', h'_1))^alpha (frac(h_1, k))^alpha.
$
Here $c'$ and $h'_1$ are next period's consumption and production allocation.
The first equation governs physical investment; the second governs learning.
The learning return includes the change in human capital's marginal product.

=== Balanced growth path

On a BGP, allocation shares and capital ratios are constant:

$
  gamma = frac(c', c) = frac(k', k) = frac(h', h) = frac(h'_1, h_1).
$
Here $gamma$ is the *gross growth factor*; net growth is $gamma - 1$.
In the learning Euler equation, the two capital-ratio terms cancel:
$
  gamma^sigma & = beta B gamma^alpha gamma^(-alpha) = beta B, \
        gamma & = (beta B)^(1/sigma).
$
Sustained positive growth requires $beta B > 1$.

Let $r^K = f_(k)(k, h_1)$ be the capital rental rate, written as $r$ on
slide 40. The physical-capital Euler equation implies
$
      gamma^sigma & = beta (1 - delta + r^K), \
              r^K & = B - 1 + delta, \
  1 - delta + r^K & = B.
$
The gross return to holding physical capital equals $B$; its net return is
$r^K - delta = B - 1$. The rental rate itself includes depreciation compensation.

Human-capital accumulation fixes the allocation shares:
$
  frac(h_2, h) & = frac(gamma, B), \
  frac(h_1, h) & = 1 - frac(gamma, B).
$
An interior growing BGP requires $gamma < B$, leaving human capital for goods
production. For $sigma != 1$, this is also the finite-utility condition along
the BGP:
$
  beta gamma^(1 - sigma) = frac(gamma, B) < 1.
$
With log utility, $gamma = beta B$ and $h_2/h = beta$.

The constant physical-to-productive-human-capital ratio satisfies
$
  frac(k, h_1) & = (frac(alpha A, B - 1 + delta))^(1/(1 - alpha)), \
    frac(k, h) & = (1 - frac(gamma, B))
                 (frac(alpha A, B - 1 + delta))^(1/(1 - alpha)).
$
These ratios require $B - 1 + delta > 0$, which holds on a growing BGP.

=== Growth and income differences

- Growth is *endogenous*: $k$ and $h$ accumulate while $A$ and $B$ stay fixed.
  The growth factor depends on learning productivity, patience, and preferences.
- Along the BGP, higher $A$ changes capital ratios and income levels, but
  drops out of $gamma = (beta B)^(1/sigma)$.
- With common parameters, countries can have different income levels on
  parallel BGPs. Proportional differences in $k$ and $h$ leave $k/h$, $gamma$,
  and $r^K$ unchanged.
- For a given human-capital path, a low initial $k/h$ creates transitional
  capital deepening, as in Solow. Persistent human-capital gaps can instead
  sustain different income levels.

#lecture-addition("Postwar catch-up", source: "2026-10-13, 00:42:06 - 00:43:15")[
  Germany and Japan in 1946 illustrate physical-capital destruction with
  much of the workforce's knowledge intact. A low $k/h$ then predicts
  rebuilding and catch-up, conditional on the human-capital path.
  Countries with persistent skill gaps can instead remain on parallel BGPs.
]

== How much does human capital explain? Development accounting

*Development accounting* decomposes cross-country differences in real GDP
per worker into inputs and productivity. Lecture 5, slide 42.

=== Output per worker

For country $i$, let $N_i$ be the number of workers and $h_i$ human capital
per worker. Write Hicks-neutral TFP as $T_i$, previously denoted by $A$,
and use a common capital share $0 < alpha < 1$:
$
                    Y_i & = T_i K_i^alpha (h_i N_i)^(1 - alpha), \
  y_i := frac(Y_i, N_i) & = T_i (frac(K_i, N_i))^alpha h_i^(1 - alpha).
$
Substitute $K_i/N_i = (K_i/Y_i) y_i$ and solve for $y_i$:
$
  y_i^(1 - alpha) & = T_i (frac(K_i, Y_i))^alpha h_i^(1 - alpha), \
              y_i & = underbrace((frac(K_i, Y_i))^(alpha/(1 - alpha)), "capital intensity")
                    quad underbrace(h_i, "human capital")
                    quad underbrace(T_i^(1/(1 - alpha)), "productivity").
$
The slide calls $T_i^(1/(1 - alpha))$ simply $A_i$. Define
$
  x_(K,i) := (frac(K_i, Y_i))^(alpha/(1 - alpha)), quad
  A_i := T_i^(1/(1 - alpha)).
$
Then $y_i = x_(K,i) h_i A_i$.

- Measure $y_i$ and $K_i/Y_i$; construct $h_i$ from worker characteristics.
- Back out productivity as the *residual*: $A_i = y_i/(x_(K,i) h_i)$.
- At fixed $K_i/Y_i$ and $h_i$, higher $T_i$ raises output and capital per
  worker. This decomposition assigns both effects to productivity.

=== Each factor's contribution

@klenow1997neoclassical: _assign each factor its covariance with log income,
relative to the total variance of log income._

Taking logs gives
$
  log y_i = log x_(K,i) + log h_i + log A_i.
$
For $x_i in {x_(K,i), h_i, A_i}$, define
$
  "share"_x := frac(
    op("cov")(log x_i, log y_i),
    op("var")(log y_i),
  ).
$
Covary the log identity with $log y_i$:
$
                 op("var")(log y_i) & = op("cov")(log x_(K,i), log y_i)
                                      + op("cov")(log h_i, log y_i) \
                                    & quad + op("cov")(log A_i, log y_i), \
  "share"_K + "share"_h + "share"_A & = 1.
$
The capital contribution uses $log x_(K,i) = alpha/(1 - alpha) log(K_i/Y_i)$,
so it includes the production elasticity. These are *accounting shares*;
they can be negative or exceed one and do not identify causal effects.

=== Classic human-capital measure

The lecture uses a schooling-based measure:
$
  h_i = exp(0.1 S_i), quad log h_i = 0.1 S_i,
$
where $S_i$ is average years of schooling. One extra year raises measured
human capital by $exp(0.1) - 1 approx 10.5%$.

- The coefficient $0.1$ comes from the log-wage return to schooling.
  Interpreting wages as proportional to human capital links this return to $h_i$.
- The same return is used across countries. School quality, experience,
  and health are omitted from this measure.

#lecture-addition("From wage returns to productive human capital", source: "2026-10-13, 00:46:29 - 00:46:52")[
  The calculation assumes that schooling-related pay differences reflect
  productivity. A wage return from signaling need not raise aggregate output.
  Individual wage returns also need not remain unchanged when the supply
  of educated workers increases.
]

@caselli2005accounting: _classic development accounting leaves large
productivity differences after measuring physical capital and schooling-based
human capital. The residual also absorbs omitted input quality and
measurement error._

== Development accounting revisited: Lagakos and Schoellman (2026)

Lecture 5, slides 43 to 44.

@lagakos2026accounting: _better measurement raises the contribution of
inputs from about 30% under the classic specification to 55–70%, mainly
through human capital. The paper is forthcoming in the JEL._

=== The classic residual

With schooling-only $h_i = exp(0.1 S_i)$, the capital-output specification
still assigns about *70%* of cross-country income variation to $A_i$.
The residual is much lower in poor countries than in the U.S.

#align(center)[

  #figure(
    image("figures/development_tfp.svg", width: 75%),
    caption: [Productivity in the classic specification.],
  )<fig:development-tfp>
]
#figure-note[
  $A_i/A_("US")$: productivity residual, U.S. normalized to one;
  $y_i$: real GDP per worker in thousands of PPP dollars. Both axes are
  logarithmic. Vector crop from Lecture 5, slide 43, based on
  @lagakos2026accounting; axis notation added.
]

Allow hours worked per worker, $ell_i$, to enter separately:
$
  y_i = x_(K,i) h_i ell_i A_i,
  quad x_(K,i) = (frac(K_i, Y_i))^(alpha/(1 - alpha)).
$
The covariance contributions then satisfy
$
  "share"_("inputs") & = "share"_K + "share"_h + "share"_ell, \
           "share"_A & = 1 - "share"_("inputs").
$

- *Hours:* about $-5%$. Poor-country workers work longer hours, so hours
  offset part of the income gap; they do not account for low output per worker.
- *Physical capital:* about $7%$ in this specification. Better measurement
  changes this contribution little.
- *Human capital:* about $58–66%$ across the approaches discussed. The
  preferred overall input range is $55–70%$ across specifications and assumptions.

=== More dimensions of human capital

Schooling quantity alone misses school quality, experience and health.
The lecture's quality adjustment is
$
  h_i^("school") = exp(0.1 S_i + 0.2 Q_i),
$
where $Q_i$ is a standardized test score, in standard-deviation units.
At fixed $S_i$, one extra standard deviation raises this index by
$exp(0.2) - 1 approx 22.1%$.

#table(
  columns: (2fr, 1fr),
  inset: 6pt,
  stroke: 0.4pt + luma(80%),
  table.header([Human-capital measure], [Reported contribution]),
  [Years of schooling], [23%],
  [Schooling plus test-score quality], [37%],
  [Experience alone], [15%],
  [Health, proxied by height], [10%],
  [Joint human-capital measure], [66%],
)

_These are the rounded figures in slide 44. The quality row already includes
schooling. Component measures have different country coverage; the joint
estimate is not the sum of these displayed rows._

- Experience human capital reflects both years worked and what workers learn
  on the job. Wage-experience profiles are steeper in richer countries.
- Height proxies childhood nutrition and health, which affect adult productivity.
- Test scores capture learning from schools and other environments; they are
  not a measure of school inputs alone.

#lecture-addition("Experience and demography", source: "2026-10-13, 00:50:38 - 00:51:10")[
  Lower fertility and slower population growth produce an older workforce
  with more years of experience. Cross-country experience gaps therefore
  reflect demographic composition as well as differences in learning on the job.
]

#align(center)[

  #figure(
    image("figures/development_human_capital.svg", width: 75%),
    caption: [Human capital with broader measurement.],
  )<fig:development-human-capital>
]
#figure-note[
  $h_i$: constructed human-capital index per worker (efficiency units);
  $y_i$: real GDP per worker in thousands of PPP dollars. Both axes are
  logarithmic. Vector crop from Lecture 5, slide 44, based on
  @lagakos2026accounting; axis notation added.
]

@manuelli2014human: _a structural human-capital model uses schooling and
life-cycle earnings profiles to infer human-capital quantities and quality.
It finds larger human-capital gaps and smaller TFP gaps than classic measures._

For given $y_i$ and $x_(K,i)$, increasing measured $h_i ell_i$ lowers the
inferred $A_i = y_i/(x_(K,i) h_i ell_i)$. This is a change in measurement
and attribution; it does not mean a country's actual technology has changed.

== Evidence from migrants

Lecture 5, slide 45.

@hendricks2018human: _compare real, PPP-adjusted hourly wages of the same
immigrants before and after moving to the U.S. The main data source is the
New Immigrant Survey of new U.S. permanent residents._

=== What changes when a worker moves?

The migrant carries *human capital* $h_m$. The destination supplies its own
capital intensity and productivity. In the benchmark, labor markets are
competitive, workers are perfect substitutes, the capital share is common,
and working hours and the migrant's human capital are held fixed.

Let $q_i$ be the wage per unit of human capital in country $i$. From
$y_i = x_(K,i) h_i A_i$,
$
      q_i & = (1 - alpha) x_(K,i) A_i, \
  w_(m,i) & = q_i h_m.
$
The same person's human capital cancels from the wage ratio:
$
  G_i := frac(w_(m,"US"), w_(m,i))
  = frac(q_("US"), q_i).
$
Thus *wage gains identify the country component*, combining capital intensity
and productivity, under these assumptions.

=== From wage gains to the human-capital contribution

Define the income and human-capital gaps as
$
  D_i := frac(y_("US"), y_i), quad
  H_i := frac(h_("US"), h_i).
$
With a common $alpha$,
$
                      D_i & = G_i H_i, \
                  log D_i & = log G_i + log H_i, \
  "share"_h^("migration") & = frac(log H_i, log D_i)
                            = 1 - frac(log G_i, log D_i).
$
This is a *log-gap decomposition* relative to the U.S.; the previous section's
covariance shares summarize variation across the whole country sample.

For the poorest origin-country group in the lecture, $G_i = 3.2$ and
$D_i = 31.8$:
$
                      H_i & = frac(31.8, 3.2) approx 9.94, \
  "share"_h^("migration") & = 1 - frac(log 3.2, log 31.8) approx 66%.
$
A threefold wage gain is large for the migrant, but small relative to the
thirtyfold income gap. About two-thirds of this group's *log income gap*
is attributed to human capital in the benchmark.

#align(center)[

  #figure(
    image("figures/migrant_wage_gains.svg", width: 75%),
    caption: [Migrant wage gains and income gaps.],
  )<fig:migrant-wage-gains>
]
#figure-note[
  Origin-country bins use $y_i/y_("US")$. Bars show the income gap $D_i$,
  wage gain $G_i$, and inferred human-capital gap $H_i = D_i/G_i$; all are
  U.S.-to-origin multiples on a logarithmic vertical scale.
  Cropped from Lecture 5, slide 45. Source: @lagakos2026accounting
  (JEL, forthcoming), based on @hendricks2018human.
]

=== Selection and skill transfer

- *Selection:* migrants need not represent their origin country's average
  worker. Comparing the same person before and after migration cancels $h_m$
  even when migrants are highly selected. Comparing only migrants' U.S. wages
  across origins does not remove this selection.
- *Skill transfer:* language barriers, unrecognized credentials, or occupational
  downgrading can reduce effective $h_m$ after migration. Then $G_i$ understates
  the country component and the formula overstates human capital's contribution.
- *Different skill returns:* wage gains vary with education. Allowing imperfect
  substitution across skill types gives a human-capital contribution between
  one-half and two-thirds in the paper, with a benchmark estimate around 60%.
  The lecture's 66% is the poorest-group calculation, not the full-sample estimate.

== Skilled versus unskilled labor

Lecture 5, slide 46.

@rossi2022efficiency: _skilled workers are relatively scarce in poor countries,
but their wage premium is not correspondingly higher. Matching quantities
and wages requires large differences in relative skill efficiency; migrant
evidence attributes most of these differences to skill-biased technology._

=== CES labor input and the skill premium

For skill group $j in {u, s}$, let $N_(j,i)$ be workers and $h_(j,i)$ human
capital per worker. Effective labor is $L_(j,i) = N_(j,i) h_(j,i)$.
The labor aggregate is

$
  L_i = (z_(u,i) L_(u,i)^((sigma - 1)/sigma)
    + z_(s,i) L_(s,i)^((sigma - 1)/sigma))^(sigma/(sigma - 1)).
$
Here $z_(j,i) > 0$ are technology weights; $sigma$ is the *elasticity of
substitution*, distinct from the CRRA parameter used earlier. The displayed
formula uses $sigma > 1$; the lecture's benchmark is $sigma = 1.5$.
A Cobb-Douglas limit at $sigma = 1$ requires normalized CES weights.

With competitive factor pricing, the common marginal product of aggregate
labor cancels from the wage ratio per efficiency unit:
$
  frac(w_(s,i)^e, w_(u,i)^e)
  = frac(z_(s,i), z_(u,i)) (frac(L_(s,i), L_(u,i)))^(-1/sigma).
$
Observed pay per worker includes each group's human capital,
$W_(j,i) = w_(j,i)^e h_(j,i)$. Thus the *skill premium* is
$
  omega_i := frac(W_(s,i), W_(u,i))
  = frac(z_(s,i), z_(u,i))
  (frac(h_(s,i), h_(u,i)))^((sigma - 1)/sigma)
  (frac(N_(s,i), N_(u,i)))^(-1/sigma).
$
Define *relative skill efficiency*
$
  R_i := frac(z_(s,i), z_(u,i))
  (frac(h_(s,i), h_(u,i)))^((sigma - 1)/sigma).
$
Solving the wage-premium equation gives
$
  R_i = omega_i (frac(N_(s,i), N_(u,i)))^(1/sigma).
$
If $omega_i$ varies little, greater relative skill supply in rich countries
requires higher $R_i$. The lecture's calculation at $sigma = 1.5$ implies
roughly a sixteenfold rich-poor difference.

#align(center)[

  #figure(
    image("figures/relative_skill_efficiency.svg", width: 75%),
    caption: [Relative efficiency of skilled labor.],
  )<fig:relative-skill-efficiency>
]
#figure-note[
  $R_i/R_("US")$: relative skill efficiency, U.S. normalized to one;
  $y_i$: real GDP per worker in thousands of PPP dollars. Both axes are
  logarithmic. Calculations use $sigma = 1.5$. Vector crop from Lecture 5,
  slide 46; source: @lagakos2026accounting and @rossi2022efficiency.
]

=== Technology versus human capital

The observed premium and worker counts identify $R_i$, but cannot separately
identify $z_(s,i)/z_(u,i)$ and $h_(s,i)/h_(u,i)$. Comparing foreign-educated
workers in one destination holds destination technology fixed. Their returns
to schooling provide additional information about human-capital quality,
subject to selection and skill-transfer assumptions.

*The CES labor aggregate combines skills and technology.* Its accounting
contribution therefore includes skill bias. In the review's illustrative
calculation, the contribution of $L_i/N_i$ depends strongly on $sigma$:

#table(
  columns: (1fr, 2fr),
  inset: 6pt,
  stroke: 0.4pt + luma(80%),
  table.header([Elasticity $sigma$], [Accounting contribution of $L_i/N_i$]),
  [1.2], [100.1%],
  [1.5], [51.7%],
  [2.0], [35.6%],
)

@lagakos2026accounting, Table 7: _the calculation normalizes unskilled
technology and human capital to one and omits experience and health.
The share above 100% is permitted by the covariance metric._

== Human capital and the allocation of talent

Lecture 5, slide 47.

@hsieh2019talent: _in 1960, 94% of U.S. doctors and lawyers were white men;
by 2010, 62% were. A Roy model links changing occupational choices to declining
barriers and estimates that better allocation accounts for 20–40% of growth
in aggregate market output per person over 1960–2010._

Individuals differ in their comparative advantage across occupations.
Their choices also depend on group-specific forces:
- Labor-market discrimination lowers pay relative to marginal product.
- Barriers to acquiring human capital raise the cost of training for an occupation.
- Preferences and social norms affect the utility of market and home occupations.

The model assumes that relative distributions of innate talent across groups
are stable over time. Human-capital barriers act through cohort investments;
labor-market discrimination affects workers of different cohorts at a given date.
Life-cycle wages and occupational shares help distinguish these forces.

Lower barriers let more people enter occupations where their talents are
productive and change incentives to acquire skills. Misallocation can therefore
lower output even with substantial measured human capital, appearing in the
TFP residual. The reported gains concern *market output*; welfare also depends
on occupational preferences and home production.

#lecture-addition("Firm-size barriers and misallocation", source: "2026-10-13, 00:57:57 - 00:59:13")[
  Expanding a business may trigger taxes or compliance costs that can be
  avoided by staying small. Productive firms then remain undersized, while
  inputs stay in firms with lower marginal returns. Output falls for given
  aggregate capital and skills, appearing as lower measured productivity.
]

== Human capital and ideas

Lecture 5, slide 49.

The lecture's simplified Lucas model has linear private human-capital
accumulation. Learning from other people adds an aggregate object: the
*distribution of knowledge*. Human capital is embodied in workers; an idea
can be used by many workers simultaneously.

- @lucasmoll2014knowledge: _people divide time between producing with their
  current knowledge and meeting others to learn better ideas. The individual
  state is productivity $z$; the aggregate state is its distribution $F_t$.
  Search choices change knowledge diffusion and generate endogenous growth.
  A planner also accounts for the external benefits of learning._
- @lucas2015human: _learning is faster when people interact with more productive
  people. The model connects individual earnings profiles to aggregate growth._
- @delacroix2018clans: _apprenticeship institutions determine who learns from
  whom. Knowledge spreads farther when training extends beyond family networks._

#lecture-addition("Learning from different people", source: "2026-10-13, 01:08:49 - 01:12:23")[
  Relatives trained by the same masters may hold similar knowledge.
  Journeymanship exposes apprentices to different masters and ideas,
  widening the opportunities to learn.

  The modern example is a bank adopting AI by hiring workers who already
  use it. Knowledge moves between firms with people. The lecture described
  LinkedIn career histories as data for relating worker flows to technology
  adoption; no causal identification strategy was discussed.
]
// END recording additions 2026-10-13

=== From learning to innovation

- @romer1990technological: _ideas are nonrival and partly excludable. Profit
  incentives finance research; monopoly rights can reward innovation. The
  resulting increasing returns require a departure from pure price taking._
- @jones2022end: _in idea-based models, a persistently declining population can
  eventually stop growth in living standards. The number of potential inventors
  and the demographic response therefore matter for long-run growth._

== Summary and outlook

Lecture 5, slides 48 and 50.

- The historical transition combines movement away from fixed-land production,
  a demographic transition and faster productivity growth. Human-capital
  investment links fertility choices to technological progress.
- Modern measurement and migrant evidence assign roughly three-fifths of
  cross-country income differences to human capital in the exercises discussed.
  Schooling-only measures in @halljones1999output assigned about one-fifth.
  These figures depend on the sample, production function and accounting metric.
- Development accounting locates gaps in inputs and productivity. It does not
  identify why countries accumulated different skills or which policy would
  close the gaps. Skill-biased technology also complicates the boundary between
  human capital and TFP.
- Growth models give mechanisms for accumulation, learning and the transition.
  Institutions shape investment and innovation incentives. The next lecture
  turns to the creation of ideas and endogenous productivity growth.

= Lecture 6 Oct 19

== Endogenous productivity

Physical and human capital explain part of cross-country income differences.
We also need to explain *productivity differences* across countries and
*productivity growth* over time.

Sources of productivity gains:
- R&D creates new goods or improves existing ones.
- Technology diffusion spreads ideas and production methods across firms
  and countries.
- Better allocation moves labor and capital toward more productive uses,
  raising output for given aggregate inputs.

This lecture focuses on *R&D-based growth*:
- @romer1990technological: _growth through an expanding variety of
  intermediate goods._
- @aghion1992creative: _growth through quality improvements. New innovations
  displace older technologies and their producers: creative destruction._

#lecture-addition("Institutions and accumulation", source: "2026-10-19, 00:02:13 - 00:04:19")[
  Explaining why human-capital stocks differ requires a further causal
  theory. The lecturer pointed to institutions, while emphasizing that
  this literature has no single canonical model comparable to the growth
  models studied here.
]

== @romer1990technological: Expanding varieties

=== Main idea

Ideas are *nonrival*: using a blueprint does not prevent others from using
it at the same time. Producing the physical good still uses resources.

- Inventing a blueprint requires a *fixed R&D cost*. Once the idea exists,
  it can be reused without repeating that cost.
- With unrestricted imitation and competitive pricing, innovators may earn
  too little profit to recover the R&D cost. Useful inventions need not be
  privately profitable.
- Patents make ideas *partly excludable*: the patent holder can restrict
  others' use of the invention. In the model, each patent gives a monopoly
  over one intermediate-good variety.
- Monopoly profits reward innovation. Firms invest in R&D when the
  expected value of these profits covers the cost of inventing a new variety.

R&D expands the range of intermediate goods. More varieties raise output
for given aggregate inputs, linking productivity growth to firms' innovation
incentives.

#lecture-addition(
  "Access to ideas and research funding",
  source: "2026-10-19, 00:08:42 - 00:10:39; 00:17:28 - 00:18:16",
)[
  Public funding of universities and research grants can finance invention
  directly. Imitation delays can also create temporary first-mover rents:
  copying an idea and building production capacity take time.

  A patent can disclose the blueprint publicly while giving its owner
  exclusive commercial rights. *Nonrivalry* and *excludability* describe
  different properties of an idea.
]

=== Environment

Time is discrete. The final good is the numeraire and can be consumed,
used to produce intermediates, or spent on R&D.

A competitive final-goods sector combines labor and a continuum of
intermediate varieties:
$
  Y_t = A L^(1 - alpha) integral_0^(N_t) X_(i t)^alpha dif i,
  quad A > 0, quad 0 < alpha < 1.
$
- $L > 0$: constant labor supply.
- $N_t$: measure of varieties available at the start of period $t$.
- $X_(i t) >= 0$: quantity of intermediate $i$ used in production.
- $A$: constant technology parameter. Innovation increases $N_t$.

One unit of the final good produces one unit of any existing intermediate,
so *marginal cost is one*. Intermediates are used up within the period.
Each variety is supplied by a monopolist holding a _permanent patent_.

Inventing one new variety costs $eta > 0$ units of the final good. With R&D
spending $R_t >= 0$,
$
  N_(t+1) = N_t + frac(R_t, eta).
$
*Timing:* varieties invented in $t$ become available for production in
$t + 1$. Existing varieties remain available; blueprints accumulate.

The aggregate resource constraint is
$
  Y_t = underbrace(C_t, "consumption")
  + underbrace(integral_0^(N_t) X_(i t) dif i, "intermediate production")
  + underbrace(R_t, "R&D"),
$
where $C_t >= 0$ is aggregate consumption. R&D uses goods today to expand
tomorrow's production possibilities.

#lecture-addition("Varieties and production timing", source: "2026-10-19, 00:19:39 - 00:23:31; 00:26:17 - 00:27:21")[
  - Differentiated final goods can generate gains from variety in
    consumption, providing another application of the variety mechanism.
  - An integer number of varieties would make changes in $N_t$ discrete.
    The continuum permits smooth variety expansion.
  - Final goods and intermediates are produced simultaneously within the
    period. Producing intermediates today for use tomorrow would add
    inventories as state variables.
]

=== Growth through expanding varieties

With symmetric quantities, $X_(i t) = X_t$ for all $i$. Define total
intermediate use as $M_t$:
$
  M_t & = integral_0^(N_t) X_(i t) dif i = N_t X_t, \
  Y_t & = A L^(1 - alpha) N_t X_t^alpha \
      & = A L^(1 - alpha) M_t^alpha N_t^(1 - alpha).
$
- At fixed $L$ and $M_t$, *more varieties raise output* because
  $1 - alpha > 0$. Each variety has diminishing returns; spreading a given
  total input across more varieties raises production.
- At fixed $L$ and quantity per variety $X_t$, output is *linear in $N_t$*.
  Variety expansion can sustain growth without increasing $A$.
- Old varieties remain in use: this model has *no creative destruction*.

#lecture-addition("Output exhaustion under competitive factor pricing", source: "2026-10-19, 00:16:45 - 00:17:27")[
  In the symmetric representation, write $Y = F(L, M, N)$. Then
  $
    L F_L + M F_M & = Y, \
            N F_N & = (1 - alpha) Y > 0.
  $
  Paying labor and physical inputs their marginal products already
  exhausts output. Paying knowledge its positive marginal product as well
  would require payments exceeding output.
]

=== Problem of the final-goods firm

The representative final-goods firm takes wage $w_t$ and intermediate
prices $P_(i t)$ as given. Write its labor demand as $ell_t$; labor-market
clearing requires $ell_t = L$.

Each period it chooses nonnegative inputs to solve
$
  max_(ell_t, {X_(i t)}) [
    A ell_t^(1 - alpha) integral_0^(N_t) X_(i t)^alpha dif i
    - w_t ell_t - integral_0^(N_t) P_(i t) X_(i t) dif i
  ].
$
The interior FOCs, evaluated at $ell_t = L$, are
$
      w_t & = (1 - alpha) frac(Y_t, L), \
  P_(i t) & = A alpha L^(1 - alpha) X_(i t)^(alpha - 1)
            = A alpha (frac(L, X_(i t)))^(1 - alpha).
$
Each input is paid its *marginal product*. Solving the second FOC gives
the demand faced by intermediate producer $i$:
$
  X_(i t) = L (frac(A alpha, P_(i t)))^(1/(1 - alpha)).
$
Demand has constant price elasticity $-1/(1 - alpha)$. For given $N_t$,
constant returns and price taking imply zero final-goods profits.

=== Problem of an intermediate-goods firm

Each firm holds a permanent patent on one variety and has marginal cost
one. The initial R&D cost is sunk. Pricing is *static*: today's price does
not affect future demand.

Let $epsilon = 1/(1 - alpha) > 1$ be the absolute demand elasticity.
The firm chooses its price to maximize operating profit:
$
  max_(P > 0) (P - 1) X(P),
  quad X(P) = L (frac(A alpha, P))^epsilon.
$
Since $X'(P) = -epsilon X(P)/P$, the FOC gives
$
  1 - epsilon frac(P - 1, P) & = 0, \
                           P & = frac(epsilon, epsilon - 1)
                               = frac(1, alpha) > 1.
$
The price is a *constant markup* over marginal cost. Quantity and
per-period operating profit are
$
   X & = L (A alpha^2)^(1/(1 - alpha)), \
  pi & = (P - 1) X
       = frac(1 - alpha, alpha) L (A alpha^2)^(1/(1 - alpha)).
$
With $A$, $L$ and $alpha$ constant, $P$, $X$ and $pi$ are constant across
varieties and over time. These profits exclude the initial R&D outlay.

Hold $N_t$ fixed. Efficient production uses each intermediate until its
marginal product falls to its production cost of one:

$
           X^* & = L (A alpha)^(1/(1 - alpha)), \
  frac(X, X^*) & = alpha^(1/(1 - alpha)) < 1.
$<eq:611>

The second line of @eq:611 shows that the monopoly markup leaves each
variety's quantity below the efficient level $X^*$, holding $N_t$ fixed.

=== Value of a patent and free entry

A patent created in $t$ earns $pi$ each period from $t + 1$ onward.
With a constant net interest rate $r > 0$, its value at $t$ is
$
  V & = sum_(s=1)^infinity frac(pi, (1 + r)^s) \
    & = pi frac(1/(1 + r), 1 - 1/(1 + r))
      = frac(pi, r).
$
Inventing a patent costs $eta$, so net entry profit is $V - eta$.
- If $V > eta$, the linear R&D technology implies unbounded desired entry
  at those prices. This cannot be an equilibrium.
- If $V < eta$, no firm invests in R&D.
- With positive R&D, *free entry* requires $V = eta$. Net entry profit is
  zero, while the patent continues to earn positive operating profits $pi$.

The equilibrium conditions allow zero R&D even when $V = eta$:
$
  V <= eta, quad R_t >= 0, quad (eta - V) R_t = 0.
$
With *positive innovation*, $V = eta = pi/r$, hence
$
  r = frac(pi, eta)
  = frac(1 - alpha, alpha) frac(L, eta)
  (A alpha^2)^(1/(1 - alpha)).
$

=== The household

The representative household supplies $L$ inelastically and owns claims on
patents. It takes wages and asset returns as given. Given $a_0$, its problem is
$
  max_({c_t, a_(t+1)}) sum_(t=0)^infinity beta^t u(c_t),
  quad beta = frac(1, 1 + rho),
$
with $rho > 0$ and CRRA utility for $c > 0$:
$
  u(c) = cases(
    frac(c^(1 - sigma), 1 - sigma) & "if" sigma != 1,
    log c & "if" sigma = 1,
  ), quad sigma > 0.
$
Here $rho$ is the rate of time preference and $1/sigma$ is the intertemporal
elasticity of substitution. With one representative household, $c_t = C_t$.

The household faces a no-Ponzi condition and the budget constraint
$
  c_t + a_(t+1) = (1 + r_t) a_t + w_t L.
$
Assets $a_t$ were chosen in $t - 1$
and earn the return $r_t$ in period $t$; saving $a_(t+1)$ earns $r_(t+1)$.

A patent bought for $V_t$ at the end of $t$ pays $pi$ and can be resold
for $V_(t+1)$ next period. Its *total return* includes both profits and
capital gains:
$
  1 + r_(t+1) = frac(pi + V_(t+1), V_t).
$
When the patent value is constant, $1 + r = (pi + V)/V$.
Patent profits are already included in the asset return in the budget.

At an interior optimum, saving equates the marginal utility cost today
to the discounted marginal utility of its payoff:

$
                     u'(c_t) & = beta (1 + r_(t+1)) u'(c_(t+1)), \
  (frac(c_(t+1), c_t))^sigma & = beta (1 + r_(t+1)).
$

=== Equilibrium growth

With *positive innovation*, free entry fixes $V = eta$ and $r = pi/eta$.
Substituting this return into the household Euler equation gives
$
  1 + g := frac(C_(t+1), C_t) & = [beta (1 + r)]^(1/sigma) \
                              & = (frac(1 + pi/eta, 1 + rho))^(1/sigma).
$<eq:romer-growth>
Positive growth requires $r > rho$. If $pi/eta <= rho$, the stationary
corner has $R_t = 0$,
$r = rho$ and $V = pi/rho <= eta$.

On the positive-innovation path, *asset-market clearing* and *goods-market
clearing* require
$
  a_(t+1) & = V_t N_(t+1) = eta N_(t+1), \
      Y_t & = C_t + N_t X + eta (N_(t+1) - N_t).
$
End-of-period assets include new patents, whose first profits arrive in $t + 1$.

On the BGP, $N_(t+1) = (1 + g) N_t$. With $A$ and $X$ constant, output,
consumption and R&D grow at rate $g$:
$
  frac(Y_t, N_t) & = A L^(1 - alpha) X^alpha, \
  frac(R_t, N_t) & = eta g, \
  frac(C_t, N_t) & = A L^(1 - alpha) X^alpha - X - eta g > 0.
$

#lecture-addition("Why indifference still determines aggregate R&D", source: "2026-10-19, 00:43:19 - 00:46:21")[
  Free entry leaves each potential entrant indifferent. A higher proposed
  BGP entry rate raises consumption growth. The Euler equation would then
  require a higher $r$, but this would lower $V = pi/r$ below the invention
  cost $eta$. Household saving and goods-market clearing select the
  aggregate entry mass.

  An extension with research labor and heterogeneous tastes for innovating
  could yield a smooth aggregate supply of innovation.
]

#lecture-addition("Why there is no transition in this model", source: "2026-10-19, 00:47:17 - 00:47:40")[
  The only aggregate production state is $N_t$. Its initial level scales
  allocations while leaving $pi$, $r$ and $g$ unchanged. In the growing
  equilibrium, consumption adjusts immediately to its BGP level relative
  to $N_0$.
]

Since assets grow at rate $g$, household transversality requires

$
  beta (1 + g)^(1 - sigma)
  = frac(1 + g, 1 + r) < 1
  quad <=> quad g < r.
$

#align(center)[
  #figure(
    image("figures/romer_equilibrium.svg", width: 85%),
    caption: [Equilibrium growth.],
  )<fig:romer-equilibrium>
]

#figure-note[
  Log-utility schematic ($sigma = 1$), redrawn from Lecture 6, slide 11.
  *Free entry* fixes the return on R&D at $r = pi/eta$.
  The *Euler equation*, $r = (1 + rho) (1 + g)^sigma - 1$, maps this return
  into consumption growth $g_"eq"$ at the intersection.
]

=== Determinants of growth

From @eq:romer-growth, holding other parameters fixed:
- *Higher productivity $A$* raises patent profits and growth.
- *A larger economy $L$* raises profits and growth through a larger market
  (_scale effect_).
- *A higher innovation cost $eta$* lowers the return $r = pi/eta$ and growth.
- *Greater impatience $rho$* lowers saving and growth at a given return.

#lecture-addition(
  "Scale and the market for one variety",
  source: "2026-10-19, 00:39:18 - 00:42:28; 01:16:01 - 01:17:25",
)[
  Increasing $L$ expands the market for each variety. Increasing $N_t$
  adds varieties at unchanged demand per variety, so $N_t$ itself does not
  raise the growth rate. With market integration, innovators can serve
  customers beyond national borders; national population alone need not
  measure their market size.
]

#align(center)[
  #figure(
    image("figures/romer_equilibrium_scale_effect.svg", width: 85%),
    caption: [A larger market or cheaper innovation.],
  )<fig:romer-scale-effect>
]

#figure-note[
  Log-utility schematic ($sigma = 1$), redrawn from Lecture 6, slide 11.
  Higher $L$ or lower $eta$ raises $pi/eta$, shifting the free-entry line
  upward to $r_1$. Preferences are unchanged, so the Euler locus stays fixed
  and growth rises from $g_"eq"$ to $g_1$.
]

=== The planner's problem

Given $N_0 > 0$, the planner has the same preferences as the household and solves
$
  max_({C_t, X_t, N_(t+1)}) sum_(t=0)^infinity beta^t u(C_t)
$
subject to
$
  C_t + N_t X_t + eta (N_(t+1) - N_t)
  = A L^(1 - alpha) N_t X_t^alpha,
$
with $C_t > 0$, $X_t >= 0$ and $N_(t+1) >= N_t$.

*Static choice:* for given $N_t$, use each variety until its marginal
product equals its marginal cost:
$
  A alpha L^(1 - alpha) (X^*)^(alpha - 1) & = 1, \
                                      X^* & = L (A alpha)^(1/(1 - alpha)) > X.
$

The *social return to innovation* is net output from a new variety divided
by its cost. Using the static FOC,

$
  r^* & = frac(A L^(1 - alpha) (X^*)^alpha - X^*, eta) \
      & = frac(1 - alpha, alpha eta) X^*
        = frac(1 - alpha, alpha eta) L (A alpha)^(1/(1 - alpha)).
$
Blueprints persist, so the gross return is $1 + r^*$. The resource constraint becomes
$
  C_t + eta N_(t+1) = (1 + r^*) eta N_t.
$
*Dynamic choice:* investing $eta$ today adds a variety next period. At an
interior optimum,
$
                        u'(C_t) & = beta (1 + r^*) u'(C_(t+1)), \
  1 + g^* := frac(C_(t+1), C_t) & = (frac(1 + r^*, 1 + rho))^(1/sigma).
$
An interior growing path requires $r^* > rho$ and $g^* < r^*$.

The markup reduces intermediate use and private innovation returns.
When both paths have positive innovation, *equilibrium growth is too low*:
$
  frac(r, r^*) = frac(X, X^*) = alpha^(1/(1 - alpha)) < 1
  quad => quad g < g^*.
$

#align(center)[
  #figure(
    image("figures/romer_equilibrium_planner.svg", width: 85%),
    caption: [Equilibrium and planner growth.],
  )<fig:romer-planner-growth>
]

#figure-note[
  Log-utility schematic ($sigma = 1$), redrawn from Lecture 6, slide 11.
  The planner comparison holds the baseline parameters fixed:
  $r^* > pi/eta$ implies $g^* > g_"eq"$.
  The middle line repeats the higher-$L$ or lower-$eta$ example above.
]

=== Policy implications

In this model:
- *No patent protection:* free imitation forces $P = 1$, so $pi = V = 0$.
  Firms cannot recover the innovation cost $eta > 0$. Private R&D stops,
  giving $g = 0$.
- *Finite patent protection:* a patent lasting $T$ periods has value
  $
    V(T) = sum_(s=1)^T frac(pi, (1 + r)^s)
    = frac(pi, r) [1 - (1 + r)^(-T)] < frac(pi, r).
  $
  At given $r > 0$ and $pi$, shorter protection lowers the reward to
  innovation. Free entry then supports a lower return and growth rate
  than with permanent patents, or no R&D if protection is too short.
- *Subsidize intermediate purchases:* with subsidy rate $s_X$, the buyer
  pays $(1 - s_X) P$. Since producers charge $P = 1/alpha$, setting
  $s_X = 1 - alpha$ makes the buyer's price equal marginal cost, one.
  This restores $X^*$ while preserving producers' innovation incentives.
  Profits become $pi^* = frac(1 - alpha, alpha) X^*$, so free entry gives
  $r = frac(pi^*, eta) = r^*$ and implements planner growth.
- *Subsidize R&D:* a subsidy rate $s_R$ lowers the private invention cost to
  $(1 - s_R) eta$. With positive innovation,
  $r = pi/((1 - s_R) eta)$, raising growth. This can reduce underinvestment,
  but the monopoly markup and low intermediate use remain.

The subsidy comparisons assume *lump-sum financing*.

== Quality ladders: main idea

@aghion1992creative: _Growth comes from successive improvements in the
quality of existing products._

- *Quality improvements:* the number of sectors is fixed. A successful
  innovation in sector $j$ raises quality from $A_(j t)$ to $gamma A_(j t)$,
  where $gamma > 1$.
- *Creative destruction:* the innovator becomes the new monopolist,
  displacing the incumbent. The previous leader loses its future monopoly
  rents.
- *Business stealing:* part of the entrant's reward is taking over the
  incumbent's rents. This transfer is a private gain without a corresponding
  net gain to society, which can encourage excessive R&D.

Quality gains persist after the innovator is replaced, so its profits
capture only part of their social value. This can discourage R&D.
Together with business stealing, this means *equilibrium innovation can be
too high or too low* relative to the planner's choice.

=== @aghion1992creative in discrete time: environment

Time is discrete. There is a fixed continuum of intermediate sectors
$j in [0, 1]$ and labor supply $L > 0$.

*Final-good production* is competitive, with the final good as numeraire:
$
  Y_t = L^(1 - alpha) integral_0^1 A_(j t)^(1 - alpha) x_(j t)^alpha dif j,
  quad 0 < alpha < 1.
$
Here $A_(j t) > 0$ is the leading quality in sector $j$, and $x_(j t) >= 0$
is the quantity of its intermediate input.

*Intermediate production:* the current leader produces one unit of
$x_(j t)$ from one unit of the final good, so marginal cost is one.
Quality steps are assumed large enough that older versions do not
constrain the leader's monopoly price.

*Innovation:* entrants spend $R_(j t) >= 0$ units of the final good on
research. The probability of a quality improvement is
$
  mu_(j t) = frac(lambda R_(j t), gamma A_(j t)) in [0, 1],
  quad lambda > 0, quad gamma > 1.
$
The parameter $lambda$ measures research productivity; $gamma$ is the
quality step. Feasible spending satisfies $R_(j t) <= gamma A_(j t)/lambda$.
Quality evolves according to
$
  A_(j,t+1) = cases(
    gamma A_(j t) & "with probability" mu_(j t),
    A_(j t) & "with probability" 1 - mu_(j t),
  ).
$
Current leaders produce in $t$; research outcomes arrive at the end of
$t$. A successful entrant replaces the incumbent and starts producing in
$t + 1$. Without innovation, the incumbent remains the leader.

*Resources and ownership:* the representative household supplies $L$
inelastically, owns firms and has the same CRRA preferences as above.
Final output covers consumption, intermediate production and research:
$
  Y_t = C_t
  + underbrace(integral_0^1 x_(j t) dif j, "intermediate production")
  + underbrace(integral_0^1 R_(j t) dif j, "R&D").
$

=== Monopoly profits

*Intermediate demand:* the competitive final-good firm pays each input its
marginal product. If $P_(j t)$ is the price of intermediate $j$,
$
  P_(j t) & = alpha L^(1 - alpha) A_(j t)^(1 - alpha) x_(j t)^(alpha - 1), \
  x_(j t) & = A_(j t) L (frac(alpha, P_(j t)))^(1/(1 - alpha)).
$
Quality scales demand; its absolute price elasticity remains
$epsilon = 1/(1 - alpha) > 1$.

*Monopoly pricing:* with marginal cost one, the leader maximizes
$(P - 1) x_(j t)(P)$. The constant-elasticity markup gives
$
  P_(j t) = frac(epsilon, epsilon - 1) = frac(1, alpha) > 1.
$
This uses the assumption that older versions do not constrain the price.
Substituting into demand gives quantity and *operating profit*:
$
       x_(j t) & = alpha^(2/(1 - alpha)) A_(j t) L, \
      pi_(j t) & = (P_(j t) - 1) x_(j t)
                 = frac(1 - alpha, alpha) x_(j t)
                 = overline(pi) A_(j t) L, \
  overline(pi) & := (1 - alpha) alpha^((1 + alpha)/(1 - alpha)).
$
Profits exclude the initial R&D cost. A quality upgrade by factor $gamma$
raises per-period profit by the same factor while the innovator remains
the leader.

*Aggregate output:* define average quality over the unit mass of sectors as
$A_t := integral_0^1 A_(j t) dif j$. Substituting equilibrium quantities,
$
  Y_t & = L^(1 - alpha) integral_0^1 A_(j t)^(1 - alpha)
        [alpha^(2/(1 - alpha)) A_(j t) L]^alpha dif j \
      & = alpha^((2 alpha)/(1 - alpha)) A_t L.
$
With $L$ fixed, aggregate output grows at the same rate as average quality.

=== Creative destruction and the value of innovation

*Innovation value:* take $r > 0$ and the common replacement probability
$mu in [0, 1]$ as constant. Let $V(A')$ be the end-of-period value of a
leader with quality $A'$, before its first profit next period.
It first receives $overline(pi) A' L$, then retains its continuation value
with probability $1 - mu$. Replacement leaves zero continuation value:

$
           V(A') & = frac(
                     overbrace(overline(pi) A' L, "next-period profit")
                     + overbrace((1 - mu) V(A'), "surviving leader"),
                     1 + r,
                   ), \
  (r + mu) V(A') & = overline(pi) A' L, \
           V(A') & = frac(overline(pi) A' L, r + mu).
$
The *effective discount rate* is $r + mu$. Faster future innovation shortens
the profit stream and lowers the patent's value, holding $A'$ and $r$ fixed.

#lecture-addition("A patent's legal and economic life", source: "2026-10-19, 00:58:39 - 00:59:22")[
  Legal protection can outlast a product's economic life. An incumbent may
  retain the right to sell its old technology after customers have switched
  to a better version. The displacement probability $mu$ ends its profit
  stream through obsolescence.
]

*Free entry:* spending $R_(j t)$ in $t$ gives probability
$mu_(j t) = lambda R_(j t)/(gamma A_(j t))$ of obtaining a new patent with
end-of-$t$ value $V(gamma A_(j t))$. Expected net entry profit is
$
  mu_(j t) V(gamma A_(j t)) - R_(j t)
  = R_(j t) [frac(lambda V(gamma A_(j t)), gamma A_(j t)) - 1].
$
For *interior positive R&D*, free entry sets the expected return per unit
spent equal to one:
$
  frac(lambda V(gamma A_(j t)), gamma A_(j t)) & = frac(lambda overline(pi) L, r + mu) = 1, \
                                        r + mu & = lambda overline(pi) L.
$
Quality cancels because both patent value and the cost of a given success
probability scale with $gamma A_(j t)$. The *free-entry locus* is
$r = lambda overline(pi) L - mu$: a higher innovation rate lowers the
interest rate consistent with entry breaking even.
=== Equilibrium growth

*Aggregation:* with a common innovation probability $mu$ and diversified
sectoral risk, aggregate quality evolves as
$
  A_(t+1) & = integral_0^1 [(1 - mu) A_(j t) + mu gamma A_(j t)] dif j \
          & = [1 + mu (gamma - 1)] A_t, \
        g & := frac(A_(t+1), A_t) - 1 = mu (gamma - 1).
$

On a BGP, research spending and consumption are proportional to $A_t$:

$
             R_t & := integral_0^1 R_(j t) dif j = frac(gamma mu, lambda) A_t, \
  frac(C_t, A_t) & = L [alpha^((2 alpha)/(1 - alpha)) - alpha^(2/(1 - alpha))]
                   - frac(gamma mu, lambda) > 0.
$
Thus quality, output and consumption all grow at rate $g$.

*Equilibrium conditions:* the household Euler equation and free entry give
$
  [1 + mu (gamma - 1)]^sigma & = frac(1 + r, 1 + rho), \
                           r & = lambda overline(pi) L - mu.
$
Combining them determines $mu$:
$
  (1 + rho) [1 + mu (gamma - 1)]^sigma
  = 1 + lambda overline(pi) L - mu.
$
The left side increases in $mu$; the right side decreases. Any interior
intersection is unique, with
$rho < lambda overline(pi) L < (1 + rho) gamma^sigma$ ensuring $0 < mu < 1$.
The BGP must also satisfy household transversality, $g < r$.

*Log utility* ($sigma = 1$) gives
$
  mu [1 + (1 + rho) (gamma - 1)] & = lambda overline(pi) L - rho, \
                              mu & = frac(lambda overline(pi) L - rho, 1 + (1 + rho) (gamma - 1)), \
                               g & = (gamma - 1)
                                   frac(lambda overline(pi) L - rho, 1 + (1 + rho) (gamma - 1)).
$
If $lambda overline(pi) L <= rho$, the *no-innovation corner* has
$mu = g = 0$ and $r = rho$; the positive-entry equality no longer applies.

#align(center)[
  #figure(
    image("figures/aghion_equilibrium.svg", width: 85%),
    caption: [Equilibrium innovation.],
  )<fig:aghion-equilibrium>
]

#figure-note[
  Log-utility schematic ($sigma = 1$), redrawn from Lecture 6, slide 21.
  Free entry gives the downward-sloping locus $r = lambda overline(pi) L - mu$.
  The Euler locus $r = (1 + rho) [1 + mu (gamma - 1)]^sigma - 1$ slopes
  upward. Their intersection determines $mu_"eq"$ and $r_"eq"$.
]

#align(center)[
  #figure(
    image("figures/aghion_equilibrium_scale_effect.svg", width: 85%),
    caption: [Market size and research productivity.],
  )<fig:aghion-scale-effect>
]

#figure-note[
  Log-utility schematic ($sigma = 1$), redrawn from Lecture 6, slide 21.
  Higher $L$ or $lambda$ shifts the free-entry locus upward; preferences
  and $gamma$ are unchanged. The new intersection has higher $mu$ and $r$,
  raising growth through $g = mu (gamma - 1)$.
]

=== Determinants of growth

Using $mu = g/(gamma - 1)$, equilibrium growth satisfies
$
  (1 + rho) (1 + g)^sigma + frac(g, gamma - 1)
  = 1 + lambda overline(pi) L.
$
The left side increases in $g$. Within an *interior positive-growth
equilibrium*, holding other parameters fixed:
- *A larger economy $L$* raises monopoly profits and shifts free entry
  upward, increasing $mu$ and $g$. This is the _scale effect_.
- *Higher research productivity $lambda$* raises the success probability
  per unit of research spending, increasing $mu$ and $g$.
- *Larger quality steps $gamma$* raise the gain from each successful
  innovation. Growth $g$ rises even though innovation becomes less frequent:
  the Euler equation implies higher $r$, so free entry requires lower $mu$.
- *More patient households* (lower $rho$) shift the Euler locus downward,
  increasing $mu$ and $g$.

Sectoral quality rises in jumps. Successful entrants replace incumbents
and take over production. Smooth aggregate growth can coexist with
*firm entry, exit and reallocation*.

#lecture-addition("Common research rates, different outcomes", source: "2026-10-19, 01:06:56 - 01:07:57")[
  Sectors face the same $mu$, but their realized sequences of successes
  differ. Some firms are displaced quickly; others survive for many
  periods. Sectoral quality and firm ages can therefore differ under a
  common research technology.
]

=== Is growth too fast or too slow?

Private rewards to innovation differ from social returns in three ways:
- *Appropriability:* the innovator captures monopoly profits, but not the
  full surplus generated by higher quality. This pushes toward
  *too little innovation*.
- *Intertemporal spillover:* future innovators build on today's quality.
  The current innovator receives no payment for these gains after being
  replaced, pushing toward *too little innovation*.
- *Business stealing:* the entrant gains rents that the incumbent loses.
  This transfer adds no social surplus. Ignoring the incumbent's loss
  pushes toward *too much innovation*.

*The net effect is ambiguous:* equilibrium innovation and growth can be
above or below the planner's choice. When quality improvements are small
relative to the rents captured, business stealing can dominate and growth
can be too fast.

#lecture-addition("Innovation policy under full information", source: "2026-10-19, 01:10:42 - 01:14:04")[
  These incentive wedges exist with commonly known research costs and
  technology. Which wedge dominates must be assessed sector by sector.
  Small persistent changes in growth compound into large differences in
  future consumption.

  Private information about research costs or opportunities would add
  another policy constraint.
]

== Where has the literature gone since?

#lecture-addition("Growth and industrial organization", source: "2026-10-19, 01:14:04 - 01:16:01")[
  The lecture emphasized detailed empirical extensions of these baselines,
  using firm-, industry- and sector-level data to study innovation
  incentives. This connects growth theory with *industrial organization*.
]

_Supplementary reading._

- *Scale effects and semi-endogenous growth.* @jones1995rnd:
  _The scale-effect prediction conflicts with time-series evidence.
  A semi-endogenous extension makes long-run growth depend on population
  growth, even though technological progress comes from R&D._
- *Firm dynamics.* @klette2004innovating:
  _Heterogeneous firms innovate, enter and exit. Their model connects
  firm-level evidence on R&D and patenting to aggregate innovation and
  growth._
- *Competition and innovation.* @aghion2005competition:
  _Competition can encourage neck-and-neck firms to innovate and discourage
  laggards. Their model and panel evidence yield an inverted-U relationship
  between competition and innovation._
- *The direction of innovation.* @acemoglu2012environment:
  _Research can improve clean or dirty technologies. Carbon prices and
  research subsidies redirect innovation; their model's optimal policy
  uses both instruments._
- *Research productivity.* @bloom2020ideas:
  _They document falling measured research productivity across several
  industries and firms. Maintaining a given rate of technological
  improvement requires increasing research inputs in these cases._
- *Innovation policy with heterogeneous firms.* @akcigit2022taxation:
  _Firms differ in research productivity, which the government cannot
  observe directly. Information constraints change the taxes and R&D
  subsidies needed to address knowledge spillovers._

== Scale effects and semi-endogenous growth

*Empirical motivation.* @jones1995rnd: _Research employment rose in
industrialized economies without the growth acceleration predicted by
the early models' strong scale effects._

=== Idea production

Use a discrete-time version of the idea-production block in @jones2005ideas:

$
  A_(t+1) - A_t = chi L_(A,t)^eta A_t^phi,
  quad chi > 0, quad 0 < eta <= 1, quad 0 <= phi < 1.
$
- $A_t > 0$: stock of ideas; $L_(A,t)$: researchers.
- $chi$: research efficiency; $eta$: research-labor elasticity;
  $phi$: elasticity with respect to existing knowledge.
- Take a constant equilibrium research share $0 < s_A < 1$ and population
  growth $n > 0$: $L_(A,t) = s_A L_t$, $L_(t+1) = (1 + n) L_t$.

The proportional growth rate of ideas is
$
  g_(A,t) := frac(A_(t+1) - A_t, A_t)
  = frac(chi (s_A L_t)^eta, A_t^(1 - phi)).
$
With *$phi = 1$*, growth rises with the number of researchers.
With *$phi < 1$*, a larger idea stock reduces proportional growth at a
given research input.

=== Balanced growth

With $s_A$ fixed,
$
  frac(g_(A,t+1), g_(A,t))
  = frac((1 + n)^eta, (1 + g_(A,t))^(1 - phi)).
$
On a BGP, $g_(A,t+1) = g_(A,t) = g_A > 0$, so
$
  (1 + g_A)^(1 - phi) & = (1 + n)^eta, \
                  g_A & = (1 + n)^(eta/(1 - phi)) - 1
                        approx frac(eta n, 1 - phi).
$
The approximation applies to small growth rates. This is
*semi-endogenous growth*: R&D produces new ideas, while exogenous
population growth and production elasticities pin down the BGP rate.
With $n = 0$, ideas can keep accumulating, but their proportional growth
rate tends to zero.

=== Levels and policy

For $n > 0$, the BGP satisfies
$
  frac(A_t, L_t^(eta/(1 - phi)))
  = (frac(chi s_A^eta, g_A))^(1/(1 - phi)).
$
- *A level scale effect remains:* a larger population raises the BGP idea
  stock, holding its growth rate $n$ fixed.
- *A permanent rise in $s_A$* raises growth during the transition and
  shifts the technology path upward. The BGP growth rate is unchanged.
  Policies affecting research allocation can change income levels without
  changing long-run growth, holding $n$, $eta$ and $phi$ fixed.
- *Relevant scale:* $L_t$ is the population sharing the idea stock,
  potentially global when ideas cross borders.

  #align(center)[
    #figure(
      image("figures/semi_endogenous_policy.svg", width: 100%),
      caption: [Research intensity: levels and growth.],
    )<fig:semi-endogenous-policy>
  ]

#figure-note[
  Uncalibrated example with $n = 0.02$, $eta = 0.8$, $phi = 0.5$ and
  $A_0 = L_0 = 1$. Research share rises from $0.05$ to $0.10$ in period
  $40$; $chi$ puts the initial economy on its BGP. The idea-stock ratio
  tends to $2^(eta/(1 - phi)) approx 3.03$, while growth returns to
  $(1.02)^(1.6) - 1 approx 3.22%$ per period.
]

== Are ideas harder to find?

@bloom2020ideas: _Maintaining a given rate of technological improvement
requires rising research inputs in their case studies._

=== Measuring research productivity

Let $S_t$ denote effective research input. Define
$
  cal(P)_t := frac(g_(A,t), S_t),
  quad g_(A,t) := frac(A_(t+1) - A_t, A_t).
$
_Output is a proportional improvement, such as TFP growth or chip-density
growth. Effective researchers are research spending divided by a wage
proxy, earnings of college-educated men, to adjust for rising researcher
costs._

=== Evidence

- *US aggregate, since the 1930s:* _Effective research input rose about
  23-fold; research productivity fell about 41-fold. Output is measured by
  decadal TFP growth._
- *Moore's law, 1971–2014:* _Chip density roughly doubled every two years.
  Research input rose about 18-fold; research productivity fell about
  6.8% per year._#footnote[
    The lecture used roughly eighteen months. This paragraph follows the
    paper's approximately two-year transistor-density benchmark
    (recording, 2026-10-19, 01:19:44 - 01:20:10).
  ]
- *Other cases:* _Crop yields, medical advances and firm outcomes generally
  show declining research productivity, with variation across cases and
  measures._

=== Connection to semi-endogenous growth

In the preceding model, taking $S_t = L_(A,t)$ gives
$
  cal(P)_t = chi S_t^(eta - 1) A_t^(phi - 1).
$

At fixed $S_t$, *$phi < 1$* makes research productivity fall as knowledge
accumulates. Maintaining constant positive $g_A$ therefore requires
growing research effort. Falling measured productivity is consistent with
this mechanism; the ratio alone does not identify $phi$.

#lecture-addition("AI and the research technology", source: "2026-10-19, 01:19:11 - 01:19:29; 01:21:13 - 01:21:25")[
  The lecturer left open how much AI changes research technology.
  In the semi-endogenous block above, a permanent rise in $chi$ alone
  raises BGP technology levels while leaving the long-run growth rate
  $g_A$ unchanged.
]

= Lecture 7 Oct 20

== Directed technical change

@acemoglu2002directed: _Firms choose which factors their inventions
complement. Profit incentives determine the direction of technical change._

Two forces shape those incentives:
- *Market size:* more users make a technology more profitable. An abundant
  factor offers a larger market for inventions that complement it.
- *Price effect:* goods produced with scarce factors command higher prices,
  attracting innovation toward those factors.

The elasticity of substitution determines which force dominates. More
skilled workers can induce skill-complementary inventions. If that response
is strong enough, their relative wage can eventually rise despite the larger
supply. Factor supplies therefore affect both current wages and future
technology.

#lecture-addition("The adjustment of the skill premium", source: "2026-10-20, 00:00:57 - 00:04:37")[
  With technology fixed on impact, a larger supply of skilled workers lowers
  their relative wage. Subsequent skill-complementary innovation can reverse
  that response.
]

== Appropriate technology: @acemoglu2001productivity

_A technology suited to a rich country's workforce may work poorly with a
poorer country's skill mix. Equal access to inventions can coexist with
large productivity gaps._

Innovation targets the skill-abundant North because inventors earn their
returns there. The South copies those technologies but has fewer skilled
workers.

- In some industries, Northern firms use skilled workers and specialized
  machines; Southern firms instead use unskilled workers and machines
  designed for them. The latter technology is less productive there.
- This mismatch creates measured TFP differences even when Southern firms
  choose optimally given their workers and available technologies.
- The paper predicts larger *value-based industry TFP gaps* in less
  skill-intensive sectors. Local prices matter: scarce skills raise the
  prices of skill-intensive goods in the South.

Technology diffusion alone need not close income gaps. The direction of
invention and the skill mix of its users also matter.

#lecture-addition("Agriculture and local conditions", source: "2026-10-20, 00:05:50 - 00:07:09")[
  Agricultural technology depends on climate, soil and the crops that can be
  grown locally. Seeds, pesticides and fertilizers developed for conditions
  in high-income countries may fit other locations poorly. This matters
  especially where agriculture accounts for a large share of production.
]

== Climate and directed technical change

@acemoglu2012environment: _Policy can redirect innovation toward clean
technology. Once clean technology is sufficiently advanced, private
research incentives can sustain that direction._

- *Dirty technology can reinforce its lead.* Its larger market and existing
  knowledge attract further research. With a sufficiently large initial
  dirty advantage, laissez-faire keeps innovation dirty and environmental
  damage accumulates.
- *Two policy instruments:* a carbon tax reduces current dirty production;
  clean-research subsidies change what gets invented. Using both avoids
  relying on a high carbon tax to do both jobs.
- *Temporary intervention is conditional.* Temporary support can permanently
  redirect research when clean and dirty inputs are substitutes. Avoiding
  environmental disaster with temporary policy requires stronger
  substitutability and sufficiently good initial environmental conditions.
  Otherwise, permanent regulation may be necessary.

Delay widens the technology gap. Clean technology then needs longer support,
with a longer transition of slow growth. The result depends on how readily
clean production can replace dirty production.

== Automation and new tasks

@acemoglu2019automation: _Technology changes which tasks workers perform.
Automation displaces labor from existing tasks; new tasks can expand its
role in production._

A job bundles several tasks. Automating one task can change a job without
eliminating the whole occupation. Three effects matter:

- *Displacement:* machines take over tasks previously done by workers,
  reducing labor's role and its share of income.
- *Productivity:* lower production costs expand output and demand for labor
  in remaining tasks. This can offset displacement, but need not.
- *Reinstatement:* new tasks where workers have a comparative advantage
  expand labor demand and its income share. Examples include new work in
  software development and technical maintenance.

Small cost savings can coexist with substantial displacement. The authors
call this _so-so automation_: its productivity gain may be too weak to
offset the loss of labor demand. A falling labor share can also coexist with rising real
wages if productivity grows enough. Employment additionally depends on
labor supply and adjustment frictions.

@acemoglu2018race: _Automation and new-task creation are themselves research
choices. Their relative profitability affects the long-run balance between
machines and workers._

Automation can lower labor's effective cost, making further automation less
attractive relative to creating new labor tasks. Under suitable conditions,
this supports a stable path with both kinds of innovation. It does not
guarantee recovery: sufficiently cheap capital can instead lead to full
automation. A permanent improvement in automation research can also lead
to a new growth path with lower employment and a lower labor share.

== Measuring innovation with patent data

@griliches1990patents: _Patents provide detailed records of inventive
activity, but inventions differ greatly in importance and in whether they
are patented._

R&D spending measures research input. Patent records provide an observable
output that can be linked to inventors, firms, technology fields and places.

- *Patent counts:* measure the volume of patented activity, giving each
  patent the same weight.
- *Forward citations:* later patents citing an invention provide a proxy
  for its technological influence. Citation-weighted counts allow important
  inventions to receive more weight.
- *Technology classes and ownership:* show what firms invent and where
  research is directed. Matching patents to firm data connects invention
  to R&D, growth and market shares.

Patent coverage and firms' willingness to patent differ across sectors.
Trade secrets, process changes and organizational improvements may leave
little trace in patent counts; strategic patenting can raise counts without
equally large productivity gains.

@hall2001patents: _Citation comparisons must account for technology fields,
patent cohorts and the time available to accumulate citations._

Recent patents have shorter citation histories. Citations can also reflect
legal examination and citation practices, so a citation link alone does
not establish a knowledge spillover.

@kogan2017innovation: _Stock-market reactions around patent grants can be
used to estimate inventions' private economic value for listed US firms._

This measure links innovation to subsequent firm growth and resource
reallocation, connecting patent data to Schumpeterian growth theory.
It measures gains to the patent owner. Knowledge spillovers, consumer
benefits and losses to competitors make the *social value* a different
object.

#lecture-addition("Interpreting patent events", source: "2026-10-20, 00:12:52 - 00:16:51")[
  The technical information may already be public before a patent is
  granted. A stock-market response at the grant date can therefore reflect
  news about quality or enforceability, rather than the first disclosure of
  an invention.

  Responses at competitors, suppliers and customers can reveal how an
  innovation affects connected firms. Patent text, inventor identities,
  locations and citations also let researchers study connections across
  technologies and inventor networks.
]

== Schumpeterian growth meets firm dynamics

@klette2004innovating: _Creative destruction explains how firms enter,
expand, shrink and exit, while their innovations drive aggregate growth._

A firm owns a portfolio of product lines. Its size changes through
innovation:

- *Expansion:* a quality improvement lets it take a product line from
  another producer.
- *Contraction:* a competitor's innovation takes a line away.
- *Entry and exit:* a new firm enters with its first line; an existing firm
  exits after losing its last one.

These products are new to the firm. The economy's set of product lines is
fixed; *aggregate growth comes from improving their quality*. Firms can
keep turning over while the distribution of firm sizes remains stable.

Existing products also represent knowledge that supports further research.
Larger firms therefore undertake more R&D in levels. The framework links
firm size, R&D, patenting and survival to the economy's innovation rate,
bringing firm-level data into growth theory.

@acemoglu2018reallocation: _Growth also depends on which firms survive and
where skilled workers are employed. Firms differ in their capacity to
innovate._

In their estimated model, supporting incumbent firms can keep weak
innovators operating and tie up skilled workers that more innovative firms
could use for research. Policy therefore affects growth through *selection
and resource reallocation*, alongside its effect on firms' R&D incentives.

== Declining business dynamism

Business dynamism is the process of firms entering, expanding, shrinking
and exiting, with jobs moving across businesses.

@akcigit2021dynamism: _Several indicators point to weaker US business
dynamism over the decades before the pandemic._

- *Entry and young firms:* fewer new firms enter relative to the existing
  business population; young firms account for less economic activity.
- *Job reallocation:* jobs are created and destroyed at a slower rate.
  These gross flows differ from net employment growth.
- *Leading firms:* market concentration and markups rise, alongside wider
  productivity gaps between frontier firms and followers.

@akcigit2023dynamism: _Slower knowledge diffusion from leading firms to
followers can jointly explain weaker dynamism and greater concentration._

In their model, followers fall further behind and become less willing to
innovate; entry also becomes less attractive. Leaders face less competitive
pressure and eventually innovate less. The resulting slowdown in catch-up
and creative destruction reduces productivity growth. This is a proposed
structural explanation, supported by their model and patent evidence.

@decker2020dynamism: _Businesses became less responsive to productivity
changes, even as the dispersion of productivity shocks increased._

Weaker expansion of productive businesses and weaker contraction of less
productive ones reduce the gains from reallocating jobs. Their evidence
suggests that this has contributed to slower aggregate productivity growth.

Higher concentration can also arise when efficient firms gain market share.
Entry, catch-up and responses to productivity changes help distinguish the
underlying explanations.

#lecture-addition(
  "Innovation incentives and the technology gap",
  source: "2026-10-20, 00:20:00 - 00:22:47",
)[
  In the leader-follower models discussed in class, a small technology gap
  gives both firms an incentive to innovate: the follower can overtake, and
  the leader wants to defend its position. A wider gap can discourage the
  follower and reduce competitive pressure on the leader. Innovation then
  falls on both sides. Harder-to-find ideas can affect growth partly through
  these changes in competition.
]

== Summary

- *From stagnation to growth:* technological progress, structural change,
  fertility choices and investment in education jointly explain the
  historical transition to sustained growth in income per person.
- *Accumulation and productivity:* physical and human capital explain part
  of cross-country income differences. Development accounting separates
  their contributions from measured TFP; explaining why they differ requires
  a theory of investment, technology and institutions.
- *Innovation:* new varieties and quality improvements raise productivity.
  Ideas are nonrival, while private profits help finance their creation.
  Knowledge spillovers and creative destruction separate private innovation
  returns from social returns.
- *Innovation direction:* firms choose which workers, tasks and sectors
  their inventions serve. Those choices affect technology's suitability,
  income distribution and environmental damage.
- *Firm dynamics:* entry, incumbent innovation, exit and knowledge diffusion
  shape productivity growth. Growth also depends on whether labor and
  capital move toward firms that can use them productively.
- *Policy:* knowledge spillovers, market power, environmental damage and
  barriers to entry call for different interventions. Whether policy changes
  income levels or long-run growth depends on the research technology and
  population dynamics. Its effect also depends on which firms expand and
  where research resources go.

== Endogenously incomplete markets

The *traditional Chicago critique* asks why valuable insurance contracts
remain unavailable. Assuming markets are missing leaves that question open.

*Positive economics:*
- If incomplete insurance creates large losses, households and firms have
  incentives to develop contracts that capture those gains. Fire and life
  insurance show that private markets can cover important risks.
- If the losses are small, explain why market incompleteness matters for
  the economic question being studied.

*Normative economics:* public insurance can look too attractive if the
government is simply allowed to implement contracts ruled out for private
agents. Policy analysis must specify the government's information and
enforcement abilities, including any advantage over private contracting.
Policy can also change private financial arrangements, an extension of
the Lucas critique.

#lecture-addition(
  "The friction also constrains public insurance",
  source: "2026-10-20, 00:28:48 - 00:33:17",
)[
  If adverse selection undermines voluntary private health insurance, a
  voluntary public plan facing the same information and participation
  constraints can inherit the problem.

  Exogenously incomplete markets can still be a useful modelling choice.
  Endogenizing the friction makes the model more demanding and limits what
  can be studied. Policy conclusions must account for the restrictions
  imposed on private agents and the government.
]

*Endogenous incompleteness:* model the friction that prevents full insurance.
The lecture focuses on *limited contract enforcement*:
- *Participation constraints:* households can walk away. Staying must be at
  least as attractive as leaving after each income history.
- A household with high current income may want to stop making transfers.
  Losing future insurance can give it a reason to stay.



== Idiosyncratic income shocks with limited enforcement

Based on @thomas1988self, _Self-Enforcing Wage Contracts_.


A continuum of *ex ante identical households* has preferences
$
  E_0 sum_(t=0)^infinity beta^t u(c_t), quad 0 < beta < 1.
$
Utility is increasing, strictly concave and satisfies the Inada conditions.

Each household receives *i.i.d. idiosyncratic income* across time and
households:
$
            y_t & in cal(Y) = {y_1, dots, y_N}, quad y_1 < dots < y_N, \
  Pr(y_t = y_n) & = pi_n, quad sum_(n=1)^N pi_n = 1.
$
By the law of large numbers, a fraction $pi_n$ receives $y_n$ each period.
Average income is constant:
$
  overline(y) = sum_(n=1)^N pi_n y_n.
$
There is *individual income risk without aggregate income risk*.

The household's income history is
$
  s^t = (y_0, y_1, dots, y_t).
$
Income is i.i.d., but an insurance contract can depend on $s^t$: past
agreements can affect what the household is entitled to receive today.

#lecture-addition("What income means here", source: "2026-10-20, 00:34:18 - 00:37:29")[
  Treat $y_t$ as the household's realized goods endowment. Its source is
  outside this partial-equilibrium model; there is no separate production
  or labor-supply decision. General-equilibrium market clearing comes
  later. The index $n$ labels possible income values, while $t$ labels dates.
]

== The complete markets benchmark

For these ex ante identical households, *complete markets and enforceable
contracts* deliver *full insurance*:
$
  c_t (s^t) = overline(y) quad "for all" t, s^t.
$
Strict concavity favors consumption smoothing. With no aggregate income
risk, pooled income supports the same consumption at every date and history.

The allocation requires transfers:
- *High income* ($y_t > overline(y)$): pay $y_t - overline(y)$ as an
  insurance premium.
- *Low income* ($y_t < overline(y)$): receive $overline(y) - y_t$ as an
  insurance payout.

Premiums finance payouts each period because
$sum_(n=1)^N pi_n (y_n - overline(y)) = 0$.

*Enforcement matters:* after a high income realization, the household must
honor its promise to pay. The limited-enforcement model allows it to walk away.

== Introducing the enforcement friction

Keep the same preferences and income process, but allow a household to
*walk away from its insurance commitment* after observing current income.

Exit leads to *permanent autarky*. The household cannot rejoin the
arrangement and has no access to saving, borrowing or other insurance.
If it exits at date $t$, consumption equals its own realized income:
$
  c_j = y_j, quad j >= t.
$

A high-income household can keep its current income by leaving, but loses
future insurance against low-income realizations. To keep it participating,
the arrangement must make *staying at least as attractive as autarky* after
every income history.

The questions are:
- Can any insurance survive when households are free to leave?
- If so, how much consumption smoothing can be sustained?


== Limited enforcement in partial equilibrium

A household contracts with a *risk-neutral insurer*:
- The insurer can borrow and lend at the given gross return
  $1 + r = 1 / beta$.
- The insurer *can commit* to future payments. The household can leave.

Borrowing and lending allow the insurer's receipts and payments to differ
within a period.

#lecture-addition("Why a risk-neutral insurer?", source: "2026-10-20, 00:43:39 - 00:45:17")[
  Risk neutrality gives a simple starting point for the insurance problem.
  Pooling a continuum of independent household risks also makes aggregate
  income predictable. The insurer's fixed interest rate and ability to
  commit are assumptions of this partial-equilibrium exercise.
]

=== The contract

A contract specifies *history-dependent consumption* $c_t (s^t)$.
If the household stays, it hands over income $y_t$ and receives
$c_t (s^t)$.

Before the initial income draw, the contract's values are
$
  P & = E_0 [sum_(t=0)^infinity beta^t (y_t - c_t (s^t))], \
  v & = E_0 [sum_(t=0)^infinity beta^t u(c_t (s^t))].
$
Here $P$ is the insurer's expected discounted profit and $v$ is the
household's expected discounted utility.

=== The autarky value

*Before current income is realized*, permanent autarky is worth
$
  v_("aut")
  = E_0 [sum_(t=0)^infinity beta^t u(y_t)]
  = frac(sum_(n=1)^N pi_n u(y_n), 1 - beta).
$
The expression is constant because income is i.i.d.

*After observing $y_t$*, leaving gives current utility $u(y_t)$ plus future
autarky utility:
$
  u(y_t) + beta v_("aut").
$
The household exits before making the current transfer, so it keeps $y_t$.

=== The participation constraint

At *every history* $s^t$, the contract must satisfy
$
  underbrace(
    u(c_t (s^t))
    + E_t [sum_(j=t+1)^infinity beta^(j-t) u(c_j (s^j))],
    "stay",
  )
  >= underbrace(u(y_t) + beta v_("aut"), "leave").
$
The expectation $E_t$ conditions on $s^t$. A contract satisfying these
constraints is *self-enforcing*: staying is optimal after every income
history. The household's only decision is whether to stay or enter permanent
autarky.

== Finding the optimal contract

We seek the contract that gives the household the highest utility while
respecting *limited enforcement* and the insurer's *break-even requirement*.
The primal and dual formulations trace the same constrained Pareto frontier.

*Primal approach:* choose the consumption contract to maximize household
utility $v$, subject to:
- The household's participation constraint at *every history*.
- Nonnegative expected discounted insurer profit, $P >= 0$.

At the optimum, *$P = 0$*: any surplus could finance more consumption,
raising household utility and relaxing participation constraints. Zero
profit applies to the initial expected present value of the whole contract.

*Dual approach:* fix a promised household utility $v$ and maximize the
insurer's profit:
$
  P(v) = max_({c_t (s^t)})
  E_0 [sum_(t=0)^infinity beta^t (y_t - c_t (s^t))],
$
subject to the same participation constraints and the *utility promise*
$
  E_0 [sum_(t=0)^infinity beta^t u(c_t (s^t))] >= v.
$
The promise sets a minimum utility before initial income is realized;
participation constraints prevent exit after each income history.

To recover the household-optimal contract, choose the *largest affordable
promise*:
$
  v_0 = max {v : P(v) >= 0}.
$
A larger promise restricts the insurer's feasible contracts, so $P(v)$ is
weakly decreasing. The optimum satisfies $P(v_0) = 0$.

The dual approach lets us use *promised utility* as the state in a recursive
problem. The insurer commits to continuation payments, including payments
that may generate future losses.

== A recursive dual approach

=== The state: promised utility

The sequential contract must satisfy participation constraints after every
history. Use the household's *promised utility* as the recursive state:
$
  v_t = E [sum_(j=0)^infinity beta^j
    u(c_(t+j) (s^(t+j))) | s^(t-1)].
$
This is expected utility *before $y_t$ is realized, from period $t$ onward*.
At $t = 0$, the conditioning history is empty.

Income is i.i.d., so past income adds no information about future draws.
The promise $v$ summarizes the remaining utility owed under the contract.
The insurer can choose how to deliver it through current consumption and
future promises.

=== Timing

+ Enter the period with promise $v$, *before* the income draw.
+ The insurer specifies $(c_n, v'_n)$ for each possible income $y_n$.
  Here $v'_n$ is promised utility *before next period's income draw*.
+ Income $y_n$ is realized. The household chooses whether to stay or exit
  into permanent autarky, before making any transfer.
+ If it stays, it gives $y_n$ to the insurer and consumes $c_n$.
+ Next period begins with promise $v'_n$.

=== The insurer's Bellman equation

Let $P(v)$ be the highest expected discounted profit from delivering promise
$v$. The insurer chooses a consumption level and continuation promise for
each income realization:
$
  P(v) = max_({c_n, v'_n}) sum_(n=1)^N pi_n
  [y_n - c_n + beta P(v'_n)].
$
The constraints are:

+ *Promise keeping:* before income is realized, expected utility must cover
  the inherited promise:
  $
    sum_(n=1)^N pi_n [u(c_n) + beta v'_n] >= v.
  $
+ *Participation:* after each income realization, staying must be optimal:
  $
    u(c_n) + beta v'_n >= u(y_n) + beta v_("aut"),
    quad n = 1, dots, N.
  $
+ *Feasibility:* consumption is nonnegative and continuation promises must
  themselves be feasible. In particular,
  $
    c_n >= 0, quad v'_n >= v_("aut"), quad n = 1, dots, N.
  $
  The lower bound follows from taking expectations of next period's
  participation constraints.

Promise keeping averages over today's income draw; participation must hold
*separately in every income state*. Continuation promises carry these
obligations into the next period, so the same problem repeats with state
$v'_n$.

== Why utility promises?

After history $s^t$ with $y_t = y_n$, the continuation promise is
$
  v'_n = E_t [sum_(j=t+1)^infinity beta^(j-t-1) u(c_j (s^j))].
$
The whole future consumption plan enters today's participation decision
through *expected discounted utility*. Staying gives $u(c_n) + beta v'_n$,
which can be compared directly with $u(y_n) + beta v_("aut")$.

- *Household:* at a given $c_n$, feasible continuation contracts delivering
  the same $v'_n$ give the same value of staying today.
- *Insurer:* those contracts can have different costs. It chooses the most
  profitable way to deliver $v'_n$, summarized by $P(v'_n)$, while satisfying
  participation constraints at every future history.

Income is i.i.d., so past income adds no information about future draws.
Past agreements matter through the *remaining utility promise*. This lets
the insurer carry one state $v$ into the next optimization problem.


== Solving the Bellman equation

Let $mu >= 0$ be the multiplier on promise keeping and $lambda_n >= 0$ the
multiplier on participation in income state $n$. The Lagrangian is
$
  cal(L) & = sum_(n=1)^N pi_n [y_n - c_n + beta P(v'_n)] \
         & quad + mu (sum_(n=1)^N pi_n [u(c_n) + beta v'_n] - v) \
         & quad + sum_(n=1)^N lambda_n
           [u(c_n) + beta v'_n - u(y_n) - beta v_("aut")].
$
The participation terms are *not probability-weighted* here; this fixes
the normalization of $lambda_n$.

For positive-probability states, assume $P$ is differentiable and choices
are interior: $c_n > 0$ and $v'_n > v_("aut")$. The *first-order and envelope
conditions* are
$
  [c_n]: quad (lambda_n + mu pi_n) u'(c_n) & = pi_n, \
           [v'_n]: quad lambda_n + mu pi_n & = -pi_n P'(v'_n), \
                    "Envelope:" quad P'(v) & = -mu.
$
The factor $beta$ cancels from the first-order condition for $v'_n$.
The envelope condition says that $mu$ is the *marginal profit cost* of an
additional unit of promised utility; $P'(v) <= 0$.

*Complementary slackness* also requires
$
           mu (sum_(n=1)^N pi_n [u(c_n) + beta v'_n] - v) & = 0, \
  lambda_n [u(c_n) + beta v'_n - u(y_n) - beta v_("aut")] & = 0.
$
A slack participation constraint has $lambda_n = 0$; $lambda_n > 0$ implies
that it binds. Equality alone allows a zero multiplier.

Combining the first two first-order conditions gives
$
  -P'(v'_n) = frac(1, u'(c_n))
  quad <=> quad u'(c_n) P'(v'_n) = -1.
$
The insurer equalizes the marginal cost of delivering utility through
*current consumption* and through a *continuation promise*. At a feasibility
boundary, the corresponding bound multiplier must be included in the
first-order conditions.


== The tradeoff between consumption and utility promises

The profit function $P(v)$ is *decreasing and concave*: delivering more
utility reduces profit, and the marginal cost $-P'(v)$ rises with the
promise. At an interior optimum,
$
  -P'(v'_n) = frac(1, u'(c_n)).
$
Since $u'$ falls with consumption, optimal *current consumption and
continuation utility move together*. The insurer smooths the delivery of
utility between today and the future.

Without participation constraints, the household and insurer have the
same discount factor $beta$, and optimal consumption is constant over time.
The continuation value of consuming $c$ every future period is
$
  v'(c) = sum_(j=0)^infinity beta^j u(c)
  = frac(u(c), 1 - beta).
$

#align(center)[
  #figure(
    image("figures/limited_enforcement_tradeoff.svg", width: 80%),
    caption: [Consumption and continuation promises.],
  )<fig:limited-enforcement-tradeoff>
]

#figure-note[
  Curves from Lecture 7, slide 20. Example: $u(c) = log c$, $beta = 0.7$;
  income is uniform on 21 equally spaced points in $[0.5, 1.5]$.
  Numerical ticks are omitted as in the lecture figure.
]

The *dashed curve* is the constant-consumption benchmark. The *blue curve*
shows optimal pairs under limited enforcement. In this example, future
high-income realizations can require higher payments to prevent exit,
raising continuation utility above the value of keeping consumption fixed
at today's level. The marginal-cost condition still governs the choice
between current consumption and future utility.

#lecture-addition("Backloading and retention", source: "2026-10-20, 01:13:07 - 01:15:36")[
  Deferred rewards conditional on staying make continued participation more
  valuable. An employment contract with stock options that vest only after
  sufficient tenure illustrates the mechanism: leaving means losing future
  compensation.

  A larger continuation promise gives the household more to lose on exit.
  Once inherited promises are sufficiently high, participation constraints
  can cease to alter the optimal smoothing choices. This was the closing
  intuition; the formal derivation was left for the next lecture.
]
