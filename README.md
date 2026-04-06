<h1 align="center">Alp's Personal Dotfiles</h1>

This is my personal dotfiles for Windows. Supports automatic installation of dependencies and configurations via symlinks.

![Windots Overview](/screenshots/Terminal.png)

## Overview

I'll actively update this repository as long as I keep using windows (cries in game dev). I have also wrote a script to automate the installation process. It installs all the dependencies (a few doesn't have any package so needs manual installation) and symlinks the config files.

## Features

| Config | Tool |
|--------|------|
| [fastfetch](./fastfetch) | [FastFetch](https://github.com/fastfetch-cli/fastfetch) |
| [glazewm](./glazewm) | [GlazeWM](https://github.com/glzr-io/glazewm) |
| [flowLauncher](./flowLauncher/) | [Flow Launcher](https://github.com/Flow-Launcher/Flow.Launcher) |
| [zebar](./zebar) | [Zebar](https://github.com/glzr-io/zebar) |
| [wezterm](./wezterm) | [WezTerm](https://github.com/wez/wezterm) |
| [omp](./omp) | [Oh My Posh](https://github.com/JanDeDobbeleer/oh-my-posh) |
| [pwsh](./pwsh) | [PowerShell](https://github.com/PowerShell/PowerShell) |
| [spicetify](./spicetify) | [Spicetify](https://github.com/spicetify/spicetify-cli) |
| [tacky-borders](./tacky-borders) | [Tacky Borders](https://github.com/lukeyou05/tacky-borders) |
| [vscode](./vscode) | [VS Code](https://github.com/microsoft/vscode) |
| [BetterDiscord](./BetterDiscord) | [BetterDiscord](https://github.com/BetterDiscord/BetterDiscord) |

## Pre-requisites
- [PowerShell 7](https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell-on-windows?view=powershell-7.3#install-powershell-using-winget-recommended)
- [Git](https://git-scm.com/install/windows)

## Installation

Clone the repository and run `install.ps1`

```
git clone https://github.com/kureysalp/dotfiles
./install.ps1
```

## Screenshots

![Terminal](/screenshots/Terminal.png)
![Discord_Spotify](/screenshots/Discord_Spotify.png)
![Vscode](/screenshots/Vscode.png)
