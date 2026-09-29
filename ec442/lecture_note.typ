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

= Lecture 1 Sep. 29

// Write your lecture notes here. Use == for sections and === for subsections.
// Available environments: definition, theorem, proposition, corollary,
// lemma, example, and proof.
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
  Fixed consumption shares → *perfect insurance* against idiosyncratic income shocks.
  Aggregate risk remains; unequal Pareto weights → unequal consumption.
- Strictly convex labor disutility; interior labor choice; aggregate conditions fixed:
  productivity ↑ → labor ↑; consumption share unchanged.

Implications:
- Karl Marx
- Full insurance at odds w/ data

== How to model incomplete markets?
+ *Exogenous*: assume some markets absent.
  + e.g. save/borrow via noncontingent bonds; no state-contingent claims.
+ *Endogenous*: derive market incompleteness from frictions.
  + e.g. limited commitment (participation constraints), private information.
  + deeper but harder to do

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
  Discounted shadow value of terminal capital → 0.
- Increasing, concave $u$; concave $f$; finite discounted utility:
  feasibility + FOCs + TVC → global optimum. At corners, use KKT conditions.


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
  Discounting restarts at date 1 → inner value $v^*(k_1)$.

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
Infinite sequence → one-period choice + discounted continuation value.
Stationarity → same problem at every date.

Bellman equation = *functional equation*; unknown = function $v(k)$.

Questions:
- *Existence*: conditions for solution $v$?
- *Uniqueness*: conditions for unique $v$ within chosen function class?
- *Equivalence*: when does $v = v^*$, with maximizing policy solving
  original sequence problem?
Answer:
- _Recursive Macroeconomic Theory_ (RMT), “Dynamic Programming”
  @ljungqvist2018rmt[ch. 3].


== Dynamic Programming
*Bellman operator* $T$: candidate continuation value $v$ → updated value $T v$.
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
    quad "for all " x, y in S.
  $
  Then $T$ has a unique fixed point $v in S$. For every $v_0 in S$ and
  $n = 0, 1, 2, dots$,
  $
    d(T^n v_0, v) <= beta^n d(v_0, v).
  $
  Hence $T^n v_0 -> v$ as $n -> infinity$, with geometric convergence.
  Here $T^n$ denotes $n$ successive applications of $T$, with $T^0$ the identity.
] <thm:cmt>

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
  @thm:cmt → unique fixed point in $S$; value iteration converges from any $v_0 in S$.


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
    quad => quad u'(c) = beta v'(k').
  $
- *Envelope condition*: differentiate w.r.t. $k$, holding optimal $k'$ fixed:
  $
    v'(k) = u'(c) [f'(k) + 1 - delta].
  $
- *Combine*: apply envelope condition next period → usual Euler equation:
  $
    u'(c_t) = beta v'(k_(t+1))
    = beta u'(c_(t+1)) [f'(k_(t+1)) + 1 - delta].
  $
  Same condition as sequence problem. At corners, use KKT conditions.
