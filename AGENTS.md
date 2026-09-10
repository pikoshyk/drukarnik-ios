# Agent documentation map

Entry points for project documentation. Each tree is self-contained: nested docs do not cross-reference other trees.

| Topic | Entry document |
| --- | --- |
| Specification writing | [docs/specs.md](docs/specs.md) |
| Testing | [docs/testing.md](docs/testing.md) |
| Development | [docs/development.md](docs/development.md) |
| Host app | [docs/app.md](docs/app.md) |
| Keyboard extension | [docs/keyboard.md](docs/keyboard.md) |

**Functional specs:** before creating or editing a spec under `docs/app/` or `docs/keyboard/`, read [docs/specs.md](docs/specs.md). Use its template, linking rules, child-spec steps, and versioning. Do not invent a format.

Linking rule: a document may link only to its **parent** (one level up in the same tree). Root entries link down to children in their subfolders.
