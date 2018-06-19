<#PSScriptInfo
.VERSION 1.0
.GUID 
.AUTHOR Dominique VIVES
.COMPANYNAME 
.COPYRIGHT 
.TAGS  O365 SPO App Client ID Secret 

.LICENSEURI 
.PROJECTURI 
.ICONURI 
.EXTERNALMODULEDEPENDENCIES 
.REQUIREDSCRIPTS 
.EXTERNALSCRIPTDEPENDENCIES 
.RELEASENOTES

#>

<# 

.DESCRIPTION 
Check your app Client ID & Client Secret by accessing a Document Library via REST API. 
 
This require that you've first register your App via _Layouts/15/AppRegNew.aspx then that you allow permissions via _layouts/15/Appinv.aspx. 

#> 

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


Function Invoke-SPORestMethod()
{
Param(
  [Uri]$Uri,
  [Object]$Body,
  [Hashtable]$Headers,
  [Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get,
  [string]$AccessToken
)
    $contentType = 'application/json;odata=verbose'
    if(-not $Headers) {
       $Headers = @{}    
    }
    $Headers["Accept"] = "application/json;odata=verbose"
    $Headers.Add('Authorization','Bearer ' + $AccessToken)
    Invoke-RestMethod -Method $Method -Uri $Uri -ContentType $contentType -Headers $Headers -Body $Body 
}