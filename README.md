# Yukino

> ❄️ Yukino (雪乃), The Nix(OS) Flake that powers my system(s).

> [!NOTE]
> For repository discussions, feedback, or support, find me in the [Vimjoyer](https://www.youtube.com/@vimjoyer) community [Discord Server](https://discord.gg/sguvvWsa6D). Ping or message @wolfyta.

## Contents
- [Scripts](#scripts): [Install](#install) | [Switch](#switch)
- [Templates](#templates): [Python-UV](#python-uv) | [Rust](#rust) | [TypeScript](#typescript) ([Bun](#typescript-bun) | [Deno](#typescript-deno))

## Scripts

### Install
```shell
sh <(curl -L https://go.wolfyta.dev/yukino/install.sh)
```

### Switch
```shell
sh <(curl -L https://go.wolfyta.dev/yukino/switch.sh)
```

> [!WARNING]
> Primarily designed for WSL environments. For non-WSL, use [nh](https://github.com/viperML/nh).

## Templates

All templates include: [Commitlint-rs](https://github.com/KeisukeYamashita/commitlint-rs), [Deadnix](https://github.com/astro/deadnix), [EditorConfig](https://github.com/editorconfig/editorconfig), [Nix](https://github.com/NixOS/nixpkgs), [Nixfmt-rfc-style](https://github.com/NixOS/nixfmt), [Statix](https://github.com/oppiliappan/statix)

### Python-UV
**Includes:** [Hatchling](https://github.com/pypa/hatch), [Pyright](https://github.com/microsoft/pyright), [Ruff](https://github.com/astral-sh/ruff), [UV](https://github.com/astral-sh/uv)
```shell
nix flake init --template "github:TeamWolfyta/Yukino-Public#python-uv"
```

### Rust
**Includes:** [Clippy](https://github.com/rust-lang/rust-clippy), [Rust](https://github.com/rust-lang/rust), [Rustfmt](https://github.com/rust-lang/rustfmt)
```shell
nix flake init --template "github:TeamWolfyta/Yukino-Public#rust"
```

### TypeScript
**Includes:** [BiomeJS](https://github.com/biomejs/biome), [TypeScript](https://github.com/microsoft/TypeScript)

#### TypeScript-Bun
**Includes:** [Bun](https://github.com/oven-sh/bun), [NPM](https://github.com/npm/cli), [PNPM](https://github.com/pnpm/pnpm)
```shell
nix flake init --template "github:TeamWolfyta/Yukino-Public#typescript-bun"
```

#### TypeScript-Deno
**Includes:** [Deno](https://github.com/denoland/deno)
```shell
nix flake init --template "github:TeamWolfyta/Yukino-Public#typescript-deno"
```
