param(
    [switch]$Staged,
    [string]$GitleaksPath = 'gitleaks'
)

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent $PSScriptRoot
Push-Location -LiteralPath $repoRoot
try {
    $scanner = Get-Command $GitleaksPath -ErrorAction Stop
    $scannerArgs = @('git', '.', '--config', '.gitleaks.toml', '--redact=100', '--no-banner')
    if ($Staged) {
        $scannerArgs += '--staged'
    } else {
        $scannerArgs += '--log-opts=--all'
    }
    & $scanner.Source @scannerArgs
    $scanExit = $LASTEXITCODE
} finally {
    Pop-Location
}
exit $scanExit
