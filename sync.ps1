#Requires -Version 7
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Dotfiles = $PSScriptRoot
$HomeDir  = $env:USERPROFILE

# ── Functions ─────────────────────────────────────────────────────────────────

function Link-File {
    param([string]$Target, [string]$Source)

    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq 'SymbolicLink') {
            Remove-Item $Target -Force
        } else {
            Rename-Item $Target "$Target.bak" -Force
            Write-Host "  Backed up: $Target → $Target.bak"
        }
    }

    $dir = Split-Path $Target
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null
    }

    New-Item -ItemType SymbolicLink -Path $Target -Value $Source -Force | Out-Null
    Write-Host "  Linked: $Target"
}

function Link-Dir {
    param([string]$Target, [string]$Source)

    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq 'SymbolicLink') {
            Remove-Item $Target -Force
        } else {
            Rename-Item $Target "$Target.bak" -Force
            Write-Host "  Backed up: $Target → $Target.bak"
        }
    }

    $dir = Split-Path $Target
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }

    New-Item -ItemType SymbolicLink -Path $Target -Value $Source -Force | Out-Null
    Write-Host "  Linked dir: $Target"
}

# ── Symlinks ──────────────────────────────────────────────────────────────────

Write-Host "`nCreating symlinks...`n"

# BetterDiscord
Link-Dir "$HomeDir/AppData/Roaming/BetterDiscord/themes" "$Dotfiles/BetterDiscord/themes"
# FastFetch
Link-Dir "$HomeDir/.config/fastfetch" "$Dotfiles/fastfetch"
# GlazeWM
Link-File "$HomeDir/.glzr/glazewm/config.yaml" "$Dotfiles/glazewm/config.yaml"
# Oh My Posh
Link-Dir "$HomeDir/Documents/OhMyPoshThemes" "$Dotfiles/omp"
# PowerShell
Link-File "$HomeDir/Documents/PowerShell/Microsoft.PowerShell_profile.ps1" "$Dotfiles/pwsh/Microsoft.PowerShell_profile.ps1"
# Spicetify
Link-File "$HomeDir/AppData/Roaming/spicetify/Themes/Spicetify-retro-main/color.ini" "$Dotfiles/spicetify/color.ini"
Link-File "$HomeDir/AppData/Roaming/spicetify/Themes/Spicetify-retro-main/theme.js" "$Dotfiles/spicetify/theme.js"
Link-File "$HomeDir/AppData/Roaming/spicetify/Themes/Spicetify-retro-main/user.css" "$Dotfiles/spicetify/user.css"
# Tacky Borders
Link-File "$HomeDir/.config/tacky-borders/config.yaml" "$Dotfiles/tacky-borders/config.yaml"
# VS Code
Link-File "$HomeDir/AppData/Roaming/Code/User/keybindings.json" "$Dotfiles/vscode/keybindings.json"
Link-File "$HomeDir/AppData/Roaming/Code/User/settings.json" "$Dotfiles/vscode/settings.json"
# WezTerm
Link-File "$HomeDir/.wezterm.lua" "$Dotfiles/wezterm/.wezterm.lua"
# Zebar
Link-File "$HomeDir/.glzr/zebar/settings.json" "$Dotfiles/zebar/settings.json"

Write-Host "`nDone.`n"
