
Version Status: Beta v1.1

# PRTG NextCloud Status
PowerShell Script to get some Information about your NextCloud Server
![](https://github.com/freaky-media/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG-NextCloud_Status_Image1.jpg)

### Installation

Copy PS1 File to YOURPRTGInstallPath\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML
If you want Monitoring Systems on Remote Probes, Copy Script to the Remote Probe

### Configuration
1. Add Sensor "Program/Script Advanced"
![](https://github.com/freaky-media/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG-NextCloud_Status_Image0.jpg)

2. Change Name of the Sensor from XML-Programm-/Skriptsensor to  NextCloud Status or some else

3. Choose in Sensorsettings the New Script called, PRTG_NextCloud.ps1

4. Add Parameter
-NCusername SomeUserNameWithAdministrativeRights -NCpassword thePasswordForTheUser -NCURL cloud.your-domain-from-cloud.com

![](https://github.com/freaky-media/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG-NextCloud_Status_Image2_SensorSetup.jpg)
