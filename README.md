# Powershell-GUI for Event Logs

Eventlog-Gui is a tool for parsing logs from EventViewer and assign filter scopes.
Eventlog cli has the same functions, just runs in powershell cli instead


To fetch and parse Event logs from remote system, only requirement is Computername.
If no other value is provided, it will fetch 200 logs of each log type.
To copy logs from Out-Gridview, select log output and hit ok or enter. It will copy the text to clipboard.

<img src="">


# Event Log CLI Parser

SYNTAX

    [log <host> [-newest <number>] [-time <time>] [-logname <logname>] [-date <date>] [-before <time>] [-after <time>] [-o]
    -o : Output to terminal

Example:
    
    Remote: 
        log -ComputerName contoso.local -newest 1000 -time 10:10 -logname system -date 14.10
        log contoso.local -after 10:00 -date '14.10.2020' -o
        
    Local: 
        log -logname system -before 11:00 -after 10:00 -date '14.10.2020'
