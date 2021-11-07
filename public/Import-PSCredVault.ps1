function Import-PSCredVault {
    param(
        $VaultPath = (Join-Path $env:UserProfile ".Vault")
     )

    ## Test Vault Folder
    if (!(Test-Path $VaultPath)){
        Write-Error "Path: $VaultPath Doesn't exist. Exiting."
        return
    }

    ## Test Vault for Entries
    $keys = Get-ChildItem $VaultPath
    if (!$keys){
        Write-Warning "Path: $VaultPath exists, but has no entries. Exiting."
        return
    }

    $outstring = ""
    foreach ($key in $keys){

        New-Variable -Name $key.basename -Value (Import-Clixml -path $key.Fullname) -Scope Global -Force
        $outstring = $outstring + " $" + "$($key.basename)"

    }
        Write-Verbose "Credential have been stored to $outstring"

}# end function