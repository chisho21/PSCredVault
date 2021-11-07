function Clear-PSCredVault {
    param(
        $VaultPath = (Join-Path $env:UserProfile ".Vault"),
        [Switch]
        $Force
     )

    ## Test Vault Folder
    if (!(Test-Path $VaultPath)){
        Write-Error "Path: $VaultPath Doesn't exist. Exiting."
        return
    }

    ## Test Vault for Entries
    $keys = Get-ChildItem $VaultPath
    if (!$keys){
        Write-Error "Path: $VaultPath exists, but has no entries to clear. Exiting."
        return
    }
    
    if (!$Force){
        $Confirm = Read-Host -Prompt "Are you sure you want to remove ALL of the above credentials? [y/n]"
        if ($Confirm -like "y"){
            Write-Verbose "Deletion Confirmed. Executing"
        }
        else {
            Write-Error "Deletion NOT Confirmed. Exiting please check folder $VaultPath"
            return
        }
    }

    foreach ($key in $keys){
        Remove-Item -Path $key.FullName -force -verbose

    }
        Write-Verbose "PSCredVault has been cleared"

}# end function