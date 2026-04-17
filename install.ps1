# claude-dpit install script (Windows)
#
# This script installs the DPIT skill to your Claude Code skills directory.

$SkillDir = "$env:USERPROFILE\.claude\skills\dpit"
$RepoDir = Split-Path -Parent $MyInvocation.MyCommand.Path

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
try {
    git clone https://github.com/lillcl/DPIT-claude-skill.git $gitRepoDir 2>$null
    if (Test-Path (Join-Path $gitRepoDir "skills\dpit")) {
        Copy-Item -Recurse (Join-Path $gitRepoDir "skills\dpit") $SkillDir
        Remove-Item -Recurse -Force $gitRepoDir -ErrorAction SilentlyContinue
        Write-Host "Installed DPIT skill to $SkillDir via git clone"
    } else {
        throw "Git clone did not contain skills/dpit"
    }
} catch {
    # Fallback: copy directly from repo directory
    Copy-Item -Recurse "$RepoDir\skills\dpit" $SkillDir
    Write-Host "Installed DPIT skill to $SkillDir via direct copy"
}

Write-Host ""
Write-Host "To use, restart Claude Code or start a new session, then run:"
Write-Host "  /dpit"
