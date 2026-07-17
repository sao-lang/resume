<#
.SYNOPSIS
    Build script -- compile resume.typ to resume.pdf
.DESCRIPTION
    Uses Typst to compile the resume PDF. Supports single build and watch mode.
.PARAMETER Watch
    Enable watch mode, auto-recompile on file changes.
.PARAMETER Output
    Output filename, defaults to resume.pdf.
.PARAMETER Help
    Show help.
.EXAMPLE
    .\build.ps1                 # single build
    .\build.ps1 -Watch          # watch mode
    .\build.ps1 -Output my.pdf  # custom output
#>

param(
  [switch]$Watch,
  [string]$Output = "resume.pdf",
  [switch]$Help
)

if ($Help) {
  Get-Help $PSCommandPath -Detailed
  exit 0
}

$InputFile = "resume.typ"
$ScriptDir = Split-Path -Parent $PSCommandPath
Push-Location $ScriptDir

# ---------- dependency check ----------
function Test-Requirement {
  $typst = Get-Command "typst" -ErrorAction SilentlyContinue
  if (-not $typst) {
    Write-Host "[ERROR] Typst not found!" -ForegroundColor Red
    Write-Host "Install: winget install Typst.Typst" -ForegroundColor Cyan
    Write-Host "Or: https://github.com/typst/typst/releases" -ForegroundColor Cyan
    exit 1
  }

  if (-not (Test-Path $InputFile)) {
    Write-Host "[ERROR] Input file not found: $InputFile" -ForegroundColor Red
    exit 1
  }
}

# ---------- build ----------
function Invoke-Build {
  $version = (typst --version | Select-String -Pattern "\d+\.\d+\.\d+").Matches.Value
  Write-Host "Typst $version  --  building $InputFile -> $Output" -ForegroundColor Green

  if ($Watch) {
    Write-Host "Watch mode active, recompiling on save..." -ForegroundColor Cyan
    typst watch $InputFile $Output
  } else {
    typst compile $InputFile $Output
    if ($LASTEXITCODE -eq 0) {
      Write-Host "OK  build success: $Output" -ForegroundColor Green
    } else {
      Write-Host "FAIL  build failed, check errors above." -ForegroundColor Red
    }
  }
}

# ---------- run ----------
Test-Requirement
Invoke-Build
Pop-Location
