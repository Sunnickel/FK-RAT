function randomText {
  return -join ((65..90) + (97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_})
}

## variables
$temp = "$env:temp"
$dirName = randomText

Set-Location $temp	
New-item -Path "$temp\$dirname" -ItemType Directory


Set-Location $temp\$dirName
New-item -Path "$temp\$dirname\poc.txt" -ItemType FIle -Value ""