Import-Module ActiveDirectory            

$username = Read-Host "What's the username?"        
$userobj  = Get-ADUser $username
$svr = "<primary DC name>"

Get-ADUser $userobj.DistinguishedName -Properties memberOf |            
 Select-Object -ExpandProperty memberOf |            
 ForEach-Object {     
    $date = @{label="Date first membership";expression={$_.FirstOriginatingCreateTime}}
    $group = @{label="Group name";expression={((($_.Object -split "=")[1]) -split ",")[0]}}
    $av = @{label="Extra data";expression={$_.AttributeValue}}
    Get-ADReplicationAttributeMetadata $_ -Server $svr -ShowAllLinkedValues |             
      Where-Object {$_.AttributeName -eq 'member' -and             
      $_.AttributeValue -eq $userobj.DistinguishedName -and
      $_.FirstOriginatingCreateTime -ne ""} |            
      Select-Object $date, $group, $av
    } | Sort-Object -Property @{Expression = "Group name"; Descending = $false} | Out-GridView
