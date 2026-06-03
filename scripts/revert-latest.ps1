# 直近または指定したコミットをrevertし、取り下げコミットをpushします。
param(
    [Parameter(Mandatory = $false)]
    [string]$Target = "HEAD"
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
    作業ツリーの未コミット変更を取得します。

    .OUTPUTS
    String[]
    #>
    return git status --short
}

if (-not (Test-GitRepository)) {
    throw "このスクリプトはGitリポジトリ内で実行してください。"
}

$changedFiles = Get-WorkingTreeStatus

if ($changedFiles) {
    Write-Host "未コミットの変更があるため、取り下げを中止します。"
    $changedFiles | ForEach-Object { Write-Host "  $_" }
    throw "取り下げ前に作業ツリーをクリーンにしてください。"
}

git revert --no-edit $Target
git push

Write-Host "取り下げコミットをpushしました: $Target"
