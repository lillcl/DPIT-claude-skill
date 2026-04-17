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

Copy-Item -Recurse "$RepoDir\skills\dpit" $SkillDir

Write-Host "Installed DPIT skill to $SkillDir"
Write-Host ""
Write-Host "To use, restart Claude Code or start a new session, then run:"
Write-Host "  /dpit"
