# Specification writing guide

How to write **functional specifications** that work well for implementation, review, and automated agents: one shared shape, testable behavior, and clear boundaries.

This guide defines format and quality bar only. It does not name repository paths, documents, or product-specific identifiers.

## What a functional spec is for

A functional spec is the **contract for observable behavior**. Readers should be able to answer:

- What does the user (or host system) see and get?
- What is explicitly **out of scope**?
- How do we know the implementation matches the spec?

Good specs reduce rework: they state behavior before code debates, and they give acceptance checks that survive refactors.

## Principles

| Principle | Practice |
| --- | --- |
| Behavior first | Describe inputs, outputs, and states—not class names as the main story |
| Testable | Every normative rule should map to a test or a manual check |
| Normative vs informative | Use **must** / **must not** for requirements; use notes for context |
| Single source of truth | One child spec per feature; avoid duplicating the same rules in two files |
| Living document | Bump **Version** and **Last changed** in the metadata table when behavior in the spec changes |
| Thin References | Point to code for “where it lives”; do not paste large code blocks into the spec |
| English | All spec text in English |

Avoid: marketing language, vague “should be nice”, specs that only restate the code line-by-line without stating **why** behavior matters.

## Documentation trees

Specifications are grouped into **trees** (e.g. host app vs extension). Each tree is self-contained.

| Concept | Rule |
| --- | --- |
| Root spec | One overview per tree: scope, architecture sketch, feature index |
| Child specs | One document per feature or cohesive subsystem |
| Isolation | No links or requirements that depend on another tree’s specs |
| Parent | Each child has exactly one parent (one level up in the same tree) |

## Linking rules

1. **Parent** in the metadata table links to the immediate parent spec only.
2. In **References → Documents**, list only that parent (tree roots point at the project documentation map, without naming files here).
3. Root specs may link **down** to children via the feature index.
4. Repository paths and external URLs belong in References or implementation maps—not as cross-tree doc links.

## Document identifiers

Stable **Document ID** (unchanged across document versions):

```text
<PRODUCT>-FS-<SCOPE>
```

`SCOPE` is `ROOT` for the tree root, or an uppercase feature slug with hyphens.

## Required document structure

Order is fixed.

### 1. Title (H1)

Feature or product area name.

### 2. Metadata table

| Field | Required | Notes |
| --- | --- | --- |
| Document ID | Yes | Stable identifier |
| Version | Yes | Document semver (`1.0.0`); current snapshot only |
| Status | Yes | `Draft`, `Active`, `Deprecated` |
| Product | Yes | Human-readable product name |
| Component | Yes | Target or module |
| Last changed | Yes | `YYYY-MM-DD`; calendar date of this **Version** |
| Parent | Yes | Parent spec or documentation map entry |

**Version and date**

- The metadata table is the **only** place for document **Version** and **Last changed**.
- A document **must not** include a separate version–date table, change log, or list of past revisions (one row or many).
- Only the **latest** version and date may appear in the file. Do not keep previous versions in the document. Rationale for a change belongs in the git commit message, not in the spec.

When you bump the document, update **Version** (semver) and **Last changed** (same calendar day as the edit) in the metadata table.

### 3. Summary

One paragraph: scope and audience (implementers, reviewers, QA).

### 4. Body

Use the sections below that apply. **Child feature specs must include Goals, User-visible behavior, and Acceptance criteria.**

#### Goals

Why the feature exists; one or two sentences.

#### Non-goals

What this feature **does not** do. Prevents scope creep and wrong expectations.

#### User-visible behavior

Normative description of what happens. Prefer:

- Tables (layout × input × output)
- Short scenarios (“When …, the system …”)
- Diagrams (flow, state) when logic branches

State **must** / **must not** for requirements readers must implement.

#### Acceptance criteria

Checklist or Given / When / Then. This is the main bridge to programming and tests.

Format (either is fine):

**Checklist**

```text
- [ ] When the user types a partial word, the bar shows transliteration if conversion differs from input.
- [ ] Tapping a word suggestion inserts only that suggestion’s text, not emoji from the same bar.
```

**Given / When / Then**

```text
Given Latin layout and lexicon contains a Cyrillic key for the transliterated word
When the user finishes typing the word “dobra”
Then the bar shows a Cyrillic transliteration suggestion and separate emoji suggestions
And tapping the word suggestion inserts only the Cyrillic word
```

Every acceptance criterion should be verifiable in isolation.

#### Edge cases and limitations

Known gaps, partial input, empty states, performance bounds, settings that exist but do not gate behavior.

#### Configuration (if any)

Setting keys, defaults, and whether each key **must** affect behavior or is reserved for future UI.

#### Data flow (optional)

How events move between UI, services, and storage—only when it clarifies behavior.

#### Alternatives considered (optional)

For non-obvious design choices: what was rejected and why (short). Use when the team might revisit the decision.

#### Verification

How acceptance criteria are checked: test target, suite names, or manual steps. Do not duplicate full test code.

### 5. References (last section)

**Documents** is mandatory. Other subsections only if applicable.

| Subsection | Content |
| --- | --- |
| **Documents** | Parent spec only (or map entry for roots) |
| **Child specifications** | Roots only: index of child IDs and paths |
| **External dependencies** | Frameworks, packages, platform APIs that define behavior |
| **Source code** | Short implementation map: path → role (normative entry points) |
| **Verification artifacts** | Tests or fixtures that prove acceptance criteria |

In **Source code**, list files that implement requirements—not every helper. In the body, describe **behavior**; in References, point to **where** it lives.

## Versioning

| Bump | When |
| --- | --- |
| Patch | Wording, typos; no change to acceptance criteria or behavior |
| Minor | Behavior, UI, or acceptance criteria change |
| Major | Feature replaced or scope redefined |

On every bump, update **Version** and **Last changed** in the metadata table in lockstep (same version string and date). Change code and spec together when user-visible behavior changes.

## Status values

| Status | Meaning |
| --- | --- |
| `Draft` | Incomplete; not authoritative for implementation |
| `Active` | Source of truth; implement against this |
| `Deprecated` | Superseded; state the replacement in the body or References |

## Root feature index

Root spec includes:

| Feature | Document ID | Document | Status |
| --- | --- | --- | --- |

Link only to children in the same tree. Use `—` until a child spec exists.

## When to split specs

| Write one child spec | Keep in root only |
| --- | --- |
| Distinct user-facing feature with its own acceptance criteria | One-line mention in architecture table |
| Behavior that will be versioned and reviewed on its own | Internal glue with no direct user impact |
| Enough complexity for edge cases and non-goals | |

## Creating a child spec

1. Create the markdown file in the tree’s child folder.
2. Add a row to the root feature index.
3. Set Parent and References → Documents to the parent only.
4. Fill **Acceptance criteria** before marking `Active`.

## Template (child feature spec)

```markdown
# Feature title

| Field | Value |
| --- | --- |
| Document ID | `PRODUCT-FS-FEATURE` |
| Version | `1.0.0` |
| Status | Draft |
| Product | … |
| Component | … |
| Last changed | YYYY-MM-DD |
| Parent | … |

## Summary

…

## Goals

…

## Non-goals

…

## User-visible behavior

…

## Acceptance criteria

- [ ] …

## Edge cases and limitations

…

## Verification

…

## References

### Documents

| ID | Title | Relation |
| --- | --- | --- |
| `PRODUCT-FS-ROOT` | … | Parent functional specification |

### External dependencies

| Dependency | Usage |
| --- | --- |

### Source code

| Path | Role |
| --- | --- |

### Verification artifacts

| Path | Role |
| --- | --- |
```
