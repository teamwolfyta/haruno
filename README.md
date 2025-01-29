# Yukino

> ❄️ Yukino (雪乃), The Nix(OS) Flake that powers my system(s).

> [!IMPORTANT]
> Most links on this page direct to the [External Links](#external-links) section. If you're interested in a specific technology, click its link to navigate to the external links list, where you'll find direct links to official websites, documentation, or GitHub repositories.

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
> This script is primarily designed for WSL (Windows Subsystem for Linux) environments. For non-WSL environments, I recommended to use the [nh](#external-links) package.

## Templates

All templates come with the following technologies enabled and configured by default:

- [Commitlint-rs](#external-links)
- [Deadnix](#external-links)
- [EditorConfig](#external-links)
- [Nix](#external-links)
- [Nixfmt-rfc-style](#external-links)
- [Statix](#external-links)

### Python-UV

- [Hatchling](#external-links)
- [Pyright](#external-links)
- [Ruff](#external-links)
- [UV](#external-links)

#### Python-UV - Install

```shell

nix flake init --template github:TeamWolfyta/Yukino-Public#python-uv
```

### Rust

- [Clippy](#external-links)
- [Rust](#external-links)
- [Rustfmt](#external-links)

#### Rust - Install

```shell
nix flake init --template github:TeamWolfyta/Yukino-Public#rust
```

### TypeScript-Bun

- [BiomeJS](#external-links)
- [Bun](#external-links)
- [NPN](#external-links)
- [PNPM](#external-links)
- [TypeScript](#external-links)

#### TypeScript-Bun - Install

```shell
nix flake init --template github:TeamWolfyta/Yukino-Public#typeScript-bun
```

### TypeScript-Deno

- [BiomeJS](#external-links)
- [Deno](#external-links)
- [TypeScript](#external-links)

#### TypeScript-Deno - Install

```shell
nix flake init --template github:TeamWolfyta/Yukino-Public#typeScript-deno
```

## External Links

- `BiomeJS`: [biomejs.dev](https://biomejs.dev)
- `Bun`: [bun.sh](https://bun.sh)
- `Clippy`: [github](https://github.com/rust-lang/rust-clippy)
- `Commitlint-rs`: [github](https://github.com/keisukeyamashita/commitlint-rs)
- `Deadnix`: [github](https://github.com/astro/deadnix)
- `Deno`: [deno.com](https://deno.com)
- `EditorConfig`: [editorconfig.org](https://editorconfig.org)
- `Hatchling`: [github](https://github.com/pypa/hatch)
- `Nh`: [github](https://github.com/viperML/nh)
- `NPN`: [npmjs.com](https://www.npmjs.com)
- `Nix`: [nixos.org](https://nixos.org)
- `Nixfmt-rfc-style`: [github](https://github.com/NixOS/nixfmt)
- `PNPM`: [pnpm.io](https://pnpm.io/)
- `Pyright`: [github](https://github.com/microsoft/pyright)
- `Ruff`: [github](https://github.com/astral-sh/ruff)
- `Rust`: [rust-lang.org](https://www.rust-lang.org)
- `Rustfmt`: [github](https://github.com/rust-lang/rustfmt)
- `Statix`: [github](https://github.com/oppiliappan/statix)
- `TypeScript`: [typescriptlang.org](https://www.typescriptlang.org/)
- `UV`: [github](https://github.com/astral-sh/uv)

<div align="middle" >
  <p>
    <a href="#yukino">⬆️ Back to top</a>
  </p>
</div>
