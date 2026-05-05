Get-ADUser -Identity ekreyness | Select UserPrincipalName, DisplayName, mail, fax, SamAccountName, ObjectGUID, @{name="ImmutableID"; expression={[Convert]::ToBase64String([guid]::New($_.ObjectGUID).ToByteArray())}}
 
Connect-MgGraph -Scopes "User.Read.All"
#o
Connect-MgGraph -Scopes "User.ReadWrite.All"

Update-MgUser -UserId "user@domain" -OnPremisesImmutableId "6AesIdrxRUG11YJYlLFUTA=="

###### Si falla, hacerlo desde módulo de AzureAD:

Set-AzureADUser -ObjectId "usuario@empresa.com" -ImmutableId du0VS1jBZkujBMjAiZ5YlA==
 
#Install-Module Microsoft.Graph -Scope CurrentUser

#Import-Module Microsoft.Graph
