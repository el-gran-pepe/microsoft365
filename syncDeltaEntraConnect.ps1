Enter-PSSession -computername hostname

Start-ADSyncSyncCycle -PolicyType delta

Exit-PSSession