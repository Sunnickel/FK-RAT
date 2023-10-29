function randomText {
  return -join ((65..90) + (97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_})
}


## Temp Directory
## variables
$temp = "$env:temp"
$dirName = randomText

## goto Temp and start building
Set-Location $temp	
New-Item -Path $temp -Name $dirName -Type Directory

