

<# .SYNOPSIS
     EventLog parser
.DESCRIPTION
     Gettng event logs on local or remote PC
.NOTES
     Author     : Trond Weiseth
#>

Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = New-Object System.Drawing.Point(405,252)
$Form.TopMost                    = $false

$Groupbox1                       = New-Object system.Windows.Forms.Groupbox
$Groupbox1.height                = 37
$Groupbox1.width                 = 409
$Groupbox1.location              = New-Object System.Drawing.Point(-3,-2)
$Groupbox1.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#b8e986")

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Eventlog Parser"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(11,12)
$Label1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10,[System.Drawing.FontStyle]([System.Drawing.FontStyle]::Bold))

$computername1                   = New-Object system.Windows.Forms.TextBox
$computername1.multiline         = $false
$computername1.width             = 145
$computername1.height            = 20
$computername1.location          = New-Object System.Drawing.Point(122,38)
$computername1.Font              = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$computername1.Add_Click( { $this.SelectAll(); $this.Focus() })
$computername1.Add_KeyDown({if ($_.KeyCode -eq "Enter") { log }})

$all                             = New-Object system.Windows.Forms.RadioButton
$all.text                        = "All"
$all.AutoSize                    = $true
$all.width                       = 82
$all.height                      = 26
$all.location                    = New-Object System.Drawing.Point(10,95)
$all.Font                        = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$system                          = New-Object system.Windows.Forms.RadioButton
$system.text                     = "System"
$system.AutoSize                 = $true
$system.width                    = 82
$system.height                   = 26
$system.location                 = New-Object System.Drawing.Point(10,69)
$system.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$security                        = New-Object system.Windows.Forms.RadioButton
$security.text                   = "Security"
$security.AutoSize               = $true
$security.width                  = 82
$security.height                 = 26
$security.location               = New-Object System.Drawing.Point(10,43)
$security.Font                   = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$application                     = New-Object system.Windows.Forms.RadioButton
$application.text                = "Application"
$application.AutoSize            = $true
$application.width               = 82
$application.height              = 26
$application.location            = New-Object System.Drawing.Point(10,17)
$application.Font                = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$newest1                         = New-Object system.Windows.Forms.TextBox
$newest1.multiline               = $false
$newest1.width                   = 145
$newest1.height                  = 20
$newest1.Text                    = "200"
$newest1.location                = New-Object System.Drawing.Point(122,65)
$newest1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$newest1.Add_Click( { $this.SelectAll(); $this.Focus() })
$newest1.Add_KeyDown({if ($_.KeyCode -eq "Enter") { log }})

$Groupbox2                       = New-Object system.Windows.Forms.Groupbox
$Groupbox2.height                = 121
$Groupbox2.width                 = 112
$Groupbox2.text                  = "EventLogs"
$Groupbox2.location              = New-Object System.Drawing.Point(1,36)
$Groupbox2.BackColor             = [System.Drawing.ColorTranslator]::FromHtml("#9b9b9b")

$date1                           = New-Object system.Windows.Forms.TextBox
$date1.multiline                 = $false
$date1.width                     = 145
$date1.height                    = 20
$date1.Text                      = $(get-date -Format MM/dd)
$date1.location                  = New-Object System.Drawing.Point(122,92)
$date1.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$date1.Add_Click( { $this.SelectAll(); $this.Focus() })
$date1.Add_KeyDown({if ($_.KeyCode -eq "Enter") { log }})

$before1                         = New-Object system.Windows.Forms.TextBox
$before1.multiline               = $false
$before1.width                   = 145
$before1.height                  = 20
$before1.location                = New-Object System.Drawing.Point(122,119)
$before1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$before1.Add_Click( { $this.SelectAll(); $this.Focus() })
$before1.Add_KeyDown({if ($_.KeyCode -eq "Enter") { log }})

$after1                          = New-Object system.Windows.Forms.TextBox
$after1.multiline                = $false
$after1.width                    = 145
$after1.height                   = 20
$after1.location                 = New-Object System.Drawing.Point(122,146)
$after1.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$after1.Add_Click( { $this.SelectAll(); $this.Focus() })
$after1.Add_KeyDown({if ($_.KeyCode -eq "Enter") { log }})

