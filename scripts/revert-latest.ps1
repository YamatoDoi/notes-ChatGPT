# Reverts the latest or specified commit, then pushes the revert commit.
param(
    [Parameter(Mandatory = $false)]
    [string]$Target = "HEAD"
)

$ErrorActionPreference = "Stop"

function Test-GitRepository {
    <#
    .SYNOPSIS
    Checks whether the current directory is inside a Git repository.

    .OUTPUTS
    Boolean
    #>
    $insideRepository = git rev-parse --is-inside-work-tree 2>$null
    return $insideRepository -eq "true"
}

function Get-WorkingTreeStatus {
    <#
    .SYNOPSIS
    Gets uncommitted working tree changes.

    .OUTPUTS
    String[]
    #>
    return git status --short
}

if (-not (Test-GitRepository)) {
    throw "Run this script inside a Git repository."
}

$changedFiles = Get-WorkingTreeStatus

if ($changedFiles) {
    Write-Host "Uncommitted changes exist. Aborting revert."
    $changedFiles | ForEach-Object { Write-Host "  $_" }
    throw "Clean the working tree before reverting."
}

git revert --no-edit $Target
git push

Write-Host "Revert commit was pushed: $Target"
