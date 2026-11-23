param(
    [ValidateSet("antigravity", "claude", "all")]
    [string]$Target = "antigravity"
)

$ErrorActionPreference = "Stop"
$SkillName = "guidedocx"
$SourceDir = Join-Path $PSScriptRoot "..\skills\$SkillName"

if (-not (Test-Path $SourceDir)) {
    Write-Error "Skill source directory not found at $SourceDir"
}

$Destinations = @()
if ($Target -eq "antigravity" -or $Target -eq "all") {
    $Destinations += Join-Path $env:USERPROFILE ".gemini\antigravity\skills\$SkillName"
}
if ($Target -eq "claude" -or $Target -eq "all") {
    $Destinations += Join-Path $env:USERPROFILE ".claude\skills\$SkillName"
}

foreach ($Dest in $Destinations) {
    if (Test-Path $Dest) {
        Remove-Item -Path $Dest -Recurse -Force
    }
    New-Item -ItemType Directory -Path $Dest -Force | Out-Null
    Copy-Item -Path "$SourceDir\*" -Destination $Dest -Recurse -Force
    Write-Host "[OK] Installed '$SkillName' to $Dest" -ForegroundColor Green
}