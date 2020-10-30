# Powershell-GUI for Event Logs

Eventlog-GUI is a tool for parsing logs from EventViewer and assign filter scopes.
Eventlog cli has the same functions, just runs in powershell cli instead

If the "all" radio button is selected, it will fetch the last 200 logs of each log type.
To copy logs from Out-Gridview, select log lines and hit ok or enter. It will copy the text to clipboard.

<img src="eventlogcli4.png">


# Event Log CLI Parser

Same as the gui version, but can print out a more detailed message directly on the cli with option -o, and copy the output to the clipboard.
If no logname is provided, it will fetch all 3 log types.

Tip: Default it is set to fetch the last 200 logs. If the date and time is not recent and you get no results, you have to increase this from 200 to 1000 or more until you get a result.

SYNTAX

    [log <host> [-newest <number>] [-time <time>] [-logname <logname>] [-date <date>] [-before <time>] [-after <time>] [-o]
    -o : Output to terminal

Example:
    
        log -ComputerName contoso.local -newest 1000 -time 10:10 -logname system -date 14/10
        log contoso.local -after 10:00 -before 11:00 -date 14/10/2020 -o
