# Yukino

> ❄️ Yukino (雪乃), The Nix(OS) Flake that powers my system(s).

> [!NOTE]
> For repository discussions, feedback, or support, you can find me in the [Vimjoyer](https://www.youtube.com/@vimjoyer) community [Discord Server](https://discord.gg/sguvvWsa6D). Feel free to ping or message me (@wolfyta).

## Scripts

<div align="right" >
  <p>
    <a href="#yukino">⬆️ Back to top</a>
  </p>
</div>

### Scripts - Install

```shell
sh <(curl -L https://go.wolfyta.dev/yukino/install.sh)
```

### Scripts - Switch

```shell
sh <(curl -L https://go.wolfyta.dev/yukino/switch.sh)
```

> [!WARNING]
> This script is primarily designed for WSL (Windows Subsystem for Linux) environments. For non-WSL environments, I recommended to use the [nh](https://github.com/viperML/nh) package.

## Templates

All templates come with the following technologies enabled and configured by default:

- [Commitlint-rs](https://github.com/KeisukeYamashita/commitlint-rs)
- [Deadnix](https://github.com/astro/deadnix)
- [EditorConfig](https://github.com/editorconfig/editorconfig)
- [Nix](https://github.com/NixOS/nixpkgs)
- [Nixfmt-rfc-style](https://github.com/NixOS/nixfmt)
- [Statix](https://github.com/oppiliappan/statix)

<div align="right" >
  <p>
    <a href="#yukino">⬆️ Back to top</a>
  </p>
</div>

### Python-UV

- [Hatchling](https://github.com/pypa/hatch)
- [Pyright](https://github.com/microsoft/pyright)
- [Ruff](https://github.com/astral-sh/ruff)
- [UV](https://github.com/astral-sh/uv)

#### Python-UV - Install

```shell

nix flake init --template "github:TeamWolfyta/Yukino-Public#python-uv"
```

### Rust

- [Clippy](https://github.com/rust-lang/rust-clippy)
- [Rust](https://github.com/rust-lang/rust)
- [Rustfmt](https://github.com/rust-lang/rustfmt)

#### Rust - Install

```shell
nix flake init --template "github:TeamWolfyta/Yukino-Public#rust"
```

### TypeScript

All TypeScript templates come with the following technologies enabled and configured by default:

- [BiomeJS](https://github.com/biomejs/biome)
- [TypeScript](https://github.com/microsoft/TypeScript)

<div align="right" >
  <p>
    <a href="#yukino">⬆️ Back to top</a>
  </p>
</div>

#### TypeScript-Bun

- [Bun](https://github.com/oven-sh/bun)
- [NPN](https://github.com/npm)
- [PNPM](https://github.com/pnpm/pnpm)

##### TypeScript-Bun - Install

```shell
nix flake init --template "github:TeamWolfyta/Yukino-Public#typescript-bun"
```

#### TypeScript-Deno

- [Deno](https://github.com/denoland/deno)

##### TypeScript-Deno - Install

```shell
nix flake init --template "github:TeamWolfyta/Yukino-Public#typescript-deno"
```

<div align="middle" >
  <p>
    <a href="#yukino">⬆️ Back to top</a>
  </p>
</div>
