

<# .SYNOPSIS

     EventLog parser 

.DESCRIPTION

     Gettng event logs on remote PC
     Example : 
              log -ComputerName contoso.local -newest 1000 -time 10:10 -logname system -date 14/10
              log contoso.local -after 10:00 -before 11:00 -date 14/10/2020 -o

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
    
    if ($date -imatch 'day' -or $date -imatch 'today' -or $date -imatch 'current' -or $date -imatch 'now') {
          $date = $(get-date -Format MM/dd)
    }
          
    $uname=("$env:USERDOMAIN\$env:USERNAME")
    $cred = Get-Credential $uname
    $arglst = @("$newest","$time","$logname","$date","$before","$after")

function help() {

    Write-Host -ForegroundColor Green "###################################################################################################################################"
    Write-Host -ForegroundColor Yellow " Syntax: [log <host> [-newest <number>] [-time <time>] [-logname <logname>] [-date <MM/dd/yyyy>] [-before <time>] [-after <time>]"
    Write-Host -ForegroundColor Green "---------------------"
    Write-Host -ForegroundColor Yellow " Example:"
    Write-Host ""    
    Write-Host -ForegroundColor Yellow "     log -ComputerName $env:COMPUTERNAME -newest 1000 -time 10:10 -logname system -date 10/14/2020"
    Write-Host -ForegroundColor Yellow "     log $env:COMPUTERNAME -logname system -before 11:00 -after 10:00 -date current"
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
    
    if (!$newest) {$newest = "200"}
    if ($after -and $before) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -gt $after -and $_.TimeGenerated -lt $before}
    } elseif ($after) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -gt $after}
    } elseif ($before) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -lt $before}
    } elseif ($date) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -imatch $date}
    } elseif ($date -and $before) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -imatch $date -and $_.TimeGenerated -lt $before}
    } elseif ($date -and $before -and $after) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -imatch $date -and $_.TimeGenerated -lt $before -and $_.TimeGenerated -gt $after}
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
    
    if (!$newest) {$newest = "200"}
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
                Get-EventLog -Newest $newest -LogName $_ | where {$_.TimeGenerated -imatch $date -and $_.TimeGenerated -lt $before}
                }
     } elseif ($date -and $before -and $after) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ | where {$_.TimeGenerated -imatch $date -and $_.TimeGenerated -lt $before -and $_.TimeGenerated -gt $after}
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
    
if ($help -or !$ComputerName) {
     help
} else {
    if ($logname) {
        $res = Invoke-Command -ComputerName $ComputerName -Credential $cred -ArgumentList ${arglst} -ScriptBlock ${function:parser1}
    } else {
        $res = Invoke-Command -ComputerName $ComputerName -Credential $cred -ArgumentList ${arglst} -ScriptBlock ${function:parser2}
    }
}
outpars
