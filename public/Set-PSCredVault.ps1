function Set-PSCredVault {
    param(
        [string[]]
        $Name,
        $VaultPath = (Join-Path $env:UserProfile ".Vault")
     )
     
    ## Setup Vault Folder if not exist
    $test = Test-Path $VaultPath
    if (!$test){
        Write-Host "Path: $VaultPath Doesn't exist, creating now!" -foregroundcolor yellow
        New-Item -Path $VaultPath -ItemType Directory
    }
    
    foreach ($n in $Name){
        $credcount++
        $customCred = Get-Credential -Message "Enter your Credential for $n"
        New-Variable -Name $n -Value $customCred -Scope Global -force
        $outstring = $outstring + ' $' + $n
        $filename = $n + ".xml"
        $path = Join-Path $VaultPath $filename
        $customCred | Export-Clixml -Path $path -force
    }


    if ($credcount -gt 0){
        Write-Host "Credential(s) has been stored to $outstring :: Credential(s) can also be retrieved from $Vaultpath using Import-PSCredVault or Import-Clixml" -foregroundcolor green

    }
    else {
        Write-Error "Must choose a credential option (ex. -DA or -CUSTOM)"
    }
         

}