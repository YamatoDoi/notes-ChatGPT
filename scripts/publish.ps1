# 技術ノートの差分確認、コミット、pushを1コマンドで実行します。
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
    現在位置がGitリポジトリ内か確認します。

    .OUTPUTS
    Boolean
    #>
    $insideRepository = git rev-parse --is-inside-work-tree 2>$null
    return $insideRepository -eq "true"
}

function Get-WorkingTreeStatus {
    <#
    .SYNOPSIS
    コミット対象になり得る作業ツリーの変更を取得します。

    .OUTPUTS
    String[]
    #>
    return git status --short
}

function New-DefaultCommitMessage {
    <#
    .SYNOPSIS
    コミットメッセージ未指定時の既定メッセージを作成します。

    .OUTPUTS
    String
    #>
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    return "Update notes $timestamp"
}

if (-not (Test-GitRepository)) {
    throw "このスクリプトはGitリポジトリ内で実行してください。"
}

$changedFiles = Get-WorkingTreeStatus

if (-not $changedFiles) {
    Write-Host "コミットする変更はありません。"
    exit 0
}

Write-Host "現在の変更:"
$changedFiles | ForEach-Object { Write-Host "  $_" }

if ([string]::IsNullOrWhiteSpace($Message)) {
    $Message = New-DefaultCommitMessage
    Write-Host "コミットメッセージ未指定のため、既定メッセージを使用します: $Message"
}

git add --all

git diff --cached --quiet
$diffExitCode = $LASTEXITCODE

if ($diffExitCode -eq 0) {
    $hasStagedChanges = $false
} elseif ($diffExitCode -eq 1) {
    $hasStagedChanges = $true
} else {
    throw "ステージ済み差分の確認に失敗しました。"
}

if (-not $hasStagedChanges) {
    Write-Host "ステージ済みの変更はありません。"
    exit 0
}

git commit -m $Message

if ($NoPush) {
    Write-Host "NoPushが指定されたため、pushは実行しません。"
    exit 0
}

git push
Write-Host "コミットとpushが完了しました。"
