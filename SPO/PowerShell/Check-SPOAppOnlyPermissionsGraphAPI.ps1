Import-Module SharePointPnPPowerShellOnline

#Connect-PnPOnline 
$arrayOfScopes = @("Reports.Read.All")
$ConnectPnPGraph = Connect-PnPMicrosoftGraph -Scopes $arrayOfScopes 

$PnPAccessToken = Get-PnPAccessToken
$uri = "https://graph.microsoft.com/beta/" + "/reports/SharePointActivity(view='Detail',period='D7')/content"


#  $authHeader = @{
#        'Content-Type'='application\json'
#        'Authorization'= $PnPAccessToken
#     }

Invoke-RestMethod -Uri $uri -Headers @{Authorization = "Bearer $PnPAccessToken"}