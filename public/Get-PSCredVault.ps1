function Get-PSCredVault {
    param(
        [string[]]
        $Name,
        [switch]
        $RevealPasswords,
        $VaultPath = (Join-Path $env:UserProfile ".Vault")
     )

     ## Test Vault Folder
    if (!(Test-Path $VaultPath)){
        Write-Error "Path: $VaultPath Doesn't exist. Exiting."
        return
    }

    ## Gather Creds based on filters
    $keys = Get-ChildItem $VaultPath
    if ($Name){
        $keys = $keys | Where-Object {$Name -contains $_.BaseName}
    }

    if ($keys){
        #$keys | % {}
        foreach ($key in $keys){
            $cred = Import-Clixml $key.FullName
            $props = @{
                Name = $key.BaseName
                UserName = $cred.UserName
                WhenCreated = $key.CreationTime
                WhenModified = $key.LastWriteTime
                FullPath = $key.FullName
            }
            if ($RevealPasswords){
                $props['Password'] = $cred.GetNetworkCredential().password
            }
            else {
                $props['Password'] = "********"
            }
            $obj = New-Object -TypeName psobject -Property $props
            $obj.psobject.typenames.insert(0,'PSCredvault.Cred')
            Write-Output $obj

        }
    }
    else {
        Write-Warning "No Creds found in $VaultPath"
    }

}
