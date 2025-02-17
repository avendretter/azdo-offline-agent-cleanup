# Read .env file
$envContent = Get-Content .\.env
$envVars = @{}
foreach ($line in $envContent) {
    if ($line -match '(.+)=(.+)') {
        $envVars[$matches[1]] = $matches[2]
    }
}

# Set variables from .env
$PAT = $envVars['PAT']
$OrganizationName = $envVars['ORGANIZATION_NAME']
$ApiVersion = $envVars['API_VERSION']
$PoolsList = $envVars['POOLS_LIST'].Split(',')

# Validate required variables
if ([string]::IsNullOrEmpty($PAT) -or [string]::IsNullOrEmpty($OrganizationName)) {
    throw "PAT and ORGANIZATION_NAME are required in the .env file"
}

[Net.ServicePointManager]::SecurityProtocol = [Net.SecurityProtocolType]::Tls12
$EncodedPAT = [System.Convert]::ToBase64String([System.Text.Encoding]::UTF8.GetBytes(":$PAT"))
$PoolsUrl = "https://dev.azure.com/$($OrganizationName)/_apis/distributedtask/pools?api-version=$($ApiVersion)"
try {
  $Pools = (Invoke-RestMethod -Uri $PoolsUrl -Method 'Get' -Headers @{Authorization = "Basic $EncodedPAT"}).value
} catch {
  throw $_.Exception
}

If ($Pools) {
  foreach ($Pool in $PoolsList){ 
    Write-Output "Checking Pool $($Pool) for Organization $($OrganizationName)"
    $PoolId = ($Pools | Where-Object { $_.Name -eq $Pool }).id
    $AgentsUrl = "https://dev.azure.com/$($OrganizationName)/_apis/distributedtask/pools/$($PoolId)/agents?api-version=$($ApiVersion)"
    $Agents = (Invoke-RestMethod -Uri $AgentsUrl -Method 'Get' -Headers @{Authorization = "Basic $EncodedPAT"}).value

    if ($Agents) {
      $OfflineAgents = ($Agents | Where-Object { $_.status -eq 'offline'})
      foreach ($OfflineAgent in $OfflineAgents) {
        $OfflineAgentName = $OfflineAgent.Name
        $OfflineAgentId = $OfflineAgent.id
        Write-Output "Removing: $($OfflineAgentName) From Pool: $($Pool) in Organization: $($OrganizationName)"
        $OfflineAgentsUrl = "https://dev.azure.com/$($OrganizationName)/_apis/distributedtask/pools/$($PoolId)/agents/$($OfflineAgentId)?api-version=$($ApiVersion)"
        Invoke-RestMethod -Uri $OfflineAgentsUrl -Method 'Delete' -Headers @{Authorization = "Basic $EncodedPAT"}
      }
    } else {
      Write-Output "No Agents found in $($Pool) for Organization $($OrganizationName)"
    }
  }
} else {
  Write-Output "No Pools found in Organization $($OrganizationName)"
}