#check internet conectivity found at
# https://gallery.technet.microsoft.com/scriptcenter/Test-Internet-Connection-ce98e2d7

#needs to run as Administrator to interact with WMI objects
#otherwise .Disable() will return status code 5 (access denied)
#that info found at
# https://stackoverflow.com/questions/24649627/disabling-ethernet-adapter-in-powershell



#get network adapter
$wmi = Get-WmiObject -Class Win32_NetworkAdapter -filter "Name LIKE '%Wireless%'"

#dir to save log file
$myDir = "C:\wifi_log.txt"


Write-Output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t begining script, press Ctrl + C to quit..."

while ($wmi -ne $null){
    

    # wmi info page   https://msdn.microsoft.com/en-us/library/aa394216(v=vs.85).aspx

    if ($wmi.NetConnectionStatus -eq 1){
        Write-output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t adapter is connecting"
 

    }elseif($wmi.NetConnectionStatus -eq 7){
        Write-Output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t adapter was disabled"
        Write-Output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t adapter was disabled" | Out-File $myDir -NoClobber -Append  #write log to file
        $wmi.Enable() | out-null   #re-enable adapter, but skip the cryptic output to screen it displays
        Write-Output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t adapter was re-enabled"

    }else{
        #check if internet connection exists
        if ([Activator]::CreateInstance([Type]::GetTypeFromCLSID([Guid]'{DCB00C01-570F-4A9B-8D69-199FDBA5723B}')).IsConnectedToInternet -eq $false ){
   
            #this may work with win 8 and above, but I have windows 7
            #Disable-NetAdapter -Name "eduroam" -Confirm:$false

            Write-Output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t internet was down, resetting adapter" | Out-File $myDir -NoClobber -Append #write log to file
            Write-Output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t internet was down, resetting adapter"
           
            #this works with windows 7
            $wmi.Disable() | Out-File $myDir -NoClobber -Append
            $wmi.Enable()  | Out-File $myDir -NoClobber -Append

            #need to sleep long enough for windows to re-connect
            sleep -s 10
		  Write-Output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t reset done. resume checking loop..."
        }
    }

    #sleep for 5 seconds, use -m for miliseconds
    sleep -s 2
    #write-output "end sleep2"
    $wmi = Get-WmiObject -Class Win32_NetworkAdapter -filter "Name LIKE '%Wireless%'"
    
} #end main loop

if ($wmi -eq $null) { Write-Output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t Network Object was null, check name again"}
Write-Output "$(Get-Date -Format '%M/d/yy HH:mm:ss')`t Script end..."


