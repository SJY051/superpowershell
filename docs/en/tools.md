# Tool Catalog

This page documents the tools that matter most for an agent-friendly Windows shell.

It does **not** try to document every installed command on the machine. The goal is to describe the tools that materially change daily shell work.

## Core Preferred Stack

| Tool | Role | POSIX analogue | Why it matters | Simple usage | Recommended Windows install | Primary source | Caveat |
| --- | --- | --- | --- | --- | --- | --- | --- |
| `pwsh` | primary shell | `sh` / `bash` family role | modern PowerShell with better ANSI support and module compatibility | `pwsh -NoLogo -NoProfile` | `winget install --id Microsoft.PowerShell -e` | [Microsoft Learn](https://learn.microsoft.com/en-us/powershell/scripting/install/install-powershell-on-windows?view=powershell-7.6) | Store/MSIX installs are not the best fit for every remoting/server scenario |
| `rg` | text search | `grep` | fast recursive search, better default search tool | `rg "pattern" .` | `winget install --id BurntSushi.ripgrep.MSVC -e` | [ripgrep README](https://github.com/BurntSushi/ripgrep) | Prefer the `MSVC` winget package ID on Windows |
| `fd` | file discovery | `find` | friendlier recursive file matching | `fd profile` | `winget install --id sharkdp.fd -e` | [fd README](https://github.com/sharkdp/fd) | The Node/npm path documented upstream is for Unix-like environments, not the default Windows path |
| `bat` | file viewing | `cat` | better human-readable file output | `bat README.md` | `winget install --id sharkdp.bat -e` | [bat README](https://github.com/sharkdp/bat) | May require the Visual C++ Redistributable on Windows |
| `jq` | JSON processing | `jq` | stable machine-oriented JSON filtering | `curl ... | jq .` | `winget install --id jqlang.jq -e` | [jq download page](https://jqlang.org/download/) | Official Windows binaries are published separately from the package-manager path |
| `yq` | YAML / JSON processing | `yq` | YAML-aware transformation, useful for config work | `yq . config.yml` | `winget install --id MikeFarah.yq -e` | [yq README](https://github.com/mikefarah/yq) | Chocolatey is community-maintained in upstream docs |
| `fzf` | fuzzy selection | none | fast interactive filtering for files, history, and providers | `fd | fzf` | `winget install --id junegunn.fzf -e` | [fzf README](https://github.com/junegunn/fzf) | Shell integration is a separate setup step after installation |
| `eza` | directory listing | `ls` | more expressive and agent-legible listing defaults | `eza -la` | `winget install --id eza-community.eza -e` | [eza INSTALL.md](https://github.com/eza-community/eza/blob/main/INSTALL.md) | `cargo install eza` is a source-build path, not the simplest Windows path |
| `zoxide` | directory jumping | `cd` | remembers frequently used locations and speeds navigation | `z project-name` | `winget install --id ajeetdsouza.zoxide -e` | [zoxide README](https://github.com/ajeetdsouza/zoxide) | You still need to add the shell init hook to your PowerShell profile |
| `uv` | Python tooling | none | fast Python project and script runtime management | `uv run python script.py` | `winget install --id astral-sh.uv -e` | [uv installation docs](https://docs.astral.sh/uv/getting-started/installation/) | The standalone installer is upstream’s preferred path; package-manager installs disable `uv self update` |
| `just` | task runner | `make`-adjacent | cleaner task entrypoint for projects with multiple developer commands | `just test` | `winget install --id Casey.Just -e` | [just programmer’s manual](https://just.systems/man/en/) | Treat `just` as the preferred runner, but keep `make` for compatibility-heavy projects |
| `curl` | HTTP client | `curl` | stable baseline HTTP request tool | `curl https://example.com` | built in on many Windows systems | [curl project](https://curl.se/) | PowerShell aliases and wrapper expectations can still confuse usage if you do not document the baseline clearly |
| `xh` | readable HTTP client | none | easier manual API exploration than raw curl invocations | `xh GET https://example.com` | `winget install --id ducaale.xh -e` | [xh project](https://github.com/ducaale/xh) | Keep it as the readable companion tool, not the primary baseline |
| `pandoc` | document conversion | none | essential for moving between Markdown, HTML, and document formats | `pandoc in.md -o out.html` | `winget install --id JohnMacFarlane.Pandoc -e` | [Pandoc](https://pandoc.org/) | The binary is heavier than most shell tools, but the conversion coverage is excellent |
| `difft` | structural diff | none | syntax-aware diff companion to line-oriented git diff | `difft a.ts b.ts` | `winget install --id Wilfred.difftastic -e` | [difftastic](https://github.com/Wilfred/difftastic) | The executable name is `difft`, not `difftastic` |

## Strong Extended Tools

| Tool | Why it helps | Notes |
| --- | --- | --- |
| `delta` | better `git diff` reading | preferred readable diff pager |
| `hyperfine` | benchmark shell commands | useful for measuring tool choices |
| `watchexec` | rerun commands on file changes | useful during repetitive local testing |
| `jc` | convert command output to JSON | especially good in mixed Windows / PowerShell environments |
| `fx` | inspect JSON interactively | useful when `jq` is too filter-heavy for quick browsing |
| `defuddle` | extract clean Markdown from web pages | especially useful for agent-friendly reading |
| `direnv` | per-directory environment loading | powerful, but worth documenting carefully on Windows |
| `duckdb` | query local files with SQL | excellent for ad hoc inspection of CSV, Parquet, and JSON with one mental model |
| `sqlite-utils` | import and reshape local data into SQLite quickly | useful when raw shell output should become queryable local state |
| `qsv` | high-performance CSV tooling | strong when spreadsheet-like data is too large or repetitive for ad hoc scripts |
| `delta` + `difft` | readable diff + structural diff | complementary rather than redundant |

## Optional Expansion Candidates

These are not required for a good baseline, but they are worth considering if you want a wider agent-friendly toolkit.

| Tool | Role | POSIX analogue | Why it matters | Recommended Windows install | Primary source | Caveat |
| --- | --- | --- | --- | --- | --- | --- |
| `tealdeer` | tldr client | none | quick command examples without opening the browser | release binary or `cargo install tealdeer` | [tealdeer](https://github.com/tealdeer-rs/tealdeer) | useful for humans and agents, but not essential once internal docs are good |
| `duckdb` | local analytical SQL CLI | none | inspect CSV, Parquet, JSON, and SQLite-style data with one query model | `winget install DuckDB.cli` | [DuckDB install](https://duckdb.org/install/) | Windows may require the Visual C++ Redistributable |
| `sqlite-utils` | SQLite automation CLI | none | turn CSV or JSON into queryable local state very quickly | `pipx install sqlite-utils` | [sqlite-utils installation](https://sqlite-utils.datasette.io/en/stable/installation.html) | as a Python tool, it benefits from explicit environment management |
| `qsv` | high-performance CSV toolkit | none | strong when data-table work outgrows simple one-liners | release binary or `cargo install qsv --locked --features all_features` | [qsv](https://github.com/dathere/qsv) | feature-rich enough that it should stay extended, not core |
| `broot` | tree navigation | partial `tree` / fuzzy browser role | fast repo exploration when directory trees get large | release binary or documented install page | [broot](https://github.com/Canop/broot) | more human-facing than machine-facing, so keep it optional |
| `doggo` | DNS client | `dig` / `drill` role | easier DNS inspection from Windows without dropping into another shell | release binary or documented install path | [doggo](https://github.com/mr-karan/doggo) | useful mostly when the shell also serves network debugging work |
| `gron` | JSON flattening | none | turns nested JSON into grep-friendly assignment lines | release binary or `go install` path from upstream docs | [gron](https://github.com/tomnomnom/gron) | less necessary if `jq`, `fx`, and `jc` already cover most inspection work |

## Representative Defaults

This environment prefers one representative command for each overlapping role:

- search text → `rg`
- find files → `fd`
- view files → `bat`
- list directories → `eza`
- jump directories → `zoxide`
- run Python projects → `uv`
- run project tasks → `just`
- make HTTP requests → `curl`
- inspect JSON → `jq`
- convert documents → `pandoc`

Alternatives can remain installed, but the default should be obvious.
