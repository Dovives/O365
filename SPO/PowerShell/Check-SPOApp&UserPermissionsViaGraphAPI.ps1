########################################################################################
#This script is provided as an example. It must not be used in Production environment.
#It shows how to obtain a Token to log into the Graph API. The token must be acquired once
#and then stored on the server. Everytime the Graph API is used, it is refreshed before 
#being used.
########################################################################################

#Sample oAuth 2.0 Microsoft API Powershell AuthN/AuthZ Script
#The resource URI
$resource = "https://graph.microsoft.com"
#Your Client ID and Client Secret obainted when registering your WebApp
$clientid = "<Insert clientID>"
$clientSecret = "<Insert clientSecret>"
#Your Reply URL configured when registering your WebApp
$redirectUri = "http://localhost"
#Scope
$scope = "User.Read Mail.Read"
Add-Type -AssemblyName System.Web
#UrlEncode the ClientID and ClientSecret and URL's for special characters
$clientIDEncoded = [System.Web.HttpUtility]::UrlEncode($clientid)
$clientSecretEncoded = [System.Web.HttpUtility]::UrlEncode($clientSecret)
$resourceEncoded = [System.Web.HttpUtility]::UrlEncode($resource)
$scopeEncoded = [System.Web.HttpUtility]::UrlEncode($scope)

#Refresh Token Path
#This can be changed
$refreshtokenpath = "d:\temp\refresh.token"

#Functions
# Function to popup Auth Dialog Windows Form for getting an AuthCode
    Function Get-AuthCode {
        Add-Type -AssemblyName System.Windows.Forms

        $form = New-Object -TypeName System.Windows.Forms.Form -Property @{Width=440;Height=640}
        $web  = New-Object -TypeName System.Windows.Forms.WebBrowser -Property @{Width=420;Height=600;Url=($url -f ($Scope -join "%20")) }

        $DocComp  = {
            $Global:uri = $web.Url.AbsoluteUri        
            if ($Global:uri -match "error=[^&]*|code=[^&]*") {$form.Close() }
        }
        $web.ScriptErrorsSuppressed = $true
        $web.Add_DocumentCompleted($DocComp)
        $form.Controls.Add($web)
        $form.Add_Shown({$form.Activate()})
        $form.ShowDialog() | Out-Null

        $queryOutput = [System.Web.HttpUtility]::ParseQueryString($web.Url.Query)
    
        $output = @{}
        foreach($key in $queryOutput.Keys){
            $output["$key"] = $queryOutput[$key]
        }

        $output
        Write-Output $output
    }

function Get-AzureAuthN ($resource) {
    # Get Permissions (if the first time, get an AuthCode and Get a Bearer and Refresh Token
    # Get AuthCode
    $url = "https://login.microsoftonline.com/common/oauth2/authorize?response_type=code&redirect_uri=$redirectUri&client_id=$clientID&resource=$resourceEncoded&scope=$scopeEncoded"
    Get-AuthCode
    ##Extract Access token from the returned URI
    $regex = '(?<=code=)(.*)(?=&)'
    Write-Output $uri
    if ($uri){
        $authCode  = ($uri | Select-string -pattern $regex).Matches[0].Value

        ##Write-output "Received an authCode, $authCode"
        }
        #get Access Token
        $body = "grant_type=authorization_code&redirect_uri=$redirectUri&client_id=$clientId&client_secret=$clientSecretEncoded&code=$authCode&resource=$resource"
        $Authorization = Invoke-RestMethod https://login.microsoftonline.com/common/oauth2/token `
            -Method Post -ContentType "application/x-www-form-urlencoded" `
            -Body $body `
            -ErrorAction STOP

       ## Write-output $Authorization.access_token
        $Global:accesstoken = $Authorization.access_token
        $Global:refreshtoken = $Authorization.refresh_token 
        if ($refreshtoken){$refreshtoken |out-file "$($refreshtokenpath)"}
    
}
#AuthN
Get-AzureAuthN ($resource)
#$refreshtoken = Get-Content "$($refreshtokenpath)"
$Authorization 

$uri = "https://<your-tenant>.sharepoint.com/sites/<your-site>/_api/web/lists/getbytitle('Documents')"


$contentType = 'application/json;odata=verbose'
$Headers = @{}    
[Microsoft.PowerShell.Commands.WebRequestMethod]$Method = [Microsoft.PowerShell.Commands.WebRequestMethod]::Get
$Headers["Accept"] = "application/json;odata=verbose"
$Headers.Add('Authorization','Bearer ' + $accesstoken)
$Body = $null


Invoke-RestMethod -Method $Method -Uri $Uri -ContentType $contentType -Headers $Headers -Body $Body 
