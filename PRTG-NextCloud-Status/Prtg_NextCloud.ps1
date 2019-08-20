#REQUIRES -Version 3.0

<#
.LICENSES
   GNU GPLv3 
.DESCRIPTION
    PRTG Custom Sensor Script for Monitoring NextCloud Intances
.NOTES
    File Name      : Prtg_NextCloud.ps1
    Author         : Frank Fischer (info@freaky-media.de)
    Prerequisite   : PowerShell 3V over Win10 and upper.
    Copyright 2019 - FrankFischer/freaky-media
.LINK
    
    
.EXAMPLE
    
.VERSION
    Version: 1.0
    
#>


Param (
        [string]$NCusername = $null,
        [string]$NCpassword = $null,
        [string]$NCurl = $null    
)

########################################################################################
# PreCondition checks
########################################################################################
# Check for required parameters
if (-not $NCusername) {
                return @"
<prtg>
  <error>1</error>
  <text>Required parameter not specified: please provide Username with Administrative Rights to read Full StatusPage </text>
</prtg>
"@
}

if (-not $NCpassword) {
                return @"
<prtg>
  <error>1</error>
  <text>Required parameter not specified: please provide Password with Administrative Rights to read Full StatusPage</text>
</prtg>
"@
}

if (-not $NCurl) {
                return @"
<prtg>
  <error>1</error>
  <text>Required parameter not specified: please provide full URL </text>
</prtg>
"@
}


$NCAPIURL = “https://$NCurl/ocs/v2.php/apps/serverinfo/api/v1/info”


$base64AuthInfo = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes(("{0}:{1}" -f $NCusername,$NCpassword)))

$headers = @{}
$headers[“OCS-APIRequest”] = “true”
$headers[“Authorization”]=(“Basic {0}” -f $base64AuthInfo)

#$body = @{}



