param(

    [Parameter(Mandatory=$true)]
    [string]
    $org,

    [Parameter(Mandatory=$true)]
    [string]
    $pool,

    [Parameter(Mandatory=$true)]
    [string]
    $demand

)

# get poolid
$pool_id = (az pipelines pool list --pool-name $pool --org https://dev.azure.com/$org --query [0].id -o tsv)

# max_time = 15 minutes
$max_elapsed_time_in_minutes = 15

$start_time = Get-Date

# do {
do
{

#     get agentid
    $agent_id = (az pipelines agent list --pool-id $pool_id --org https://dev.azure.com/$org --demands $demand --query [0].id -o tsv)

#     if (got agentid) break;
    if ($agent_id -ne $null) {
        Write-Verbose "Got the agent id: $agent_id"
        break
    }

#     if (time elapsed) exit 1
    $now = Get-Date
    $elapsed = New-TimeSpan -start $start_time -end $now
    if ($elapsed.TotalMinutes -gt $max_elapsed_time_in_minutes) {
        Write-Warning "Agent does not exist after $max_elapsed_time_in_minutes minutes."
        exit 1
    }

    Write-Verbose "Waiting 1 minute"

#     wait 1 minute
    Start-Sleep -Second 60

# } while (time has not elapsed);
} while ($true)

# do {
do
{

#     get agent status
    $agent_status = (az pipelines agent show --pool-id $pool_id --agent-id $agent_id --org https://dev.azure.com/$org --query status -o tsv)

#     if (agent status is online) exit 0
    if ($agent_status -eq 'online') {
        Write-Verbose "Agent status is online."
        exit 0
    }

#     if (time elapsed) exit 1
    $now = Get-Date
    $elapsed = New-TimeSpan -start $start_time -end $now
    if ($elapsed.TotalMinutes -gt $max_elapsed_time_in_minutes) {
        Write-Warning "Agent is not online after $max_elapsed_time_in_minutes minutes."
        exit 1
    }

    Write-Verbose "Waiting 1 minute"

#     wait 1 minute
    Start-Sleep -Second 60

# } while (agent status != online)
} while ($true)
