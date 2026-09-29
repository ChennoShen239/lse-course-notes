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
  abstract: [Notes on the 1st year Macro class],
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

// BEGIN lecture-addition environment
// Supplementary lecture material; original theorem/equation counters unchanged.
#let lecture-addition(title, source: none, body) = block(
  width: 100%,
  breakable: false,
  inset: (x: 10pt, y: 8pt),
  fill: rgb("#fff8ec"),
  stroke: (left: 1.5pt + rgb("#bc8736")),
  radius: 2pt,
  above: 0.65em,
  below: 0.65em,
)[
  #set par(justify: false)
  #set math.equation(numbering: none)
  #text(weight: "semibold", fill: rgb("#805719"))[Lecture addition: #title]
  #v(0.25em)
  #body
  #if source != none [
    #v(0.2em)
    #text(size: 8pt, fill: luma(40%))[Recording: #source]
  ]
]
// END lecture-addition environment

= Lecture 1 Sep. 29

// Write your lecture notes here. Use == for sections and === for subsections.
// Available environments: definition, theorem, proposition, corollary,
// lemma, example, proof, and algorithm.
// Example syntax:
// #definition[Definition text.] <def:label>
// #theorem[Theorem statement.] <thm:label>
// #proof[Proof text.]
// Refer to labeled results with @def:label or @thm:label.

== Why heterogeneity
Complete markets + standard welfare assumptions:
- Competitive eq. Pareto efficient; planner representation w/ fixed weights $alpha_i > 0$.
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
- Strictly convex labor disutility; interior labor choice; aggregate conditions fixed:
  productivity ↑ $->$ labor ↑; consumption share unchanged.

Implications:
- Karl Marx
- Full insurance at odds w/ data


// BEGIN lecture addition G1
#lecture-addition("Intuition for Complete Markets", source: "00:13:54, 00:16:04")[
  - *Example*: 18 students; one high earner, others lower. Complete markets $->$ high earner sells state-contingent claims $->$ consumption decoupled from income.
  - *Marx analogy*: "From each according to ability, to each according to needs." Efficient allocation equalizes marginal utilities regardless of income.
  - *Empirical mismatch*: Data shows strong income-consumption correlation. Complete markets imply correlation vanishes $->$ model unrealistic. Heterogeneity requires market incompleteness.
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
- #block(sticky: true)[*Interior FOCs*:]
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
  - *Lagrangian*: Leads to 2nd-order difference eq. Solving via "shooting" $->$ local, clunky.
  - *Recursive*: Bellman eq. $->$ direct computation of *global solution* via iteration.
  - *Convergence*: VFI guaranteed to converge to unique fixed point (via CMT), unlike many ODE/PDE methods.
]
// END lecture addition G2

== Dynamic Programming
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
  - Analogous to Brouwer fixed-point theorem in 1D: continuous function mapping interval to itself with slope $< 1$ $->$ unique fixed point.
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
  - *Initial guess* $bold(v)^(0) = 0$: One-period model (no future utility). Agent consumes all output today.
  - *First iteration* $T bold(v)^(0)$: Two-period model. Optimize today/tomorrow, world ends after tomorrow.
  - *Convergence*: Each iteration extends horizon by 1 period. $n -> infinity$ $->$ infinite-horizon value function.
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
  - CMT guarantees convergence for individual decision problems (value functions).
  - Heterogeneous GE: convergence of *distribution* of states (assets, income, human capital) required.
  - Distribution = higher-dimensional object; may have multiple fixed points $->$ more complex than single-agent VFI.
]
// END lecture addition G7


// BEGIN lecture addition G8
#lecture-addition("Curse of Dimensionality", source: "01:15:51, 01:16:53")[
  - Grid-based VFI suffers from *curse of dimensionality*: $n$ state variables $->$ $M^n$ grid points (exponential growth).
  - Large $n$ (e.g., 50) $->$ computationally intractable.
  - *Frontier approaches*: Sparse grids; mean field games [ASR uncertain: Ben Moll]; heuristic trust in convergence when rigorous proofs unavailable.
]
// END lecture addition G8


// BEGIN lecture addition G9
#lecture-addition("Complexity vs. Reality", source: "01:17:25, 01:19:00")[
  - Model complexity driven by *expectation side*: agents anticipate others' actions $->$ complex fixed-point problems.
  - Evidence: real people not "fully forward-looking" as standard models assume.
  - *Responses*: (1) Develop computational tools for complex models; (2) Simplify models to match cognitive complexity (behavioral/limited rationality).
]
// END lecture addition G9
