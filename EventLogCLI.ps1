<# .SYNOPSIS

     EventLog parser 

.DESCRIPTION

     Gettng event logs on local or remote PC
     Example : log hostname.osl.basefarm.net -logname system -before 11:00 -after 10:00 -date 10/14

.NOTES

     Author     : Trond Weiseth
#>

param(
    [CmdletBinding()]
    [Parameter(Mandatory=$false,Position=0)][string]$ComputerName,
    [string]$time,
    [string]$newest,
    [string]$before,
    [string]$after,
    [string]$date,
    [switch]$o,
    [switch]$help,
    [Parameter(Mandatory=$false,ParameterSetName="LogName")]
    [ValidateSet("system","application","security")]
    [string]$logname
    )

function help() {

    Write-Host -ForegroundColor Green "###################################################################################################################################"
    Write-Host -ForegroundColor Yellow " Syntax: [log <host> [-newest <number>] [-time <time>] [-logname <logname>] [-date <MM/dd/YYYY>] [-before <time>] [-after <time>]"
    Write-Host -ForegroundColor Green "---------------------"
    Write-Host -ForegroundColor Yellow " Example:"
    Write-Host ""    
    Write-Host -ForegroundColor Yellow "     log -ComputerName $env:COMPUTERNAME -newest 1000 -time 10:10 -logname system -date 10/14/2020"
    Write-Host -ForegroundColor Yellow "     log -logname system -before 11:00 -after 10:00 -date 10/14"
    Write-Host -ForegroundColor Green "###################################################################################################################################"
} 

function parser1() {

    param (
    $newest,
    $time,
    $logname,
    $date,
    $before,
    $after
    )

    if ($after -and $before) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -gt $after -and $_.TimeGenerated -lt $before}
    } elseif ($after) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -gt $after}
    } elseif ($before) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -lt $before}
    } elseif ($date) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -imatch $date}
    } elseif ($date -and $before) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -lt $date -and $_.TimeGenerated -lt $before}
    } elseif ($date -and $before -and $after) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -lt $date -and $_.TimeGenerated -lt $before -and $_.TimeGenerated -lt $after}
    } else {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -imatch "$time"}
    }
}
 
function parser2() {

    param (
    $newest,
    $time,
    $logname,
    $date,
    $before,
    $after
    )

    $lognames="Application","Security","System"

    if ($after -and $before) {
        $lognames | ForEach-Object {
            Get-EventLog -Newest $newest -LogName $_ | where {$_.TimeGenerated -gt $after -and $_.TimeGenerated -lt $before}
            }
     } elseif ($after) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ | where {$_.TimeGenerated -gt $after}
                }
     } elseif ($before) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ | where {$_.TimeGenerated -lt $before}
                }
     } elseif ($date) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ | where {$_.TimeGenerated -imatch $date}
                }
     } elseif ($date -and $before) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ | where {$_.TimeGenerated -lt $date -and $_.TimeGenerated -lt $before}
                }
     } elseif ($date -and $before -and $after) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ | where {$_.TimeGenerated -lt $date -and $_.TimeGenerated -lt $before -and $_.TimeGenerated -lt $after}
                }
     } else {
            $lognames | ForEach-Object {
                Get-EventLog -LogName $_ -Newest $newest | where {$_.TimeGenerated -imatch "$time"}
                }
    }
}

function outpars() {

    if ($o) {
        $res | Format-Table -AutoSize -Wrap
        $res | Format-Table -AutoSize -Wrap | clip
    } else {
        $res | Out-GridView -PassThru |  Format-Table -AutoSize -Wrap | clip
    }
}

if ($ComputerName -and $ComputerName -ne "localhost") {
    $uname=("$env:USERDOMAIN\$env:USERNAME")
    $cred = Get-Credential $uname
    }
    
if ($help) {
  help
  } else {

    if (!$newest) {$newest = "200"}
    
    if ($logname) {

        if (!$ComputerName -or $ComputerName -imatch "localhost") {
            $res = Invoke-Command -ScriptBlock {
                parser1
                }
        } else {
            $res = Invoke-Command -ComputerName $ComputerName -Credential $cred -ArgumentList $newest, $time, $logname, $date, $before, $after -ScriptBlock ${function:parser1}
        }
        outpars
    } else {
        if (!$ComputerName -or $ComputerName -imatch "localhost") {
            $res = Invoke-Command -ScriptBlock {
                $lognames="Application","Security","System"
                parser2
                }
        } else {
            $res = Invoke-Command -ComputerName $ComputerName -Credential $cred -ArgumentList $newest, $time, $logname, $date, $before, $after -ScriptBlock ${function:parser2}
        }
        outpars
    }
}
