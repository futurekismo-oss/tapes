<br />
<div align="center">

<h1 align="center">Tapes</h1>

<img src="media/icon.svg" alt="Tapes logo" width="200">

An atomic dotfile switcher for Linux and ricing.
Swap your whole setup in one command and get it back in one command.

Rewritten to be safer, simpler and truly atomic

<a href="https://github.com/futurekismo-oss/tapes/issues/new">Report Bug</a>
&middot;
<a href="https://github.com/futurekismo-oss/tapes/issues/new">Request Feature</a>
&middot;
<a href="https://discord.gg/TVjsGzFAur">Join the Discord</a>

</div>

---

[![License: GPL-3.0](https://img.shields.io/badge/License-GPL--3.0-blue.svg)](LICENSE)
[![Rust Edition: 2024](https://img.shields.io/badge/Rust-2024-orange.svg)](Cargo.toml)
[![Release](https://img.shields.io/github/v/release/futurekismo-oss/tapes?color=brightgreen)](https://github.com/futurekismo-oss/tapes/releases)
[![Discord](https://live-members-count.rohansrma.me/api/discord-members?guildId=1566455702107586591&color=5865F2&label=Members&scale=1)](https://discord.gg/TVjsGzFAur)
[![Stars](https://img.shields.io/github/stars/futurekismo-oss/tapes?logo=github&color=f5c542)](https://github.com/futurekismo-oss/tapes/stargazers)

Tapes has a Official GUI now, Check it out here, [https://github.com/LilaccFlowerr/tapes-deck](https://github.com/LilaccFlowerr/tapes-deck)

***If you like the project, Mind giving it a star 🌟?*** 

---

## Tapes in Action

https://github.com/user-attachments/assets/6791a91b-a3be-429b-9fd0-adc34fc93b08

---

## Quickstart

Either package a `~/.config` as a tape (put in it a folder, move to `~/.tapes` and add a tape.toml inside), or install one directly from a repo. Then, you can easily insert the tape to try it out and eject it just as easily to return back to your old `~/.config`.

```bash
# You found a cyberpunk dotfiles in a public repo
tapes install https://github.com/some_user/cyberpunk --name cyberpunk 
# if its in a specific branch or subdir in the repo, utilize the --branch and --dir subcommands

# Insert a tape sitting in ~/.tapes
tapes insert cyberpunk # tapes expects the tape in ~/.tapes/cyberpunk

# Wanna see its properties and hooks before insertion?
tapes show cyberpunk

# List all the tapes in ~/tapes
tapes show

# Is a tape currently inserted?
tapes status

# Wanna go back to your old config?
tapes eject
```

It's as simple as that!
A tape.toml is meant to look like this:

```toml
[tape]
name = "cyberpunk" # required
desc = "A cool cyberpunk rice"
dependencies = ["hyprland", "quickshell"] # just useful data for the user, tapes does nothing with it as of now

[hooks]
insert = [
  "hyprctl reload",
  "qs kill",
  "waybar &",   "notify-send 'Tapes' 'Switched to cyberpunk rice'"
]

eject = [
  "hyprctl reload",
  "pkill waybar",
  # Tapes runs commands in the current shell session, so try to move them to the background
  "qs -c caelestia -d",  
  "notify-send 'Tapes' 'Back to caelestia'",
]

# install = [] # exists btw
```

Tapes expects the directory tree to look like this:

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


Some handy flags for tapes:

```bash
--dry-run # shows the plan without touching any files
--no-hooks # skip running any hooks
-p, --path # insert a tape straight out any folder
-q, --quiet # quiet output
-v, --verbose # verbose output
-l, --logging # show logs, useful for reporting issues and debugging

-V, --version # display the current version
```

---

## Installation

**Install script** (grabs the latest release, re-run it to update)

```bash
curl -fsSL https://raw.githubusercontent.com/futurekismo-oss/tapes/main/install.sh | bash
```

Run `tapes --version` to ensure it worked. Make sure to add `~/.local/bin` to your `$PATH`.

**Cargo**

```bash
cargo install tapes-v2@v0.1.8-beta.1
cargo binstall tapes-v2@v0.1.8-beta.1 # prebuilt binary instead of compiling
```

Try to add `~/.cargo/bin` to your `$PATH` if `tapes --version` doesn't work

**Nix**

```bash
nix run github:futurekismo-oss/tapes
nix profile install github:futurekismo-oss/tapes
```

**From source**

```bash
git clone https://github.com/futurekismo-oss/tapes
cd tapes
cargo install --path .
```

Tapes supports tab completion. Just add ``source <(COMPLETIONS=zsh tapes)`` to your shell init (`.zshrc`, or `.bashrc`). Replace `zsh` with your chosen shell. It supports `zsh`, `fish`, `bash`, `elvish` and `nushell`

> **Tip**: If you find the name `tapes` annoying you can alias it to `tapes`, the binary can't be renamed tapes as it's taken on [crates.io](https://crates.io/search?q=tapes)

---

## Global Configuration

Tapes supports an optional global configuration file located at `~/.local/share/tapes/config.toml`.

Generate a starter configuration with:

```bash
tapes config init
```

Helpful management subcommands:

```bash
tapes config path   # Show location of active config file
tapes config show   # Display current effective configuration
```

<a id="example-config"></a>
<details>
<summary><b>Click to view example config.toml</b></summary>

```toml
# Default tape when running `tapes insert` without arguments
# default_tape = "my-default"

[install]
shallow_clone = true              # Use --depth 1 for git clones by default
backup_on_force = true            # Backup existing tape to .bak on --force reinstall

# Custom Git provider shorthands (e.g. `tapes install lab:user/rice`)
[install.providers]
lab = "https://git.myserver.com/"

[hooks.global]
# Lifecycle hooks executed across ALL tapes
post_insert = [
    "notify-send 'Tapes' 'Switched tape to $TAPE_NAME'"
]
post_eject = [
    "notify-send 'Tapes' 'Restored base configuration'"
]

[targets]
# Files or folders in a tape that should never be symlinked into ~/.config
ignore = ["wallpapers", "assets", "scripts", ".DS_Store"]
```

The following environment variables are available in hooks:

| Variable | Value |
|---|---|
| `$TAPE_NAME` | Name of the tape (from `tape.toml`) |
| `$TAPE_DIR` | Path of the tape, e.g. `~/.tapes/cyberpunk` |
| `$CONFIG_DIR` | Your config folder, normally `~/.config` |

</details>

---


## Why Use Tapes?
If you're like me and a big unixporn fan, you've definitely found yourself wanting to try new rices, however the worry of trashing your old config holds you back. Install scripts barely care; they frequently override previous configs or just backup the entire config folder and make a new one, forcing you go to back and manually move files to fix the mess. 

Tapes aims to solve this by making trying out new rices and reverting back to your old config as frictionless as possible as while being safe and fast. Other dotfile managers have come close, but don't really give this feeling of pop in a config and pop it out as fast (this is where the name came from). The initial implementation (v1) was hasty and buggy. It was a prototype.

Now, let's explain the terms you'll come across while using this program.

**Tape**: A tape is ~/.config folder, a rice, a dotfile; whatever you choose to call it. It contains folders like `quickshell` and `hypr`. Tapes can take this config folder and swap its `targets` or folders with your own, allowing you to use the example quickshell and hypr config in this tape as your config without losing things like `chromium` keys (which are stored in `~/.config/chromium` for some reason).

**Target**: A target is a folder in a tape, a `quickshell` folder, or `hypr` folder, but a target can also be a file e.g `.zshrc`, `starship.toml`. These targets tell tapes the config you wanna insert into your `~/.config` folder.

**Atomic**: You've heard me say it a lot. It means there is no in-between; when tapes insert a tapes, it takes the targets from your `~/.config` folder, asks the tape which config it provides, and then builds an entire valid config folder called `~/.config.tapes` made up of symlinks from the tape and your previous config. It then uses the renameat linux syscall to swap your `~/.config` with `~/.config.tapes` (meaning your old config becomes `~/.config.tapes` and vice versa), and as there is no in-between state where your config is missing, it can call itself atomic, since anything before the swap can be easily rolled back by deleting `~/.config.tapes`.

**Hooks**: Shell commands in the tape.toml. Tapes can run them after insert, after eject or after install. *Make sure to read these if a repo provides its own tape.toml, even though it shouldn't.*

---

## FAQ

<details>
<summary><b>Click to view the FAQ</b></summary>

<br>

**How can I get tapes?**

See [Installation](#installation). The quickest way is the install script, or `cargo install tapes-v2`

**How can I make my config use tapes? / How do I make my local config a tape?**

A tape is just a folder with your configs and a `tape.toml`. Copy the folders you care about (`hypr`, `nvim`, ...) into a new folder and install it:

```bash
tapes install https://github.com/some_user/cyberpunk --name cyberpunk 
tapes insert cyberpunk

tapes install ~/cyberpunk --name cyberpunk
tapes insert cyberpunk
```

Tapes generates a tape.toml for you, which you have to configure to fit your needs, they contain hooks, see [example config](#example-config) for more info.

**Can I use it with my current rice?**

Yes you can, if your rice is in your .config, it can completely be used with your own rice. you just swap it out with `tapes eject` or `tapes insert your-rice` (if you made it a tape)

**Do I need to back up my config before using tapes?**

It is highly recommended to make a backup. Even though tapes is built to be safe, it is still prone to errors as it is currently in beta.

**Does having multiple configs overlap and erase my config?**

No. For every folder or file the tape provides (e.g. `hypr`), the tape's version is used while it's inserted. Everything else in your `~/.config` that the tape doesn't provide (e.g. `chromium`) stays as it is. Nothing is deleted, and on eject you get your original config back. Only one tape can be inserted at a time.

**What does tapes support exactly? Quickshell?**

Anything that lives in `~/.config`. Tapes doesn't look at what the folders are, all it does is replace what is in `~/.tapes` and copies it over to `~/.config`. While keeping a copy of your previous config ofcourse.

**Does it only work on Arch?**

No, it works on any distro, not just Arch. However an important consideration is that tapes only supports Linux as it relies on a linux syscall for atomic swapping of folder. Mac, Windows, and BSD are not supported.

**How does it work for Nix and NixOS?**

You can install tapes with the flake (`nix profile install github:futurekismo-oss/tapes`) imperatively (Try to do it the declaratively way, I trust you know how, if you don't read the Nixos Wiki). Tapes only needs `~/.config` to be a real directory. If `~/.config` itself is a symlink, `tapes insert` refuses to run. Tapes should also run fine with home-manager as it doesn't touch inside the folder themselves, however home-manager might get confused if you rebuild while a tape inserted.

**How would I update my dots?**

Tapes symlinks the files from `~/.tapes/<name>`, so edits you make while a tape is inserted go straight into the tape. To pull in a newer version from a repo, eject first and reinstall with `--force`:

```bash
tapes eject
tapes install https://github.com/some_user/cyberpunk --name cyberpunk --force
```

The old copy is kept in `~/.tapes/cyberpunk.bak` (see `backup_on_force` in the [config](#global-configuration)). To update tapes itself, re-run the install script.

Keep in mind, a simple `git pull` might also work

You could also remove the tape in `~/.tapes` and installing it again from github or any other git place. 

**Do i need to have my current setup be its own tape?**

No, your current setup doesnt need to be a tape. Tapes uses your current setup to be able to revert when you eject. If you want, you could see it as the base tape that doesnt need to be inserted.

**How is this different from chezmoi or stow?**

Chezmoi and stow manage *one* set of dotfiles: stow symlinks the files from your dotfiles repo into place, chezmoi copies them from a source directory and adds things like templates and encryption. Neither is built for trying out other people's rices and going back afterwards. Tapes makes it so you can make infinite so called tapes, and then swap between them freely, whenever you feel like it.

**How is this different from Rice Cooker?**

Rice cooker is a visual tool that lets you view other peoples rices. It only supports Arch with Hyprland and Quickshell-based rices, and it works by pointing Quickshell at the selected rice. Tapes switches out your whole ~/.config, meaning it isnt just stuck to hyprland or quickshell, meaning it can switch your KDE rices (if most of it is in ~/.config that is) or any other WM/DE that has its rices in ~/.config. it can even change your starship if you wish it to do so.

Ofcourse, Inferior to rice cooker, tapes doesn't have curated rices, something the team is actively working on.

**Is Tapes Vibecoded AI slop?**

No. straight to the point, It is completely human coded. 2 months of stress and testing inorder to ensure that it is truly atomic

**Where are the tapes stored?**

Its stored in `~/.tapes`, here you can find all your tapes and what config files (targets) it hits.

**Does tapes have a config file?**

Yes, an optional one at `~/.local/share/tapes/config.toml`. Create it with `tapes config init`, see [Global Configuration](#global-configuration).

**I have an issue, what should I do?**

First, Make sure you're on the lastest version ( `tapes --version` )

Re-run the command with `--logging` and [open an issue](https://github.com/futurekismo-oss/tapes/issues/new) with the output, or ask in the [Discord](https://discord.gg/TVjsGzFAur). If an insert or eject fails halfway, your original config is untouched. In the worst case, delete `~/.config` and rename `~/.config.tapes` back to `~/.config`.

Usually it's a hook issue, check that first. If it's not a hook issue, then go to `~/.local/share/tapes/tapes.log`, here you can find the logs. you can share them with us in the [Discord](https://discord.gg/TVjsGzFAur) if an insert or eject fails halfway, your original config is untouched, so don't be scared that you'll lose your config.

</details>

---

## Acknowledgements

Thanks to these wonderful individuals for

> [erotic-erox](https://github.com/exotic-erox) for calling out some lifecycle bugs on version 0.1.2-beta

> [LilaccFlowerr](https://github.com/LilaccFlowerr) for providing the tapes showcase video and a GUI

> [saksham_kumar](https://github.com/saksham_kumar) for being a contributor and writing the beloved install command

> [Mvk](https://github.com/Mvkweb) for providing lots of encouragement and support

> [Clover](https://github.com/Cloverthestars) for providing the most encouragement and support, He encouraged the rewrite of tapes turning it from a broken mess to an actual usable utility

> [Marv](https://github.com/shreudi) for encouraging me to build tapes after i pitched the initial idea, without him, tapes would still be a random afternoon thought

---

## Roadmap

- [x] A GUI - [https://github.com/LilaccFlowerr/tapes-deck](https://github.com/LilaccFlowerr/tapes-deck)
- [ ] Colored output
- [ ] Dependencies checking

---

## Contributing

Contributions are welcome. See [Contributing.md](Contributing.md) for the guidelines.

---

## License

Distributed under the [MIT License](LICENSE).

---

## Stonks 📈

<a href="https://star-history.com/#futurekismo-oss/tapes&Date">
  <picture>
    <source media="(prefers-color-scheme: dark)" srcset="https://api.star-history.com/svg?repos=futurekismo-oss/tapes&type=Date&theme=dark" />
    <source media="(prefers-color-scheme: light)" srcset="https://api.star-history.com/svg?repos=futurekismo-oss/tapes&type=Date" />
    <img alt="Star history chart" src="https://api.star-history.com/svg?repos=futurekismo-oss/tapes&type=Date" />
  </picture>
</a>



