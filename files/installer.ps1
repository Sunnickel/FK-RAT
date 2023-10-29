function randomText {
  return -join ((65..90) + (97..122) | Get-Random -Count 8 | ForEach-Object {[char]$_})
}

## variables
$temp = "C:\Users\%username%\AppData\Local\Temp"
$dirName = randomText

Set-Location $temp
mkdir $dirName

Set-Location $temp/$dirName
Write-Output "" > poc.txt
