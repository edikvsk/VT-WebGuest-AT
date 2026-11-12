#Requires -Version 5.1

param(
    [string]$TestPath = "test",
    [Parameter(ValueFromRemainingArguments = $true)]
    [string[]]$PytestArgs
)

$ErrorActionPreference = "Stop"
$projectRoot = Split-Path -Parent $PSScriptRoot
$venvPython = Join-Path $projectRoot ".venv\Scripts\python.exe"
$browserEnv = Join-Path $projectRoot ".tools\.env.browser.ps1"

if (Test-Path -LiteralPath $browserEnv) {
    . $browserEnv
}

Push-Location -LiteralPath $projectRoot
try {
    if (Test-Path -LiteralPath $venvPython) {
        & $venvPython -m pytest $TestPath @PytestArgs
    } else {
        & py -3 -m pytest $TestPath @PytestArgs
    }
    $pytestExitCode = $LASTEXITCODE
} finally {
    Pop-Location
}
exit $pytestExitCode
