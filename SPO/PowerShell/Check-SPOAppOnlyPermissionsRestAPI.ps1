<#PSScriptInfo
.VERSION 1.0
.AUTHOR Dominique VIVES
.COMPANYNAME 
.COPYRIGHT 
.TAGS  O365 SPO App Client ID Secret 
.DESCRIPTION 
Check your app Client ID & Client Secret by accessing a Document Library via REST API. 
This require that you've first register your App via _Layouts/15/AppRegNew.aspx then that you allow permissions via _layouts/15/Appinv.aspx. 
This script also rely on the PnP PowerShell Module 
#> 

########################################################################################
#This script is provided as an example. It must not be used in Production environment.
#It shows how to obtain a Token to log into the Graph API. The token must be acquired once
#and then stored on the server. Everytime the Graph API is used, it is refreshed before 
#being used.
########################################################################################
Import-Module SharePointPnPPowerShellOnline

Connect-PnPOnline https://<your-tenant>.sharepoint.com/sites/<your-site> -AppId <your_client_id> -AppSecret <your_client_secret>
$PnPAccessToken = Get-PnPAppAuthAccessToken | Clip


$uri = "https://<your-tenant>.sharepoint.com/sites/<your-site>/_api/web/lists/getbytitle('Documents')"


$contentType = 'application/json;odata=verbose'
$Headers = @{}    
[Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get
$Headers["Accept"] = "application/json;odata=verbose"
$Headers.Add('Authorization','Bearer ' + $PnPAccessToken)
$Body = $null


Invoke-RestMethod -Method $Method -Uri $Uri -ContentType $contentType -Headers $Headers -Body $Body 
