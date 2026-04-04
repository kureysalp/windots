oh-my-posh init pwsh --config "$HOME\Documents\OhMyPoshThemes\catppuccin_frappe.omp.json" | Invoke-Expression

try {
    [Console]::InputEncoding  = [System.Text.Encoding]::UTF8
    [Console]::OutputEncoding = [System.Text.Encoding]::UTF8
    $OutputEncoding = [System.Text.UTF8Encoding]::new($false)
    chcp 65001 > $null
} catch {}

Clear-Host

if (Get-Command fastfetch -ErrorAction SilentlyContinue) {
    fastfetch -c "$HOME\.config\fastfetch\config.jsonc"
}

# Aliases

Set-Alias rename rename-item
Set-Alias -Name clear -Value Invoke-ClearWithFetch -Force -Option AllScope
Set-Alias y yazi

# Functions

function relp { . $PROFILE } # Reload Profile

function Invoke-ClearWithFetch {
[Console]::Clear()
fastfetch
}

function touch {
    <#
    .SYNOPSIS
        Creates a new file with the specified name and extension
    #>
    Param (
        [Parameter(ValueFromRemainingArguments = $true)]
        [string[]]$files
    )

    if ($files -le 0) {
        write-host -foregroundColor Magenta 
            "Provide a file name."
        break
    }

    foreach($file in $files) {
        "" > $file
    }
}

# Import the Chocolatey Profile that contains the necessary code to enable
# tab-completions to function for `choco`.
# Be aware that if you are missing these lines from your profile, tab completion
# for `choco` will not function.
# See https://ch0.co/tab-completion for details.
$ChocolateyProfile = "$env:ChocolateyInstall\helpers\chocolateyProfile.psm1"
if (Test-Path($ChocolateyProfile)) {
  Import-Module "$ChocolateyProfile"
}
