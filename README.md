# powershell wifi monitor #
## About ##
IMCP traffic is blocked at my school, and the wifi tends to kick you off.  When this happens you need to re-connect to the wifi network to resume browsing the internet. 

## How it works ##
Running in administrator mode (needed for hardware access), the script checks the status of the Wireless Network.  If windows detects the internet is down (indicated by a yellow warning on the system try icon), the script sees that and disables the Wireless Card, and re-enables it a few seconds later.  A log is written to C:\wifi_log.txt, and screen output is generated if running in the Powershell IDE or Powershell terminal.

## Supported OS ##
right now just Windows 7 Home.  Some commands are different and depreciated for Windows 10.  I make notes about this in my script in some places, feel free to take a look and customize it to work for you.
