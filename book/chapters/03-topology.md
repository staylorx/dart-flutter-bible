# 3. One Workspace or Two: Topology as a Decision

The bulls-eye maps cleanly onto folders — and then you have to decide how
many repos those folders live in. The doctrine sanctions two topologies,
and the choice is a real decision, not a style preference.

![Topology A: one workspace repo. Topology B: a pure-Dart core repo plus a separate Flutter UI repo](book/diagrams/topology-ab.png)

**Topology A — one workspace repo.** Everything in one melos workspace:
domain, use cases, both datasource adapters, and the app. This is the
default for small, single-delivery projects — a CLI, a small team, one
PR per change being a feature rather than a bottleneck. It is the cheapest
topology that still honors the bulls-eye, because the boundaries are
package boundaries and melos enforces them.

**Topology B — core repo + UI repo.** The default when a core serves a
CLI *and* a Flutter UI. The core repo is pure Dart — no Flutter imports
anywhere — so both adapters and the contract suite run headless on the
Dart VM in core CI. The UI repo consumes the core as a git dependency,
with `dependency_overrides` pointing at a local core checkout during
cross-repo work.

The price of B is real: melos workspaces do not span repos, so the git
dep + override workflow is how you pay it. What you buy is a core that
physically cannot grow a Flutter import, and a UI repo that can churn
without dragging the core's CI behind it.

One seam runs through both topologies: the application layer is the
facade. CLI and UI both talk to the same use cases; no use case knows a
delivery mechanism exists. That is why "facade" is an optional wiring
convenience, never a logic layer — the use cases *are* the API.
