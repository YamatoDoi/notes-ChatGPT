# Publishes note changes by staging, committing, and pushing them.
param(
    [Parameter(Mandatory = $false)]
    [string]$Message,

    [Parameter(Mandatory = $false)]
    [switch]$NoPush
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
    Gets working tree changes that can be committed.

    .OUTPUTS
    String[]
    #>
    return git status --short
}

function New-DefaultCommitMessage {
    <#
    .SYNOPSIS
    Creates the default commit message when none is provided.

    .OUTPUTS
    String
    #>
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    return "Update notes $timestamp"
}

if (-not (Test-GitRepository)) {
    throw "Run this script inside a Git repository."
}

$changedFiles = Get-WorkingTreeStatus

if (-not $changedFiles) {
    Write-Host "No changes to commit."
    exit 0
}

Write-Host "Current changes:"
$changedFiles | ForEach-Object { Write-Host "  $_" }

if ([string]::IsNullOrWhiteSpace($Message)) {
    $Message = New-DefaultCommitMessage
    Write-Host "No commit message was provided. Using default: $Message"
}

git add --all

git diff --cached --quiet
$diffExitCode = $LASTEXITCODE

if ($diffExitCode -eq 0) {
    $hasStagedChanges = $false
} elseif ($diffExitCode -eq 1) {
    $hasStagedChanges = $true
} else {
    throw "Failed to inspect staged changes."
}

if (-not $hasStagedChanges) {
    Write-Host "No staged changes."
    exit 0
}

git commit -m $Message

if ($NoPush) {
    Write-Host "NoPush was specified. Skipping push."
    exit 0
}

git push
Write-Host "Commit and push completed."
