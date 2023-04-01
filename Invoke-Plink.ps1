<#
.SYNOPSIS
 Invoke-Plink
.DESCRIPTION
  Run shell commands using plink from Windows using U/P or PPK key.
  Plink.exe must be in the same directory as the module this command is placed in
  Mcurry
#>

$ScriptPath = $MyInvocation.MyCommand.Path
$Dir = Split-Path $scriptpath
$Script:Plink = "$Dir\Plink.exe"
$script:Key =  "$Dir\Auth.ppk"

function Invoke-PlinkCmd {
    param(
    [string]$Ip,
    [string]$UserName,
    [string] $Cmd
    )


    $ErrorActionPreference = 'silentlycontinue'
    If (-not (Test-path $Plink)) {
      Throw 'Unable to locate Plink.exe'
    }

     If (-not (Test-path $Key)) {
      Throw 'Unable to locate Authentication key'
    }

    $null = Write-output y |
        &($Plink) -i $Key $UserName@$IP 'exit'
    
    try {
        #Execute command using PPK auth
        $Results = Write-Output y |
            &($Plink) -batch -i $Key $UserName@$IP $Cmd 
    }
    catch {
        $Results = "Error: $($_.Exception.Message)"
    }
                
    $ErrorActionPreference = 'continue'
    Return $Results
} # End Invoke-Plink function
