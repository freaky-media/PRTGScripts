

Version Status: v1.21 - This is a fork from https://github.com/freaky-media/PRTGScripts/

# PRTG NextCloud Status
In order to monitor your Nextcloud API (XML) via PRTG, you can use the following steps
![](https://github.com/flostyen/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG_NextCloud-API-XML_prtg-screenshot.png)

### 1. Installation in PRTG

1.1 Copy the PS1 File to your PRTG server in the path C:\Program Files (x86)\PRTG Network Monitor\Custom Sensors\EXEXML. If you want to monitoring nextcloud systems from your PRTG remote probes, copy the script to the remote probe.

![](https://github.com/flostyen/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG_NextCloud-API-XML_ps-file.png)

1.2 Create the following lookup files NextCloudMessageLookup.ovl, NextCloudStatusCodeLookup.ovl, NextCloudStatusLookup.ovl into your PRTG installation folder C:\Program Files (x86)\PRTG Network Monitor\lookups\custom

![](https://github.com/flostyen/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG_NextCloud-API-XML_lookup-files.png)

1.3 Reload Lookups:
![](https://github.com/flostyen/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG_NextCloud-API-XML_reload-lookups.png)

### 2. Configuration in PRTG

2.1 Add the sensor "EXE/Script Advanced" PRTG add sensor 

![](https://github.com/flostyen/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG_NextCloud-API-XML_sensor-create.png)

2.2 Change the sensor name

2.3 Choose in the powershell script PRTG_NextCloud.ps1.

2.4 Add parameter -NCusername *YourNCAdminUser* -NCpassword *StrongPassSentence* -NCURL *YourNCFQDN*

![](https://github.com/flostyen/PRTGScripts/blob/master/PRTG-NextCloud-Status/PRTG_NextCloud-API-XML_sensor-cfg.png)
