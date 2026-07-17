# AGENTS.md

Comprehensive guideline for AI agents and human developers working on **AntikytheraInstanceExample**.

## Overview

`AntikytheraInstanceExample` is an example instance of [Antikythera], a project that enables building an in-house Platform as a Service (PaaS). A platform administrator creates and deploys an "antikythera instance" like this one.

It is:

- used for testing [Antikythera] and [Testgear] behavior in CI, and
- a sample case for an [Antikythera] instance mix project.

This is an Elixir/Mix project. The instance itself is intentionally thin: most configuration and behavior are delegated to the `antikythera` dependency.

- Language/runtime: Elixir `1.15.8-otp-26`, Erlang/OTP `26.2.5.14` (pinned in `.tool-versions`; enforced during `mix.exs` evaluation).
- Instance name: `:antikythera_instance_example` (set in `config/config.exs`).
- Key source files: `lib/antikythera_instance_example.ex`, `config/config.exs`, `mix.exs`.

### Auto-generated / read-only files

Do **not** hand-edit the following:

- `mix.lock` — managed by Mix via `mix deps.get`. The `antikythera` entry (and its transitive locks) is bumped automatically by CI (`[CI] Update antikythera`).
- The `antikythera` dependency `ref:` in `mix.exs` — bumped automatically by the same CI job. Other parts of `mix.exs` are hand-maintained.
- `deps/**` (including `deps/antikythera/**`) — fetched dependencies; treat as read-only.
- `_build/`, `_build_local/`, `cover/`, `exdoc/`, `rel_erlang-*/`, `rel_local_erlang-*/` — build/release artifacts (git-ignored).

## Commands

| Purpose | Command |
| --- | --- |
| Install dependencies | `mix deps.get` |
| Compile | `mix compile` |
| Run tests | `mix test` |
| Format | None configured |
| Markdown lint/fix | `markdownlint-cli2 --fix "**/*.md"` |
| Typecheck | None configured |
| Static code analysis | None configured |

Notes:

- No formatter, typechecker, or static-analysis tool is configured for this project. The closest quality gate is compiling without warnings (`mix compile --warnings-as-errors`).
- `script/tool/operation/check_markdown_links.sh` checks Markdown files for broken links (requires `markdown-link-check`); use it when editing docs.

## Development Rules

Coding style follows Antikythera's Style Guide. Read it before making changes:

- [Antikythera `STYLE_GUIDE.md`] (fetched locally at `deps/antikythera/STYLE_GUIDE.md`).
- We *mostly* follow [Credo's Elixir Style Guide]; preferred styles there are used. Credo static analysis is **not** fully relied upon.

Overall policy: be consistent within your change, be consistent with surrounding code, and ask/discuss in the Pull Request when in doubt.

### Reviewer checklist (highlights)

- **Consistency**: Changes are consistent within themselves and with surrounding code.
- **Typespecs**: Public functions (and complicated private ones) declare typespecs. Prefer [`Croma.Defun`] and `v[]` argument validation where applicable.
- **Module names**: CamelCase even for acronyms (e.g. `Antikythera.Url`, not `Antikythera.URL`).
- **Alias order**: Aliases ordered by generality — (1) external modules, (2) `Antikythera`, (3) `AntikytheraCore`, (4) `AntikytheraEal`. Bundle same-level modules, e.g. `alias Antikythera.{GearName, GearNameStr}`.
- **`import`**: Not abused. Used only when clearly safe/useful, limited with `:only`, and scoped as narrowly as possible.
- **Parentheses**: Never omitted in function calls or function definitions (parentheses MAY be omitted only when invoking macros).
- **Pipe operator `|>`**: Used only when the first argument is a complex expression or to separate data from its transformation; not used for trivial single calls.
- **Auto-generated files**: No manual edits to the files listed under [Auto-generated / read-only files](#auto-generated--read-only-files).

## Definition of Done

Complete all applicable steps before considering a change done:

1. **Run tests** — `mix test` passes.
2. **Lint / typecheck** — No dedicated linter/typechecker exists; instead ensure `mix compile` produces no warnings (`mix compile --warnings-as-errors`). Run `script/tool/operation/check_markdown_links.sh` if Markdown docs changed.
3. **Review** — Self-review the change against the [Reviewer checklist](#reviewer-checklist-highlights) in Development Rules.
4. **Re-verify** — If any files were modified during steps 1–3 (e.g. review fixes), rerun the relevant checks from steps 1–2 until they pass cleanly.

## References

- [Antikythera] — `https://github.com/access-company/antikythera`
- [Testgear] — `https://github.com/access-company/testgear`
- [Antikythera `STYLE_GUIDE.md`] — `deps/antikythera/STYLE_GUIDE.md` (also in the Antikythera repo)
- [Credo's Elixir Style Guide] — `https://github.com/rrrene/elixir-style-guide`
- [`Croma.Defun`] — `https://hexdocs.pm/croma/Croma.Defun.html`
- Project overview: [`README.md`](./README.md)

[Antikythera]: https://github.com/access-company/antikythera
[Testgear]: https://github.com/access-company/testgear
[Antikythera `STYLE_GUIDE.md`]: https://github.com/access-company/antikythera/blob/master/STYLE_GUIDE.md
[Credo's Elixir Style Guide]: https://github.com/rrrene/elixir-style-guide
[`Croma.Defun`]: https://hexdocs.pm/croma/Croma.Defun.html
