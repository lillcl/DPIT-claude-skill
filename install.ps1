# claude-dpit install script (Windows)
#
# This script installs the DPIT skill to your Claude Code skills directory.
# Usage: .\install.ps1 [-Uninstall]

param(
    [switch]$Uninstall
)

$SkillDir = "$env:USERPROFILE\.claude\skills\dpit"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

if ($Uninstall) {
    if (Test-Path $SkillDir) {
        Remove-Item -Recurse -Force $SkillDir
        Write-Host "Uninstalled DPIT skill from $SkillDir"
    } else {
        Write-Host "DPIT skill not found at $SkillDir"
    }
    exit 0
}

Write-Host "Installing claude-dpit skill..."

if (Test-Path $SkillDir) {
    Write-Host "Warning: $SkillDir already exists."
    $response = Read-Host "Overwrite? [y/N]"
    if ($response -ne "y" -and $response -ne "Y") {
        Write-Host "Installation cancelled."
        exit 1
    }
    Remove-Item -Recurse -Force $SkillDir
}

$skillsDir = "$env:USERPROFILE\.claude\skills"
if (-not (Test-Path $skillsDir)) {
    New-Item -ItemType Directory -Path $skillsDir | Out-Null
}

# Try using git clone, fall back to direct copy if not a git repo
$gitRepoDir = Join-Path $env:TEMP "dpit-clone-$(Get-Random)"
$gitCloneSuccess = $false
try {
    git clone https://github.com/lillcl/DPIT-claude-skill.git $gitRepoDir 2>$null
    if ($LASTEXITCODE -eq 0 -and (Test-Path (Join-Path $gitRepoDir "skills\dpit"))) {
        Copy-Item -Recurse (Join-Path $gitRepoDir "skills\dpit") $SkillDir
        Remove-Item -Recurse -Force $gitRepoDir -ErrorAction SilentlyContinue
        $gitCloneSuccess = $true
        Write-Host "Installed DPIT skill to $SkillDir via git clone"
    }
} catch {
    # Will fall through to fallback
}

if (-not $gitCloneSuccess) {
    # Fallback: copy directly from repo directory
    $fallbackSource = Join-Path $RepoDir "skills\dpit"
    if (Test-Path $fallbackSource) {
        Copy-Item -Recurse $fallbackSource $SkillDir
        Write-Host "Installed DPIT skill to $SkillDir via direct copy"
    } else {
        Write-Error "Installation failed: git clone unsuccessful and fallback source not found at $fallbackSource"
        exit 1
    }
}

Write-Host ""
Write-Host "To use, restart Claude Code or start a new session, then run:"
Write-Host "  /dpit"
