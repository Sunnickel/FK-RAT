# Project: Finders Keepers (FK RAT)
> Sunnickel | 28.10.2023
---
```

 ▄▀▀▀█▄    ▄▀▀█▀▄    ▄▀▀▄ ▀▄  ▄▀▀█▄▄   ▄▀▀█▄▄▄▄  ▄▀▀▄▀▀▀▄  ▄▀▀▀▀▄      ▄▀▀▄ █  ▄▀▀█▄▄▄▄  ▄▀▀█▄▄▄▄  ▄▀▀▄▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▄▀▀▀▄  ▄▀▀▀▀▄ 
█  ▄▀  ▀▄ █   █  █  █  █ █ █ █ ▄▀   █ ▐  ▄▀   ▐ █   █   █ █ █   ▐     █  █ ▄▀ ▐  ▄▀   ▐ ▐  ▄▀   ▐ █   █   █ ▐  ▄▀   ▐ █   █   █ █ █   ▐ 
▐ █▄▄▄▄   ▐   █  ▐  ▐  █  ▀█ ▐ █    █   █▄▄▄▄▄  ▐  █▀▀█▀     ▀▄       ▐  █▀▄    █▄▄▄▄▄    █▄▄▄▄▄  ▐  █▀▀▀▀    █▄▄▄▄▄  ▐  █▀▀█▀     ▀▄   
 █    ▐       █       █   █    █    █   █    ▌   ▄▀    █  ▀▄   █        █   █   █    ▌    █    ▌     █        █    ▌   ▄▀    █  ▀▄   █  
 █         ▄▀▀▀▀▀▄  ▄▀   █    ▄▀▄▄▄▄▀  ▄▀▄▄▄▄   █     █    █▀▀▀       ▄▀   █   ▄▀▄▄▄▄    ▄▀▄▄▄▄    ▄▀        ▄▀▄▄▄▄   █     █    █▀▀▀   
█         █       █ █    ▐   █     ▐   █    ▐   ▐     ▐    ▐          █    ▐   █    ▐    █    ▐   █          █    ▐   ▐     ▐    ▐      
▐         ▐       ▐ ▐        ▐         ▐                              ▐        ▐         ▐        ▐          ▐                          


```

## Overview 
Developing RAT (Remote Access Tool)
Inspired by [Cosmodium CS](https://github.com/CosmodiumCS)

## Resources 
- [DucKey Logger](https://github.com/PrettyBoyCosmo/DucKey-Logger)

## Components 
    - Keylogger
        - DucKey Keylogger
        - Backspace Detection
    - Screenshots
    - Webcam
    - exfiltration
        - Docs
    - Remote Access
    - Credentials
        - Web
        - Computer
        - Application
        - W-Lan
    - Advanced Reconnaissence
        - Contact Info
    - Privilege Escalation
    - Worm
    
## Roadmap
- Initial staging
- Develop Keylogger
- Screenshots
- Webcam Capture
- Credential 
- obfuscation
    - Anti Virus detection
    - disable Firewall, Anti Virus

## Stages
1. Initial FK-RAT on victims computer
    - fill initial.cmd with your informations
    - start initial.cmd
        - get wget.cmd 
            - get admin per UAC 
        - installer.ps1 
    - install all rat files
        - installer
            - make hidden admin account on victims computer
            - install persistent ssh
        - webhook to send information
            - ip (Wlan & Ethernet)
            - country
            - language
    - self delete

2. new malware initializes remote connection
    - any additional tools can be installed remotely
    - keeps a low profile on the payload
3. modualarity
    - having a directory to store resources for the RAT

## Extraneous
- Blue Screen of Death
- Web History
- User Activity
