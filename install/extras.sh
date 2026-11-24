#!/bin/bash
# Global packages of language package managers and gh extensions. Sourced by setup.sh (skipped with INSTALL=0 or SSH=1).

# js/npm
npm install -g npm-check-updates # 17.1MB, ncu to check dependencies for updates; ncu -u to update package.json; ncu -i for interactive; ncu -g for global packages
npm install -g taze # 6.2MB, newer alternative, `taze` to check within range, `taze major -w` to update package.json to newest deps
npm install -g typescript typescript-language-server # 38.7MB + 1.7MB, used for lsp in helix and probably later also for nvim when changing from coc to nvim-cmp
npm install -g howfat # 1.2MB, show npm package size, #deps, #files, license as tree, table, json, simple - all info from npmjs.com, not local size on disk
npm install -g zx # 12.7MB, JS as replacement for shell scripts, https://github.com/google/zx
npm install -g daff # 1.8MB, align and compare tables, can produce and apply tabular diffs, `daff a.csv b.csv`; git: works with `GIT_PAGER=less git diff` (can't have delta as pager); see .gitconfig and .config/git/attributes
npm install -g git-split-diffs # 20MB, TS, Syntax highlighted side-by-side diffs in your terminal; alternative to delta (Rust)
# npm install -g marked # 410KB, markdown parser/compiler: `marked -o foo.html foo.md`

# python/uv
# Only install packages via ~pipx~ uv and not with pip! Only use it where brew's version of package is too old or not available at all.
# https://jacobtomlinson.dev/posts/2025/python-package-managers-uv-vs-pixi/
# `uv tool install lastversion`, `uvx lastversion`, replaces most other Python tools incl. Poetry, `uvx` -> `.cache/uv`, `uv tool install` -> `.local/{bin,share/uv/tools}`
uv tool install pipdeptree # 8.7M, tree of deps: pipdeptree -p apprise; reverse: pipdeptree -r -p requests
uv tool install lastversion # 6.8M, find/download latest version of some software on GitHub, GitLab, BitBucket, PyPi, SourceForge, Wikipedia... better `export GITHUB_API_TOKEN=...` to avoid API rate limit; https://github.com/dvershinin/lastversion
uv tool install fritzconnection # 3.9M, control FritzBox, executables: fritzcall, fritzconnection, fritzhomeauto, fritzhosts, fritzmonitor, fritzphonebook, fritzstatus, fritzwlan
uv tool install tqdm # 0.4MB, progress meter, `seq 9999999 | tqdm --bytes | wc -l`
uv tool install harlequin # 289M, Easy, fast, and beautiful database client for the terminal (2026-07-19T16:21:53+02:00) - also available via brew but wanted to install llvm and some other deps while this doesn't
uv tool install toolong # 16.1M, A terminal application to view, tail, merge, and search log files (plus JSONL). (2026-07-19T16:37:53+02:00) `tl foo.log`
uv tool install -U batrachian-toad --python 3.14 # 48.4M, A unified interface for AI in your terminal. (2026-07-19T16:43:53+02:00) `toad`
uv tool install sqlit-tui # 222.9M, A user friendly TUI for SQL databases. Written in python. Supports SQL server, Mysql, PostreSQL, SQLite, Turso and more. (2026-07-19T16:52:53+02:00) `sqlit-tui connect sqlite --file-path sqlite.db`

# gh (GitHub CLI) extensions
# https://docs.github.com/en/copilot/github-copilot-in-the-cli/using-github-copilot-in-the-cli
# list: `gh ext ls`
# browse in TUI: `gh ext browse`
gh ext install dlvhdr/gh-dash # CLI dashboard for PRs, issues
gh ext install github/gh-copilot # `gh copilot suggest`, `gh copilot explain "tar -xvf foo.tar.xz"`
gh ext install yusukebe/gh-markdown-preview # use GitHub's API to render Markdown
gh ext install gennaro-tedesco/gh-f # uses fzf for staging, workflow runs, grep, prs, branches, diffs, tags, issues
gh ext install meiji163/gh-notify # display notifications, e.g. `gh notify -e goblint -p` (only participating or mentione)
gh ext install mona-actions/gh-repo-stats # statistics for an organization's repos as .csv
gh ext install advanced-security/gh-sbom # generate SBOMs as SPDX json including 'licenseConcluded' for npm deps
gh ext install korosuke613/gh-user-stars # fzf list of starred repos, doesn't cache the >1k repos...
gh ext install matt-bartel/gh-clone-org # clone all repositories in an organization (optional filters), if exists, switch to default branch and pull
gh ext install fchimpan/gh-workflow-stats # success rate & execution time (min, max, avg, med, std) of workflows & jobs, e.g. `gh workflow-stats --org vogler --repo free-games-claimer -f docker.yml`
gh ext install sheepla/gh-userfetch # like neofetch for a GitHub profile
gh ext install nektos/gh-act # run GitHub actions locally using nektos/act
gh ext install gennaro-tedesco/gh-i # search issues, `gh i` (default state:any author:@me where:any), `gh i -s open --me=false -u=@me`
# gh ext install hectcastro/gh-metrics # metrics for PRs: commits, changes, files, comments, participants, time to first/last review, merge
gh ext install HaywardMorihara/gh-tidy # check out & pull, `git gc` to optimize local repo, check for merged branches/PRs and asks to delete them
gh ext install mtoohey31/gh-foreach # clone and execute commands across multiple repos, `gh foreach run --regex='chrom.*' tokei` --languages=c
gh extension install InditexTech/gh-sherpa # Streamline branch and pull request creation for Jira or GitHub issues; `gh sherpa create-pr --issue 42`
# gh ext install schleiden/gh-actionlint # just runs actionlint which needs to be installed
