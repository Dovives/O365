Import-Module SharePointPnPPowerShellOnline

#Connect-PnPOnline 
$arrayOfScopes = @("Reports.Read.All")
$ConnectPnPGraph = Connect-PnPMicrosoftGraph -Scopes $arrayOfScopes 

$PnPAccessToken = Get-PnPAccessToken

#CSV Version 
$uri = "https://graph.microsoft.com/beta/" + "reports/getYammerGroupsActivityDetail(period='D7')?$$format=text/csv"

#JSON version 
#$uri = "https://graph.microsoft.com/beta/" + "reports/getYammerGroupsActivityDetail(period='D7')?$$format=application/json" 

Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Bearer $PnPAccessToken"}