$time1                           = New-Object system.Windows.Forms.TextBox
$time1.multiline                 = $false
$time1.width                     = 145
$time1.height                    = 20
$time1.location                  = New-Object System.Drawing.Point(122,173)
$time1.Font                      = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$time1.Add_Click( { $this.SelectAll(); $this.Focus() })
$time1.Add_KeyDown({if ($_.KeyCode -eq "Enter") { log }})

$Button1                         = New-Object system.Windows.Forms.Button
$Button1.text                    = "Run"
$Button1.width                   = 327
$Button1.height                  = 30
$Button1.location                = New-Object System.Drawing.Point(34,205)
$Button1.Font                    = New-Object System.Drawing.Font('Microsoft Sans Serif',10)
$Button1.BackColor               = [System.Drawing.ColorTranslator]::FromHtml("#b8e986")

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "After <Time>"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(277,152)
$Label2.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label3                          = New-Object system.Windows.Forms.Label
$Label3.text                     = "ComputerName"
$Label3.AutoSize                 = $true
$Label3.width                    = 25
$Label3.height                   = 10
$Label3.location                 = New-Object System.Drawing.Point(277,42)
$Label3.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label4                          = New-Object system.Windows.Forms.Label
$Label4.text                     = "Before <time>"
$Label4.AutoSize                 = $true
$Label4.width                    = 25
$Label4.height                   = 10
$Label4.location                 = New-Object System.Drawing.Point(277,124)
$Label4.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label5                          = New-Object system.Windows.Forms.Label
$Label5.text                     = "Time"
$Label5.AutoSize                 = $true
$Label5.width                    = 25
$Label5.height                   = 10
$Label5.location                 = New-Object System.Drawing.Point(277,178)
$Label5.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label6                          = New-Object system.Windows.Forms.Label
$Label6.text                     = "Newest"
$Label6.AutoSize                 = $true
$Label6.width                    = 25
$Label6.height                   = 10
$Label6.location                 = New-Object System.Drawing.Point(277,70)
$Label6.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Label7                          = New-Object system.Windows.Forms.Label
$Label7.text                     = "Date"
$Label7.AutoSize                 = $true
$Label7.width                    = 25
$Label7.height                   = 10
$Label7.location                 = New-Object System.Drawing.Point(277,97)
$Label7.Font                     = New-Object System.Drawing.Font('Microsoft Sans Serif',10)

$Form.controls.AddRange(@($Groupbox1,$computername1,$newest1,$Groupbox2,$date1,$before1,$after1,$time1,$Button1,$Label2,$Label3,$Label4,$Label5,$Label6,$Label7))
$Groupbox1.controls.AddRange(@($Label1))
$Groupbox2.controls.AddRange(@($all,$system,$security,$application))

$Button1.Add_Click({ log })

function log {

    $uname=("$env:USERDOMAIN\$env:USERNAME")
    $cred = Get-Credential $uname
    
    if ($system.Checked -eq $true) {
        $logname = "system"
    } elseif ($security.Checked -eq $true) {
            $logname = "security"
    } elseif ($application.Checked -eq $true) {
            $logname = "application"
    }

    $ComputerName = $computername1.Text
    $newest = $newest1.Text
    $time = $time1.Text
    $newest = $newest1.Text
    $before = $before1.Text
    $after = $after1.Text
    $date = $date1.Text
    $arglst = @("$newest","$time","$logname","$date","$before","$after")
    
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
            Get-EventLog -Newest $newest -LogName $logname | where {$_.TimeGenerated -lt $date -and $_.TimeGenerated -lt $before}
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

        $lognames="Application","Security","System"
        if (!$newest) {$newest = "200"}
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
        $res | Out-GridView -PassThru |  Format-Table -AutoSize -Wrap | clip
    }

    if ($logname) {
        $res = Invoke-Command -ComputerName $ComputerName -Credential $cred -ArgumentList ${arglst} -ScriptBlock ${function:parser1}
        }

    elseif ($all.Checked) {
        $res = Invoke-Command -ComputerName $ComputerName -Credential $cred -ArgumentList ${arglst} -ScriptBlock ${function:parser2}
        }
    outpars
    }
[void]$Form.ShowDialog()
