# 11. Decisions & Roadmap

### Settled
| Topic | Doctrine |
|---|---|
| Flutter state management | **Riverpod**, plain providers, no generator |
| DI | **Manual constructor injection**; composition root in the app; no get_it/injectable (codegen-free, honors the no-builders rule) |
| Navigation | **go_router** when an app needs routing; keep it boring, routes in one file |
| Large API surface JSON | **Banned for now** — revisit only if a real API client demands it |
| Public docs | **Terse `///` on every public member** (1–2 lines, what+why) — dartdoc/pub.dev-ready; `public_member_api_docs` on; use cases documented |
| Use-case params | **Discrete business params** (`id`, `userName`, …) — never cargo/container objects |
| Dart params | **Named parameters**, sole exceptions: single positional `ref`/`message`; Flutter follows Flutter conventions |
| Barrels | **One hand-written barrel per package** (`lib/<package>.dart` re-exports `lib/src/`); never import `src/` across packages |

### Roadmap
- **Team promotion:** this bible is destined for a team-facing git wiki. Vault doc stays canonical; the wiki is a published rendering. See `WIKI_PLAN.md` in this folder.
