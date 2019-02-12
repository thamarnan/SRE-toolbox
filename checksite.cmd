@PowerShell -ExecutionPolicy Bypass -Command Invoke-Expression $('$args=@(^&{$args} %*);'+[String]::Join(';',(Get-Content '%~f0') -notmatch '^^@PowerShell.*EOF$')) & goto :EOF

$SITE = "http://testsite.com"
$myLocation = Invoke-RestMethod http://ipinfo.io/json | Select -exp region
$nl = [Environment]::NewLine

try{
    $request = $null
    $request = Invoke-WebRequest -Uri $SITE
    } catch {              
     $request = $_.Exception.Response            
    }  
    $StatusCode = [int] $request.StatusCode;
    $StatusDescription = $request.StatusDescription;
    Write-Host $StatusCode  $SITE $myLocation 


If ($StatusCode  -eq 200){
    Write-Host "Site is OK!"
} Else {
    	Write-Host "The Site may be down, please check!" 
	$EmailFrom = "@gmail.com"
	$EmailTo = "@gmail.com"
	$Subject = "Alert: Status " + $StatusCode +" on " + $SITE
	$Body = "Status: " + $StatusCode + " on " + $SITE + $nl + "Source Location: " + $myLocation
	$SMTPServer = "smtp.gmail.com"
	$SMTPClient = New-Object Net.Mail.SmtpClient($SmtpServer, 587)
	$SMTPClient.EnableSsl = $true
	$SMTPClient.Credentials = New-Object System.Net.NetworkCredential("a@gmail.com", "password");
	$SMTPClient.Send($EmailFrom, $EmailTo, $Subject, $Body)
}

