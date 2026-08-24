# 11. Decisions & Roadmap

### Settled
| Topic | Doctrine |
|---|---|
| Flutter state management | **Riverpod**, plain providers, no generator |
| DI | **Manual constructor injection**; composition root in the app; no get_it/injectable (codegen-free, honors the no-builders rule) |
| Navigation | **go_router** when an app needs routing; keep it boring, routes in one file |
| Large API surface JSON | **Banned for now** — revisit only if a real API client demands it |

### Roadmap
- **Team promotion:** this bible is destined for a team-facing git wiki. Vault doc stays canonical; the wiki is a published rendering. See `WIKI_PLAN.md` in this folder.
