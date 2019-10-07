#!/usr/local/microsoft/powershell/6/pwsh

while ($true) {
  try {
    $time = Measure-Command {$return = Invoke-WebRequest -Uri https://planespotter.59s.io -ErrorAction Stop -TimeoutSec 5}
    Write-Output "Curled https://planespotter.59s.io, return code $($return.StatusCode), $($time.Milliseconds) milliseconds"
} 
  catch {
    Write-Output "Failed to curl https://planespotter.59s.io"
  }
  
  Start-Sleep -Seconds 1
}
	