# Try to Connect - if not working Show Error
try
	{
		[xml]$xmlGetNCStatusPage = Invoke-WebRequest -Credential $Auth -Headers $headers -Method GET -URI $NCAPIURL -Body $body -UseBasicParsing
        
# Check Overall Status OK/200 
if($xmlGetNCStatusPage.ocs.meta.statuscode = "200")
{


if($xmlGetNCStatusPage.ocs.meta.status = "ok")
{
$NC_OCS_Meta_Status = 0
}
elseif($xmlGetNCStatusPage.ocs.meta.status = "failed")
{
$NC_OCS_Meta_Status = 404
}
else
{
$NC_OCS_Meta_Status = 3
}


if($xmlGetNCStatusPage.ocs.meta.statuscode = "200")
{
$NC_OCS_Meta_StatusCode = 0
}
elseif ($xmlGetNCStatusPage.ocs.meta.statuscode = "997")
{
$NC_OCS_Meta_StatusCode = 997
}


# Status Message
if($xmlGetNCStatusPage.ocs.meta.message = "OK")
{
$NC_OCS_Meta_Message = 0
}
else
{
$NC_OCS_Meta_Message = 3
}

# Get last User Usage

$NCActiveUsers_Last5min = $xmlGetNCStatusPage.ocs.data.activeUsers.last5minutes
$NCActiveUsers_Last1hour = $xmlGetNCStatusPage.ocs.data.activeUsers.last1hour
$NCActiveUsers_Last24hours = $xmlGetNCStatusPage.ocs.data.activeUsers.last24hours

# Get NextCloud Mem Status

$NCMemTotal = [math]::Round($xmlGetNCStatusPage.ocs.data.nextcloud.system.mem_total / 1024,2) # Shows Values as MB
$NCMemFree = [math]::Round($xmlGetNCStatusPage.ocs.data.nextcloud.system.mem_free / 1024,2) # Shows Values as MB
$NCSwapTotal = [math]::Round($xmlGetNCStatusPage.ocs.data.nextcloud.system.swap_total / 1024,2) # Shows Values as MB
$NCSwapFree = [math]::Round($xmlGetNCStatusPage.ocs.data.nextcloud.system.swap_free / 1024,2) # Shows Values as MB

# Get SQL Status DB Storage
$NCSQLDB_Status = [math]::Round($xmlGetNCStatusPage.ocs.data.server.database.size/1024/1024,2) # Shows Values as MB
# Get Share Infos
$NCGetShareLink_withoutPassword = $xmlGetNCStatusPage.ocs.data.nextcloud.shares.num_shares_link_no_password

# Get App Status Update Avail

$NCGetAppUpdateStatus = $xmlGetNCStatusPage.ocs.data.nextcloud.system.apps.num_updates_available


# Generate XML Output for PRTG 
# Start

Write-Host "
<?xml version='1.0' encoding='UTF-8' ?>
<prtg>"

Write-Host
"<result>"
             "<result>"
            "<channel>Nextcloud Status</channel>"
            "<value>$NC_OCS_Meta_Status</value>"
             "<ValueLookup>NextCloudStatusLookup.State</ValueLookup>"
            "</result>"

            "<channel>Nextcloud Status Code</channel>"
            "<value>$NC_OCS_Meta_StatusCode</value>"
            "<ValueLookup>NextCloudStatusCodeLookup.State</ValueLookup>"
            "</result>"
            
            "<result>"
            "<channel>Nextcloud Message</channel>"
            "<value>$NC_OCS_Meta_Message</value>"
            "<ValueLookup>NextCloudMessageLookup.State</ValueLookup>"
            "</result>"

            "<result>"
            "<channel>Active Users Last 5min</channel>"
            "<value>$NCActiveUsers_Last5min</value>"
            "</result>"
            
            "<result>"
            "<channel>Active Users Last 1Hour</channel>"
            "<value>$NCActiveUsers_Last1hour</value>"
            "</result>"
            
            "<result>"
            "<channel>Active Users Last 24Hours</channel>"
            "<value>$NCActiveUsers_Last24hours</value>"
            "</result>"

            "<result>"
            "<channel>Memory Total</channel>"
            "<value>$NCMemTotal</value>"
            "<float>1</float>"
            "<unit>Custom</unit>"
            "<customunit>MB</customunit>"
            "</result>"

            "<result>"
            "<channel>Memory in Use</channel>"
            "<value>$NCMemFree</value>"
            "<float>1</float>"
            "<unit>Custom</unit>"
            "<customunit>MB</customunit>"
            "</result>"

            "<result>"
            "<channel>Swap Total</channel>"
            "<value>$NCSwapTotal</value>"
            "<float>1</float>"
            "<unit>Custom</unit>"
            "<customunit>MB</customunit>"
            "</result>"

            "<result>"
            "<channel>Swap Free</channel>"
            "<value>$NCSwapFree</value>"
            "<float>1</float>"
            "<unit>Custom</unit>"
            "<customunit>MB</customunit>"
            "</result>"

              "<result>"
            "<channel>SQL DB Size</channel>"
            "<value>$NCSQLDB_Status</value>"
            "<float>1</float>"
            "<unit>Custom</unit>"
            "<customunit>MB</customunit>"
            "</result>"

            
            "<result>"
            "<channel>Share Links without Password</channel>"
            "<value>$NCGetShareLink_withoutPassword</value>"
            "<float>0</float>"
            "<LimitMinError>0</LimitMinError>"
		    "<LimitMode>1</LimitMode>"
            "<unit>Custom</unit>"
            "<customunit># Shares</customunit>"
            "</result>"

            "<result>"
            "<channel>Apps with Updates</channel>"
            "<value>$NCGetAppUpdateStatus</value>"
            "<float>0</float>"
            "<LimitMaxError>0</LimitMaxError>"
		    "<LimitMode>1</LimitMode>"
            "<unit>Custom</unit>"
            "<customunit>App(s)</customunit>"
            "</result>"
            
                        # End
            Write-Host "</prtg>"

}
elseif ($xmlGetNCStatusPage.ocs.meta.statuscode = "997")
{
$NCOVerallStatusCode = 997
"<prtg><error>1</error>"
		"<text>Current user is not logged in $($_.Exception.Message)</text>"
		"</prtg>"
}
	}
catch
	{
		"<prtg><error>1</error>"
		"<text>API Query Failed: $($_.Exception.Message)</text>"
		"</prtg>"
	}
