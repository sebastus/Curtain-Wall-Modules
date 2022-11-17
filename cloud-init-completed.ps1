param(

    [Parameter(Mandatory=$true)]
    [string]
    $mi_resource_id,

    [Parameter(Mandatory=$true)]
    [string]
    $vm_resource_id
)

# authenticate using user assigned MI
az login --identity -u $mi_resource_id

# max_time = 15 minutes
$max_elapsed_time_in_minutes = 15

$start_time = Get-Date

do
{
    $tag_value = $(az tag list --resource-id $vm_resource_id --query properties.tags.CI_Finished -o tsv)

    if ($tag_value -eq "true") {
        Write-Verbose "VM is tagged with CI_Finished"
        break
    }

#     if (time elapsed) exit 1
    $now = Get-Date
    $elapsed = New-TimeSpan -start $start_time -end $now
    if ($elapsed.TotalMinutes -gt $max_elapsed_time_in_minutes) {
        Write-Warning "CI_Finished tag not on VM after $max_elapsed_time_in_minutes minutes."
        exit 1
    }

    Write-Verbose "Waiting 1 minute"

#     wait 1 minute
    Start-Sleep -Second 60

# } while (time has not elapsed);
} while ($true)
