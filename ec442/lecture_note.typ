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

#block(sticky: true)[Feasibility:]
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

#block(sticky: true)[Feasibility:]
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

#block(sticky: true)[After observing $z$, define]
$
  x = (1 - delta) k + z k^alpha.
$
Then
$
  w(x) = max_(c, k')
  [u(c) + beta bb(E)_(z')[w(x')]],
$
#block(sticky: true)[subject to]
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

*Chocies.* _For a fixed $(k,z)$ or $x$, Options 1 and 2 maximize over scalar choices
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
- *Optimization*: Households maximize utility and firms maximize profits, taking prices as given.
- *Feasibility*: The allocation is feasible: total use of each good does not exceed
  production plus endowments.

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
#block(sticky: true)[subject to]
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

#block(sticky: true)[If borrowing is allowed, replace $k_(t+1) >= 0$ with]
$
  liminf_(t -> infinity)
  frac(k_(t+1), product_(s=1)^t (1 + r_s)) >= 0.
$
At an interior optimum with $u'(c_s) > 0$, the Euler equation gives
$
  1 + r_s = frac(u'(c_(s-1)), beta u'(c_s)).
$
#block(sticky: true)[Multiplying from $s = 1$ to $t$, marginal utilities cancel:]
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
subject to $n_t = 1$, $c_t >= 0$, given $k_0$, and a single present-value budget:
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

In the household's budget, one unit of $k_(t+1)$ costs $p_t$ and generates
a payoff worth $p_(t+1) (1 + r_(t+1))$ at date 0.
No arbitrage requires
$
  p_t - p_(t+1) (1 + r_(t+1)) & = 0, \
           frac(p_t, p_(t+1)) & = 1 + r_(t+1).
$
Thus $p_t / p_(t+1)$ is the gross real return from $t$ to $t+1$.
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
