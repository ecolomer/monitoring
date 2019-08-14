Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\.NETFramework\Performance' -Name ProcessNameFormat -Value 1 -Type DWord
Set-ItemProperty -Path 'HKLM:\SYSTEM\CurrentControlSet\Services\PerfProc\Performance' -Name ProcessNameFormat -Value 2 -Type DWord
wget https://dl.influxdata.com/telegraf/releases/telegraf-1.11.3_windows_amd64.zip -OutFile .\Downloads\telegraf-1.11.3_windows_amd64.zip
Expand-Archive -Path .\Downloads\telegraf-1.11.3_windows_amd64.zip -DestinationPath 'C:\Program Files'
cp ..\config\telegraf.conf.aspnet 'C:\Program Files\Telegraf\telegraf.conf'
cd 'C:\Program Files\Telegraf\'
& 'C:\Program Files\Telegraf\telegraf.exe' --service install
& 'C:\Program Files\Telegraf\telegraf.exe' --service start
New-NetFirewallRule -DisplayName 'Telegraf Metrics' -Action Allow -Direction Inbound -Protocol TCP -LocalPort 9273