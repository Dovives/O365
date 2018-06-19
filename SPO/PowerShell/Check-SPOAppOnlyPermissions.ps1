
#Connect-PnPOnline -Url https://dovivesmsft.sharepoint.com/sites/carsat2/ -AppId "024e43ca-4e18-4e74-91da-91f3fbaf72df" -AppSecret "3H73Cs2ltRDmCjY93ndj79c1tmHC6pwXjVuQrFLmooc="
#

Connect-PnPOnline https://<your-tenant>.sharepoint.com/sites/<your-site> -AppId <your_client_id> -AppSecret <your_client_secret>
$PnPAccessToken = Get-PnPAppAuthAccessToken | Clip




$uri = "https://graph.microsoft.com/beta/" + "reports/getYammerGroupsActivityDetail(period='D7')?$$format=text/csv"

$uri = "https://tenant.sharepoint.com/sites/carsat2/_api/web/lists/getbytitle('Documents')"


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