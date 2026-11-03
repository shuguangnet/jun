# AGENTS.md

Guidance for coding agents (Claude Code, Codex, Pi, …) working in this repository.

## What this is

Jun is a native macOS app (Apple Silicon, macOS 13+) for running terminal coding agents side by side, across projects. It is written in Go on top of [MyGo](https://github.com/egoist/mygo); terminals are rendered on the GPU by Ghostty. There is no WebView and **no AI API anywhere in the app** — Jun only runs the agent CLIs the user already has, and reads their status from each terminal's title and screen.

## Commands

```sh
# run a dev build with its own config/settings, so it does not touch the installed app's files
./run.sh   # same as:
JUN_CONFIG_PATH="$PWD/priv/config.dev.json" JUN_SETTINGS_PATH="$PWD/priv/settings.dev.yaml" go run ./cmd/jun

# test and vet everything before you claim done
go test ./...
go vet ./...

# build the app bundle and DMG into build/darwin-arm64/
go tool mygo build -platform darwin/arm64
```

- The Go version comes from `go.mod` (1.27.3) and is downloaded on first build.
- `mygo` runs via `go tool`, not as a standalone binary.
- Tests in `internal/app` drive the real UI through MyGo's `ui.Tester`; follow the patterns in the existing `*_test.go` files.

## Code layout

| Package | Does |
|---|---|
| `cmd/jun` | the application's entry point |
| `internal/app` | the native UI: regions, views, palette, menus, saving |
| `internal/layout` | the model of projects, perspectives, regions and tabs, and its validation |
| `internal/config` | the layout file (`config.json`): versions, migrations, atomic writes |
| `internal/settings` | the settings file (`settings.yaml`) |
| `internal/terminal` | terminal sessions and their lifecycle |
| `internal/agent` | recognizing agents and reading their status |
| `internal/history` | reading Claude Code, Codex and Pi sessions |
| `internal/repo` | Git: branches, worktrees, files and diffs |
| `internal/theme` | Jun's colors, and Ghostty's themes |

Feature docs live in `docs/` (one page per view, plus `mygo.md`); `README.md` and `README.zh-CN.md` are the entry points, in English and Simplified Chinese.

## Rules

- **Keep the MyGo `replace` line.** `go.mod` replaces `github.com/egoist/mygo` with a fork (`github.com/bencode/mygo`) that carries a terminal crash fix. Do not remove or update the replace without reading [docs/mygo.md](docs/mygo.md) and following its upgrade procedure.
- **UI strings are bilingual.** User-facing strings go through `a.text(en, zh)` (see `internal/app/locale.go`). Every new string needs both the English and the Simplified Chinese text; keep the Chinese wording consistent with the terms already in use (视角 = perspective, 标签 = tab, 区域 = region, 侧边栏 = side bar, 命令面板 = command palette).
- **`config.json` is versioned.** If you change the layout model in `internal/layout`, bump the version in `internal/config` and write a migration; writes are atomic, keep them that way.
- **Read-only views stay read-only.** Files and Diff must not gain write operations.
- **No network calls for AI.** Jun makes no AI API calls by design; do not add any.
- **Local artifacts go in `priv/`.** It is gitignored, as are `.mygo/` and `build/`. Do not commit build output, plans or notes elsewhere.
- **Update docs with behavior.** A change to a view's behavior belongs in its `docs/<view>.md` page; shortcuts also go into `docs/shortcuts.md`, settings keys into `docs/settings.md`.
