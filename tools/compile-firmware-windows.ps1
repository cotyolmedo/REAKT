param(
  [ValidateSet('Node','Gateway')][string]$Target = 'Node',
  [ValidateSet('Off','Digital','Pixels')][string]$Led = 'Off',
  [string]$ArduinoCli = 'C:/Program Files/Arduino IDE/resources/app/lib/backend/resources/arduino-cli.exe',
  [string]$Fqbn = 'esp32:esp32:esp32'
)
$ErrorActionPreference = 'Stop'
$reaktRoot = Split-Path -Parent $PSScriptRoot
$reaktSketch = if ($Target -eq 'Node') { 'nodes/REAKT_Node' } else { 'gateway/REAKT_Gateway' }
$reaktOutput = Join-Path $reaktRoot ('build/windows-' + $Target.ToLower() + '-' + $Led.ToLower())
$reaktArguments = @('compile', '--fqbn', $Fqbn, '--library', (Join-Path $reaktRoot 'firmware/libraries/ReaktCore'), '--build-path', $reaktOutput, '-j', '2')
if ($Target -eq 'Node') {
  $reaktFlags = switch ($Led) {
    'Off' { '-DREAKT_LED_ENABLED=0' }
    'Digital' { '-DREAKT_LED_ENABLED=1 -DREAKT_LED_DIGITAL=1' }
    'Pixels' { '-DREAKT_LED_ENABLED=1 -DREAKT_LED_DIGITAL=0' }
  }
  $reaktArguments += @('--build-property', ('compiler.cpp.extra_flags=' + $reaktFlags))
}
$reaktArguments += (Join-Path $reaktRoot ('firmware/' + $reaktSketch))
& $ArduinoCli @reaktArguments
if ($LASTEXITCODE -ne 0) { throw "Compilation failed ($LASTEXITCODE). No upload was attempted." }
Write-Output "Compiled: $reaktOutput. No upload was attempted. Physical configuration remains to be checked."
