#Requires -Version 7
#Requires -RunAsAdministrator
Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$Dotfiles = $PSScriptRoot     # dotfiles directory
$HomeDir  = $env:USERPROFILE  # home directory

# ── Dependencies ──────────────────────────────────────────────────────────────

# Git must be first — Yazi depends on Git's file.exe
$wingetPackages = @(
    @{ Id = "Git.Git";                    Name = "Git"          }
    @{ Id = "glzr-io.glazewm";            Name = "GlazeWM"      }
    @{ Id = "wez.wezterm";                Name = "WezTerm"      }
    @{ Id = "JanDeDobbeleer.OhMyPosh";    Name = "Oh My Posh"   }
    @{ Id = "Fastfetch-cli.Fastfetch";    Name = "FastFetch"    }
    @{ Id = "Spicetify.Spicetify";        Name = "Spicetify"    }
    @{ Id = "Microsoft.VisualStudioCode"; Name = "VS Code"      }
    @{ Id = "Microsoft.PowerShell";       Name = "PowerShell 7" }
    @{ Id = "Chocolatey.Chocolatey";      Name = "Chocolatey"   }
    @{ Id = "Flow-Launcher.Flow-Launcher"; Name = "Flow Launcher" }
    @{ Id = "AmN.yasb";                   Name = "YASB"         })

$scoopPackages = @(
    @{ Name = "yazi"; Bucket = "main" }
)

$chocoPackages = @(
    "cascadia-code-nerd-font"
    "nerd-fonts-JetBrainsMono"   # YASB icon font
)

# ── Functions ─────────────────────────────────────────────────────────────────

function Install-WingetPackage {
    param([string]$Id, [string]$Name)
    $installed = winget list --id $Id --exact 2>$null | Select-String $Id
    if ($installed) {
        Write-Host "  [skip] $Name already installed"
    } else {
        Write-Host "  Installing $Name..."
        winget install --id $Id --exact --silent --accept-package-agreements --accept-source-agreements
    }
}

function Install-ChocoPackage {
    param([string]$Name)
    Write-Host "  Installing $Name..."
    choco install $Name -y
}

function Install-ScoopPackage {
    param([string]$Name, [string]$Bucket = "main")
    $installed = scoop list $Name 2>$null | Select-String $Name
    if ($installed) {
        Write-Host "  [skip] $Name already installed"
    } else {
        Write-Host "  Installing $Name..."
        scoop install "$Bucket/$Name"
    }
}

