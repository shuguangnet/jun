# Jun

[English](README.md) | 简体中文

一个原生 macOS 工作区，让你在同一个窗口里、跨多个项目并排运行终端编码 agent（Claude Code、Codex、Pi）。

- **平台**：Apple Silicon Mac，macOS 13 或更高版本
- **构建**：Go 与 [MyGo](https://github.com/egoist/mygo)；终端由 Ghostty 在 GPU 上渲染，没有 WebView
- **AI**：不带自己的 AI。Jun 运行你已有的 agent CLI，本身不调用任何 AI API
- **状态**：0.1.0，第一个版本。Ad-hoc 签名，暂无自动更新

![Jun 在同一项目里运行 Claude Code、Codex 和 Pi](docs/images/overview.png)

## 安装

### 下载

1. 从 [Releases](https://github.com/bencode/jun/releases/latest) 下载 `jun-0.1.0-arm64.dmg`。
2. 打开 DMG，把 **Jun** 拖进「应用程序」。
3. 首次打开 Jun。它是 ad-hoc 签名、未经公证，所以 macOS 会先拦一下：
   - **macOS 13–14**：在「应用程序」里按住 Control 点按 **Jun** → **打开** → **打开**。
   - **macOS 15 及更高**：先打开一次 Jun 并关掉警告，然后到「系统设置 → 隐私与安全性」，点 Jun 旁边的「仍要打开」并确认。
   - **或者**在终端里执行：`xattr -dr com.apple.quarantine /Applications/Jun.app`

### 从源码构建

自己构建的应用打开时不会有上述警告。

- **需要**：Go、Git、Xcode 命令行工具，并能访问 `proxy.golang.org` 和 GitHub。
  - 首次构建时，Go 会自动下载 `go.mod` 要求的版本（1.27.3）。

```sh
git clone https://github.com/bencode/jun.git
cd jun
go tool mygo build -platform darwin/arm64
```

- 然后把 `build/darwin-arm64/Jun.app` 拖进「应用程序」。

### 可选：`jun` 命令

```sh
alias jun=/Applications/Jun.app/Contents/MacOS/Jun
```

- 加到 shell 的配置文件里。之后 `jun .` 就会把当前目录作为项目打开。

## 快速上手

1. **打开项目**：⌘O，或把目录拖到窗口左侧的项目栏上。
2. **打开终端**：⌘T。
3. **在里面运行 agent**：`claude`、`codex` 或 `pi`。
4. **观察你的 agent**：点右上角最右侧的开关展开 Global。**Agents** 视图列出所有项目里的所有 agent，正在等你的排在前面。
5. **回看**：侧边栏（⌘B）里的 **Sessions** 列出历史会话。⌘⇧D 查看一个分支的改动。

## 功能

- **项目与视角**：一个窗口容纳多个项目。每个项目有命名的视角，如 Work 和 Review。→ [工作区](docs/workspace.md)
- **布局**：一到三列、一个底部区域、侧边栏和 Global。标签可以在它们之间拖动。→ [工作区](docs/workspace.md)
- **终端**：GPU 上的 Ghostty。关闭或隐藏标签后 shell 仍在后台运行，可以重新打开。→ [终端](docs/terminals.md)
- **Agents**：跨所有项目识别 Claude Code、Codex 和 Pi，分为等待中、工作中或空闲，并带实时的屏幕卡片。→ [Agents](docs/agents-view.md)
- **Files**：按分支和工作树浏览仓库（只读），支持 Markdown 和图片预览。⌘P 搜索。→ [Files](docs/files.md)
- **Sessions**：项目的 Claude Code 与 Codex 历史。阅读会话，或在终端里继续它。→ [Sessions](docs/sessions.md)
- **Diff**：一个分支的改动，并排或合并显示，用于在 pull request 之前审阅 agent 的工作。→ [Diff](docs/diff.md)
- **命令面板**：⌘K 搜命令、项目、视角和目录。
- **键盘**：标签、区域、视角和项目的快捷键，都在 ⌘K 的「键盘快捷键」里列出。→ [快捷键](docs/shortcuts.md)
- **主题**：Jun 自带主题，或任意 Ghostty 主题，包括你在 `~/.config/ghostty/themes` 里的。
- **语言**：英文与简体中文。
- **设置**：一个 YAML 文件，在 Jun 里用 ⌘, 打开。→ [设置](docs/settings.md)

| Agents | Files |
|---|---|
| ![Agents 视图，包含等待中、工作中和空闲的 agent](docs/images/agents.png) | ![Files 树与 Markdown 预览](docs/images/files.png) |
| **Sessions** | **Diff** |
| ![Sessions 列表与打开的会话](docs/images/sessions.png) | ![分支改动的并排对比](docs/images/diff.png) |

## 配置

| 文件 | 内容 | 默认位置 | 覆盖方式 |
|---|---|---|---|
| `settings.yaml` | 语言、主题、字号、Claude Code 目录 | `~/.config/jun/settings.yaml` | `JUN_SETTINGS_PATH` |
| `config.json` | 项目、视角、布局、标签 | `~/Library/Application Support/Jun/config.json` | `JUN_CONFIG_PATH` |

- **Sessions** 从设置文件里的 `claude.configDirs` 读取 Claude Code 的会话，否则读 `CLAUDE_CONFIG_DIR`，再否则读 `~/.claude`；Codex 的从 `CODEX_HOME` 读取，否则读 `~/.codex`。
- 更多：[配置](docs/configuration.md)、[设置](docs/settings.md)。

## 局限

- 仅支持 Apple Silicon Mac。
- Ad-hoc 签名、未经公证，首次打开需要上面的步骤；没有自动更新。
- 退出 Jun 会结束它的 shell。下次启动在同样的标签里打开全新的 shell，之前的进程和输出都不在了。窗口的大小和位置不会保存。
- Agent 状态从每个终端的标题和屏幕内容读取。agent 的新版本可能显示出 Jun 认不出的样子。
- Files 和 Diff 是只读的。

## 开发

- **需要**：macOS 13 或更高版本、Xcode 命令行工具、Go 1.27.3 或更高版本。
- 给开发版本单独的文件，避免和已安装的应用共用布局或设置。`./run.sh` 帮你做好这件事：

```sh
./run.sh   # 等价于：
JUN_CONFIG_PATH="$PWD/priv/config.dev.json" JUN_SETTINGS_PATH="$PWD/priv/settings.dev.yaml" go run ./cmd/jun
go test ./...
go vet ./...
go tool mygo build -platform darwin/arm64   # 产出 build/darwin-arm64/Jun.app 和 DMG
```

| 包 | 职责 |
|---|---|
| `cmd/jun` | 应用入口 |
| `internal/app` | 原生 UI：区域、视图、命令面板、菜单、保存 |
| `internal/layout` | 项目、视角、区域和标签的模型及其校验 |
| `internal/config` | 布局文件：版本、迁移、原子写入 |
| `internal/settings` | 设置文件 |
| `internal/terminal` | 终端会话及其生命周期 |
| `internal/agent` | 识别 agent 并读取其状态 |
| `internal/history` | 读取 Claude Code、Codex 和 Pi 的会话 |
| `internal/repo` | Git：分支、工作树、文件和差异 |
| `internal/theme` | Jun 的配色，以及 Ghostty 的主题 |

- `priv/` 存放本地计划、笔记和构建产物，与 `.mygo/`、`build/` 一样被 Git 忽略。
- MyGo 依赖及其 fork：[docs/mygo.md](docs/mygo.md)。

## 文档

| 页面 | 内容 |
|---|---|
| [工作区](docs/workspace.md) | 项目、视角、区域、标签与焦点 |
| [终端](docs/terminals.md) | shell、后台会话、退出与重启 |
| [Agents](docs/agents-view.md) | 识别、状态、卡片与列表、操作 |
| [Files](docs/files.md) | 文件树、预览、⌘P 搜索 |
| [Sessions](docs/sessions.md) | 哪些会话、列表、阅读与继续 |
| [Diff](docs/diff.md) | 打开对比、比较什么、如何阅读 |
| [配置](docs/configuration.md) | 布局文件：保存什么、怎么保存、出错时怎么办 |
| [设置](docs/settings.md) | 设置文件及其各项 |
| [快捷键](docs/shortcuts.md) | 全部键盘快捷键 |
| [MyGo](docs/mygo.md) | MyGo 依赖及其 fork |
