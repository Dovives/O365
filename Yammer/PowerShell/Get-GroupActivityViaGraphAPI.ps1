Import-Module SharePointPnPPowerShellOnline

#Connect to O365 with your O365 Credential and retrieve an Access Token.  
$arrayOfScopes = @("Reports.Read.All")
Connect-PnPMicrosoftGraph -Scopes $arrayOfScopes 
$PnPAccessToken = Get-PnPAccessToken

#CSV Version 
$uri = "https://graph.microsoft.com/beta/" + "reports/getYammerGroupsActivityDetail(period='D7')?$$format=text/csv"

#JSON version 
#$uri = "https://graph.microsoft.com/beta/" + "reports/getYammerGroupsActivityDetail(period='D7')?$$format=application/json" 

Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Bearer $PnPAccessToken"}
