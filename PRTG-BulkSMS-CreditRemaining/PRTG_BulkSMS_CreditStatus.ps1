#Get BulkSMS Credit Status
# v. 1.1
# © 2018 Frank Fischer
# www.freaky-media.de
#
#
################# 
# Settings for the Sensor
# Define Parameter with User and Password 
# -bulksmsUSR username_at_bulksms -bulksmsPW YourSuperSecretPW
#
# Security Context ==> Use Windows credentials of parent device
#
# Define Values for LimitMinWarning and LimitMinError
# v1.0 Initial Release
# v1.1 Change API URL 2018.06
#################


param(
$bulksmsUSR,
$bulksmsPW
)

#URL
[string]$bulksmsAPIURLCredits = "https://bulksms.vsms.net/eapi/user/get_credits/2/2.0?username=$bulksmsUSR&password=$bulksmsPW"

$WebResponse = Invoke-WebRequest $bulksmsAPIURLCredits

$bulksmsCredits = $WebResponse.ToString()
$bulksmsCredits = $bulksmsCredits.split("|")

$bulksmsStatus = $bulksmsCredits[0]
$bulksmsCreds = $bulksmsCredits[1]
if($bulksmsStatus -eq "0") 
{
Write-Host @"
<?xml version='1.0' encoding='UTF-8'?>
<prtg>
   <result>
      <channel>API Status</channel>
      <value>$bulksmsStatus</value>
      <float>1</float>
      </result>
      <result>
      <channel>Credit Status</channel>
      <value>$bulksmsCreds</value>
      <customunit>Credits</customunit>
      <LimitMinWarning>50</LimitMinWarning>
      <LimitMinError>20</LimitMinError>
       <text>Remaining Credits</text>
      <float>1</float>       
   </result>
   

</prtg>
"@
}
else
{
Write-Host @"
<?xml version='1.0' encoding='UTF-8'?>
<prtg>
   <error>1</error>
   <text>An Error occured: $bulksmsCreds</text>
   </prtg>
"@
}