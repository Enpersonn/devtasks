# devtasks

A small, dependency-free project task runner for Zellij. Each project declares
named processes in `.devtasks.toml`. Devtasks starts them in a background
`Tasks:<project>` tab, stacks their logs into one pane area, and exposes status
for `zjstatus`.

Requires Python 3.11+ and Zellij 0.45+.

## Install

```bash
git clone <your-repository-url> ~/Documents/personal-projects/devtasks
~/Documents/personal-projects/devtasks/install.sh
```

The installer links `~/.local/bin/devtasks` to the checked-out script. Ensure
`~/.local/bin` is on `PATH`.

## Project configuration

Create `.devtasks.toml` in a project root:

```toml
default = ["api", "frontend"]

[tasks.api]
label = "API"
command = ["dotnet", "run", "--project", "src/App/App.csproj"]
cwd = "."
ready_after = 3

[tasks.frontend]
label = "Frontend"
command = ["npm", "run", "dev"]
cwd = "src/Frontend"
depends_on = ["api"]
ready_after = 2
```

`command` may be an argument array or a shell string. Optional task settings
include `label`, `cwd`, `env`, `depends_on`, and `ready_after`.

A TCP readiness check can replace `ready_after`:

```toml
[tasks.api.ready]
type = "tcp"
host = "127.0.0.1"
port = 5000
timeout = 60
```

HTTP readiness checks support `url`, `timeout`, and `insecure = true` for local
self-signed HTTPS certificates.

## Commands

```text
devtasks start [task ...]
devtasks stop [task ...]
devtasks restart [task ...]
devtasks logs [task]
devtasks menu
devtasks status
devtasks bar
```

The interactive menu supports:

- `a`: start defaults
- `x`: stop defaults
- `r1`, `r2`, ...: restart one task
- `s1`, `s2`, ...: stop one task
- `f`: restart failed tasks
- `l`: select a task log

## Zellij status integration

With `zjstatus`, add `{command_devtasks}` to a format and configure:

```kdl
command_devtasks_command    "devtasks bar"
command_devtasks_format     "{stdout} "
command_devtasks_interval   "2"
command_devtasks_rendermode "dynamic"
```

Status dots are yellow while starting, green while running, red after failure,
and gray after a successful exit while its log pane remains available.

## Test

```bash
./tests/smoke.sh
```

The test runs without touching an active Zellij session.
