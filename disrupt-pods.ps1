#!/usr/local/microsoft/powershell/6/pwsh
while ($true) {
  Write-Output "Starting to delete pods"
  $pods = kubectl get pods -l app=planespotter-frontend --output json | out-string | convertfrom-json
  $target = $pods.items.where{$_.status.phase -match 'running'} | Get-Random -Count 1
  Write-Output "Deleting pod $($target.metadata.name)"
  Start-Sleep -Seconds 10
  kubectl delete pod $target.metadata.name
  Write-Output "Waiting..."
  Start-Sleep -Seconds 15
}
