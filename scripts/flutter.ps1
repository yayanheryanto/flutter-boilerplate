param(
  [Parameter(Mandatory = $true, Position = 0)]
  [ValidateSet('run', 'build-apk')]
  [string]$Action,

  [Parameter(Mandatory = $true, Position = 1)]
  [ValidateSet('dev', 'stag', 'prod')]
  [string]$Flavor,

  [switch]$Release,
  [switch]$SplitPerAbi,
  [switch]$Verbose
)

Set-StrictMode -Version Latest
$ErrorActionPreference = 'Stop'

$repoRoot = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$flutterFromFvm = Join-Path $repoRoot '.fvm\flutter_sdk\bin\flutter.bat'
$flutter = if (Test-Path $flutterFromFvm) { $flutterFromFvm } else { 'flutter' }

$targets = @{
  dev  = 'lib/main.dev.dart'
  stag = 'lib/main.stag.dart'
  prod = 'lib/main.dart'
}
$target = $targets[$Flavor]

$args = @()
switch ($Action) {
  'run' {
    $args = @('run', '--flavor', $Flavor, '-t', $target)
    if ($Release) { $args += '--release' } else { $args += '--debug' }
  }
  'build-apk' {
    $args = @('build', 'apk', '--release', '--flavor', $Flavor, '-t', $target)
    if ($SplitPerAbi) { $args += '--split-per-abi' }
  }
}

if ($Verbose) { $args += '-v' }

Push-Location $repoRoot
try {
  & $flutter @args
} finally {
  Pop-Location
}

