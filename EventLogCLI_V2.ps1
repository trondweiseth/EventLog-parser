Function log () {


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
    [switch]$local,
    [Parameter(Mandatory=$false,ParameterSetName="LogName")]
    [ValidateSet("system","application","security")]
    [string]$logname
    )
    
	if (!$newest) {$newest = "200"}
	if (!$date) {$date = get-date -Format "MM/dd/yyyy"}
	if ($date -match '\d{1,2}/\d{1,2}/\d{4}' -eq $false) {
		Write-Host -ForegroundColor Red "Invalid date format. Correct format is 'MM/dd/yyyy'"
		break
	}
          
    $uname=("$env:USERDOMAIN\$env:USERNAME")
    $arglst = @("$newest","$time","$logname","$date","$before","$after")

function help() {

    Write-Host -ForegroundColor Green "======================================================================================================================================================"
    Write-Host -ForegroundColor Yellow " Usage:"
    Write-Host -ForegroundColor Yellow "	log [[host] | [-local]] [-newest number] [-time time] [-logname system|application|security] [-date MM/dd/yyyy] [-before time] [-after time]"
    Write-Host "" 
    Write-Host -ForegroundColor Yellow " Options:"
    Write-Host -ForegroundColor Yellow "	-local		Runs the script on the local computer"
    Write-Host -ForegroundColor Yellow "	-newest		Sets the number of logs to be fetched from newest to old (Default 200)"
    Write-Host -ForegroundColor Yellow "	-time		Time when the log was created"
    Write-Host -ForegroundColor Yellow "	-logname	Name of logs to fetch. If not set, all logs will be fetched. [system|application|security]"
    Write-Host -ForegroundColor Yellow "	-date		Date when the log was created"
    Write-Host -ForegroundColor Yellow "	-before		Fetching logs before a given time"
    Write-Host -ForegroundColor Yellow "	-after		Fetching logs after a given time"
    Write-Host ""
    Write-Host -ForegroundColor Yellow " Example:"
    Write-Host ""    
    Write-Host -ForegroundColor Yellow "     log -local -newest 1000 -logname system -date 10/14/2020"
    Write-Host -ForegroundColor Yellow "     log $env:COMPUTERNAME -logname system -before 11:00 -after 10:00 -date 10/14/2020"
    Write-Host -ForegroundColor Green "======================================================================================================================================================"
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
        Get-EventLog -Newest $newest -LogName $logname -after "$date $after" -before "$date $before"
    } elseif ($after) {
        Get-EventLog -Newest $newest -LogName $logname  -after "$date $after"
    } elseif ($before) {
        Get-EventLog -Newest $newest -LogName $logname -before "$date $before"
    } elseif ($date) {
        Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -imatch $date}
    } elseif ($date -and $before) {
        Get-EventLog -Newest $newest -LogName $logname -before "$date $before"
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
            Get-EventLog -Newest $newest -LogName $_ -after "$date $after" -before "$date $before"
            }
     } elseif ($after) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ -after "$date $after"
                }
     } elseif ($before) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ -before "$date $before"
                }
     } elseif ($date) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ | where {$_.TimeGenerated -imatch $date}
                }
     } elseif ($date -and $before) {
            $lognames | ForEach-Object {
                Get-EventLog -Newest $newest -LogName $_ -before "$date $before"
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


if ($local){
    if ($logname) {
        $res = Invoke-Command -ArgumentList ${arglst} -ScriptBlock ${function:parser1}
    } else {
        $res = Invoke-Command -ArgumentList ${arglst} -ScriptBlock ${function:parser2}
    }
    outpars
} else {   
    if ($help -or !$ComputerName) {
         help
    } else {
        $cred = Get-Credential $uname 
        if ($logname) {
            $res = Invoke-Command -ComputerName $ComputerName -Credential $cred -ArgumentList ${arglst} -ScriptBlock ${function:parser1}
        } else {
            $res = Invoke-Command -ComputerName $ComputerName -Credential $cred -ArgumentList ${arglst} -ScriptBlock ${function:parser2}
        }
    }
    outpars
}
