<br />

<div align="center">

<img src="media/icon.svg" alt="Tapes" width="180">

# Tapes

**An atomic dotfile switcher for Linux ricing.**

Swap your entire setup in one command.
Get it all back in one command.

[![License](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![Rust](https://img.shields.io/badge/Rust-2024-orange.svg)](Cargo.toml)
[![Release](https://img.shields.io/github/v/release/futurekismo-oss/tapes?color=brightgreen)](https://github.com/futurekismo-oss/tapes/releases)
[![Discord](https://img.shields.io/badge/Discord-Join-5865F2?logo=discord&logoColor=white)](https://discord.gg/TVjsGzFAur)
[![Stars](https://img.shields.io/github/stars/futurekismo-oss/tapes?logo=github&color=f5c542)](https://github.com/futurekismo-oss/tapes/stargazers)

[Install](#-installation) · [Quickstart](#-quickstart) · [How it works](#-how-it-works) · [FAQ](#-faq) · [Discord](https://discord.gg/TVjsGzFAur)

*[Official GUI now available → tapes-deck](https://github.com/LilaccFlowerr/tapes-deck)*

</div>


## Tapes in Action

https://github.com/user-attachments/assets/fc3c07b0-7eee-448a-94c5-9d560c288512


## Quickstart

```bash
# Grab a rice from a public repo
tapes install https://github.com/some_user/cyberpunk --name cyberpunk
#    --branch <branch>   pick a specific branch
#    --dir <subdir>      pick a specific subdirectory

# Or grab an official, ready-made tape
tapes install-featured caelestia

# See what's inside before you commit (props + hooks)
tapes show cyberpunk

# Pop it in
tapes insert cyberpunk

# Pop it out — your old ~/.config is restored exactly as it was
tapes eject
```

That's it. Everything else is optional.

You can also browse ready-to-use tapes in the [featured-tapes](https://github.com/futurekismo-oss/featured-tapes) repository.

### Useful flags

| Flag | What it does |
|---|---|
| `--dry-run` | Show the plan without touching any files |
| `--no-hooks` | Skip all hooks |
| `-p, --path` | Insert straight from any folder |
| `-q / -v` | Quiet / verbose output |
| `-l, --logging` | Show logs (attach these when reporting issues) |


## The tape format

A tape is just a `~/.config` snapshot with a manifest:

```text
cyberpunk/
├── tape.toml
├── hypr/
│   └── hyprland.conf
├── waybar/
│   └── config.jsonc
└── nvim/
    └── init.lua
```

```toml
[tape]
name = "cyberpunk"                               # required
desc = "A cool cyberpunk rice"
dependencies = ["hyprland", "quickshell"]        # informational

[hooks]
insert = [
  "hyprctl reload",
  "qs kill",
  "waybar &",
  "notify-send 'Tapes' 'Switched to cyberpunk rice'"
]
eject = [
  "hyprctl reload",
  "pkill waybar",
  "qs -c caelestia -d",   # run long-lived commands in the background
  "notify-send 'Tapes' 'Back to caelestia'"
]
# install = [] # also exists
```

> [!NOTE]
> If you install a tape from someone else's repo, read their `tape.toml` hooks before inserting. You shouldn't have to, but you should.


## 📦 Installation

**Install script** (latest release, re-run to update)

```bash
curl -fsSL https://raw.githubusercontent.com/futurekismo-oss/tapes/main/install.sh | bash
```

**Cargo**

```bash
cargo install tapes-dotfiles@v0.1.10-beta.2
cargo binstall tapes-dotfiles@v0.1.10-beta.2   # prebuilt binary
```

> The crate is `tapes-dotfiles`, the binary is `tapes`. The old `tapes-v2` crate is abandoned.

**Nix**

```bash
# From source
nix run github:futurekismo-oss/tapes
nix profile install github:futurekismo-oss/tapes

# Prebuilt Binary
nix run github:futurekismo-oss/tapes#tapes-bin
nix profile install github:futurekismo-oss/tapes#tapes-bin
```

**From source**

```bash
git clone https://github.com/futurekismo-oss/tapes && cd tapes
cargo install --path .
```

Check that `tapes --version` works; add `~/.local/bin` or `~/.cargo/bin` to your `$PATH` if it doesn't.

**Tab completion**

```bash
# add to your shell init (.zshrc, .bashrc, ...)
source <(COMPLETIONS=zsh tapes)   # also: fish, bash, elvish, nushell
```


## Global configuration

Optional, at `~/.local/share/tapes/config.toml`. Generate a starter with:

```bash
tapes config init    # also: tapes config path / tapes config show
```

<details>
<summary><b>View example</b></summary>

```toml
# default_tape = "my-default"

[install]
shallow_clone = true        # --depth 1 git clones by default
backup_on_force = true      # keep a .bak on --force reinstall

[install.providers]
lab = "https://git.myserver.com/"   # e.g. `tapes install lab:user/rice`

[hooks.global]              # run for ALL tapes
post_insert = [ "notify-send 'Tapes' 'Switched tape to $TAPE_NAME'" ]
post_eject  = [ "notify-send 'Tapes' 'Restored base configuration'" ]

[targets]                   # never symlink these into ~/.config
ignore = ["wallpapers", "assets", "scripts", ".DS_Store"]
```

Hook environment variables: `$TAPE_NAME`, `$TAPE_DIR`, `$CONFIG_DIR`.

</details>


## How it works

- **Tape** — a full `~/.config`-style folder (a rice, your dotfiles) with a `tape.toml`.
- **Target** — any file or folder in the tape (like `hypr/`, `nvim/`, `.zshrc`) that gets swapped into your `~/.config`.
- **Hooks** — shell commands run after insert, eject, or install.
- **Atomic** — there is no in-between. Tapes builds a complete, valid config (`~/.config.tapes`) out of symlinks from the tape plus everything else you already had, then swaps it with `~/.config` via the Linux `renameat` syscall in a single instant. Everything before the swap is trivially rollable back by deleting `~/.config.tapes`.

**Why it matters:** install scripts override your configs or backup the whole folder and makes a fresh one. This means you might lose your hyprland or chromium keys forcing you to lose your keybinds or have to login again to your gmail. Tapes keeps everything the tape doesn't provide and leaves your `chromium/` keys or whatever untouched. It requires one command to try out a new config and another to return back to your previous one and because it only touches `~/.config`, it works on every distro, every WM/DE as well as every rice. However tapes utilizes the linux `renameat2` syscall so it only works on linux (for now)


## FAQ

<details>
<summary><b>Can I use it with my current rice?</b></summary>

Yes. Your current setup doesn't need to be a tape at all — it *is* the base you revert to on eject. If you want it insertable too, copy its folders into a new directory with a `tape.toml` and it works like any other tape.

</details>

<details>
<summary><b>Will multiple configs overwrite my stuff?</b></summary>

No. Only what the tape provides (its targets) is swapped while inserted. Everything else in `~/.config` stays exactly as it is, and eject restores your originals. Nothing is ever deleted. One tape can be inserted at a time.

</details>

<details>
<summary><b>Do I need to back up my config first?</b></summary>

Recommended, yes. Tapes is built to be safe, but it's still in beta.

</details>

<details>
<summary><b>Does it work outside Arch?</b></summary>

Any Linux distro. Anything living in `~/.config` can be swapped — Hyprland, KDE, Waybar, starship, nvim, you name it. If `~/.config` itself is a symlink (common on NixOS), insert refuses to run; otherwise home-manager users should be fine, just rebuild cautiously while a tape is inserted.

</details>

<details>
<summary><b>Updating my dots / updating tapes?</b></summary>

Edits made while inserted go straight into the tape (it's all symlinks). To pull new versions from the repo:

```bash
tapes eject
tapes install <repo> --name cyberpunk --force   # old copy kept as cyberpunk.bak
```

To update tapes itself, re-run the install script. A plain `git pull` in `~/.tapes/<name>` often works too.

</details>

<details>
<summary><b>How is this different from chezmoi or stow?</b></summary>

Chezmoi and stow manage **one** set of dotfiles. Tapes manages infinitely many and swaps between them freely — that's the whole point.

</details>

<details>
<summary><b>How is this different from Rice Cooker?</b></summary>

Rice Cooker is a visual Arch + Hyprland + Quickshell browser. Tapes swaps your whole `~/.config`, so it works with any WM/DE and any tool whose config lives there. It doesn't have curated rices yet — working on it.

</details>

<details>
<summary><b>Is Tapes vibecoded AI slop?</b></summary>

No. Fully human coded, two months of stress-testing to make the swap actually atomic.

</details>

<details>
<summary><b>Where are tapes stored? How do I publish one?</b></summary>

In `~/.tapes`. To share a rice, PR a `setup.sh` and `tape.toml` to [featured-tapes](https://github.com/futurekismo-oss/featured-tapes) and users can `tapes install-featured your-rice`.

</details>

<details>
<summary><b>Something broke. What do I do?</b></summary>

Update first (`tapes --version`), then re-run with `--logging` and [open an issue](https://github.com/futurekismo-oss/tapes/issues/new) or ask on the [Discord](https://discord.gg/TVjsGzFAur). A failed insert/eject leaves your original config untouched — worst case, delete `~/.config` and rename `~/.config.tapes` back to `~/.config`. Logs live at `~/.local/share/tapes/tapes.log` (usually it's a hook).

</details>


## Roadmap

- [x] GUI → [tapes-deck](https://github.com/LilaccFlowerr/tapes-deck)
- [x] Dependency checking
- [ ] Colored output


## Contributing

Contributions welcome — see [CONTRIBUTING.md](CONTRIBUTING.md). If you like the project, a star 🌟 helps a lot.

I also recommend to join the [Discord](https://discord.gg/TVjsGzFAur) if you wanna contribute

## Acknowledgements

<table align="center" border="0" cellspacing="0" cellpadding="10">
  <tr>
    <td align="center" width="130">
      <a href="https://github.com/futurekismo-oss" title="futurekismo (Maker)">
        <img src="https://github.com/futurekismo-oss.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>futurekismo</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/evertiro" title="evertiro (Advice)">
        <img src="https://github.com/evertiro.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>evertiro</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/liixini" title="liixini (Advice & Support)">
        <img src="https://github.com/liixini.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>liixini</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/exotic-erox" title="exotic-erox (Bug Reports)">
        <img src="https://github.com/exotic-erox.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>exotic-erox</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/LilaccFlowerr" title="LilaccFlowerr (GUI & Showcase)">
        <img src="https://github.com/LilaccFlowerr.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>LilaccFlowerr</b></sub>
      </a>
    </td>
  </tr>
  <tr>
    <td align="center" width="130">
      <a href="https://github.com/dxnnv" title="dxnnv (CI)">
        <img src="https://github.com/dxnnv.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>dxnnv</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/sawankrs98-afk" title="Saksham_Kumar (Install Script)">
        <img src="https://github.com/sawankrs98-afk.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>Kuro</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/Mvkweb" title="Mvk (Support)">
        <img src="https://github.com/Mvkweb.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>Mvk</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/Cloverthestars" title="Clover (Support)">
        <img src="https://github.com/Cloverthestars.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>Clover</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/shreudi" title="Marv (Early Encouragement)">
        <img src="https://github.com/shreudi.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>Marv</b></sub>
      </a>
    </td>
  </tr>
 <tr>
    <td align="center" width="130">
      <a href="https://github.com/amitxd75" title="Amit (Install Command, General Fixes & Features, Performance Refactors)">
        <img src="https://github.com/amitxd75.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>Amit</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/magnagy" title="Magnagy (Fixed Spelling and Grammar Errors in Readme)">
        <img src="https://github.com/magnagy.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>Magnagy</b></sub>
      </a>
    </td>
    <td align="center" width="130">
      <a href="https://github.com/SpanishSyntax" title="SpanishSyntax (Nix)">
        <img src="https://github.com/SpanishSyntax.png" width="64px;" style="border-radius: 50%;" alt=""/><br />
        <sub><b>SpanishSyntax</b></sub>
      </a>
    </td>
    <td align="center" width="130"></td>
    <td align="center" width="130"></td>
  </tr>
</table>

## Related

- [tapes-deck](https://github.com/LilaccFlowerr/tapes-deck) - GUI for Tapes
- [featured-tapes](https://github.com/futurekismo-oss/featured-tapes) - A curation of ready to use tapes

## Star History

<a href="https://star-history.com/#futurekismo-oss/tapes&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=futurekismo-oss/tapes&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=futurekismo-oss/tapes&type=Date" />
    <img alt="Star history" src="https://api.star-history.com/svg?repos=futurekismo-oss/tapes&type=Date" />
  </picture>
</a>

---

<div align="center">

Distributed under the [GPL-3.0 License](LICENSE).

</div>