function Link-File {
    param([string]$Target, [string]$Source)

    if (Test-Path $Target) {
        $item = Get-Item $Target -Force
        if ($item.LinkType -eq 'SymbolicLink') {
            Remove-Item $Target -Force          # already a symlink → just replace it
        } else {
            if (Test-Path "$Target.bak") { Remove-Item "$Target.bak" -Force }
            Rename-Item $Target "$Target.bak" -Force   # real file → back it up first
        }
    }

    $dir = Split-Path $Target
    if (-not (Test-Path $dir)) {
        New-Item -ItemType Directory -Path $dir -Force | Out-Null   # create parent dir if missing
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

# ── Banner ────────────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor Green
Write-Host "│                                                                                │" -ForegroundColor Green
Write-Host "│  ██╗███╗   ██╗██╗████████╗██╗ █████╗ ██╗     ██╗███████╗██╗███╗   ██╗ ██████╗  │" -ForegroundColor Green
Write-Host "│  ██║████╗  ██║██║╚══██╔══╝██║██╔══██╗██║     ██║╚════██║██║████╗  ██║██╔════╝  │" -ForegroundColor Green
Write-Host "│  ██║██╔██╗ ██║██║   ██║   ██║███████║██║     ██║    ██╔╝██║██╔██╗ ██║██║  ███╗ │" -ForegroundColor Green
Write-Host "│  ██║██║╚██╗██║██║   ██║   ██║██╔══██║██║     ██║  ███╔╝ ██║██║╚██╗██║██║   ██║ │" -ForegroundColor Green
Write-Host "│  ██║██║ ╚████║██║   ██║   ██║██║  ██║███████╗██║███████╗██║██║ ╚████║╚██████╔╝ │" -ForegroundColor Green
Write-Host "│  ╚═╝╚═╝  ╚═══╝╚═╝   ╚═╝   ╚═╝╚═╝  ╚═╝╚══════╝╚═╝╚══════╝╚═╝╚═╝  ╚═══╝ ╚═════╝  │" -ForegroundColor Green
Write-Host "│                                                                                │" -ForegroundColor Green
Write-Host "│                         dotfiles installer by kureysalp                       │" -ForegroundColor Green
Write-Host "└────────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor Green
Write-Host ""

# ── Installation ──────────────────────────────────────────────────────────────

Write-Host "`nInstalling dependencies...`n"

# 1. Git first (Yazi needs C:\Program Files\Git\usr\bin\file.exe)
Install-WingetPackage -Id "Git.Git" -Name "Git"

# Refresh PATH so git is available immediately
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")

# 2. Remaining winget packages
foreach ($pkg in $wingetPackages | Select-Object -Skip 1) {
    Install-WingetPackage -Id $pkg.Id -Name $pkg.Name
}

# 3. Yazi file.exe path variable (requires Git installed)
[System.Environment]::SetEnvironmentVariable(
    "YAZI_FILE_ONE",
    "C:\Program Files\Git\usr\bin\file.exe",
    [System.EnvironmentVariableTarget]::User
)
Write-Host "  Set YAZI_FILE_ONE"

# 4. Ensure Scoop is installed
if (-not (Get-Command scoop -ErrorAction SilentlyContinue)) {
    Write-Host "  Installing Scoop..."
    Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser -Force
    Invoke-RestMethod https://get.scoop.sh | Invoke-Expression
}

# 5. Choco packages
$env:Path = [System.Environment]::GetEnvironmentVariable("Path", "Machine") + ";" +
            [System.Environment]::GetEnvironmentVariable("Path", "User")
Write-Host "`nInstalling Choco packages...`n"
foreach ($pkg in $chocoPackages) {
    Install-ChocoPackage -Name $pkg
}

# 7. Scoop packages
Write-Host "`nInstalling Scoop packages...`n"
foreach ($pkg in $scoopPackages) {
    Install-ScoopPackage -Name $pkg.Name -Bucket $pkg.Bucket
}

# ── Symlinks ──────────────────────────────────────────────────────────────────

Write-Host "`nCreating symlinks...`n"

# Vencord
Link-Dir "$HomeDir/AppData/Roaming/Vencord/themes" "$Dotfiles/Vencord/themes"
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
# Wallpapers
Link-Dir "$HomeDir/Pictures/Wallpapers" "$Dotfiles/wallpapers"
# WezTerm
Link-File "$HomeDir/.wezterm.lua" "$Dotfiles/wezterm/.wezterm.lua"
# YASB
Link-Dir "$HomeDir/.config/yasb" "$Dotfiles/yasb"
# Flow Launcher.
Link-File "$HomeDir/AppData/Roaming/FlowLauncher/Settings/Settings.json" "$Dotfiles/flowLauncher/Settings.json"
Link-File "$HomeDir/AppData/Roaming/FlowLauncher/Themes/tokyonight.xaml" "$Dotfiles/flowLauncher/tokyonight.xaml"

# ── Manual Steps ──────────────────────────────────────────────────────────────

Write-Host ""
Write-Host "┌────────────────────────────────────────────────────────────────────────────────┐" -ForegroundColor Green
Write-Host "│                                                                                │" -ForegroundColor Green
Write-Host "│                           ✓  Setup complete!                                  │" -ForegroundColor Green
Write-Host "│                                                                                │" -ForegroundColor Green
Write-Host "│   Manual steps required:                                                       │" -ForegroundColor Yellow
Write-Host "│                                                                                │" -ForegroundColor Yellow
Write-Host "│   1. Vencord   https://github.com/Vendicated/Vencord                        │" -ForegroundColor Yellow
Write-Host "│   2. Tacky Borders   https://github.com/lukeyou05/tacky-borders/releases       │" -ForegroundColor Yellow
Write-Host "│                                                                                │" -ForegroundColor Yellow
Write-Host "└────────────────────────────────────────────────────────────────────────────────┘" -ForegroundColor Yellow
Write-Host ""
