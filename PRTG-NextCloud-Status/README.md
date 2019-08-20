# PRTG NextCloud Status
PowerShell Script to get some Information about your NextCloud Server
![](https://github.com/freaky-media/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG-NextCloud_Status_Image1.jpg)

### Installation

Copy PS1 File to YOURPRTGInstallPath\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML
If you want Monitoring Systems on Remote Probes, Copy Script to the Remote Probe

### Configuration
Add Sensor "Program/Script Advanced"

Change Name of the Sensor from XML-Programm-/Skriptsensor to  NextCloud Status or some else

Choose in Sensorsettings the New Script called, PRTG_NextCloud.ps1

Add Parameter
  -NCusername SomeUserNameWithAdministrativeRights -NCpassword thePasswordForTheUser -NCURL cloud.your-domain-from-cloud.com
