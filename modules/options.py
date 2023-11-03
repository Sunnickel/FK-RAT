import os
import readline

from modules import payloads as pay


def edit_file(file):
    config = pay.read_config(file)
    username = rlinput("       Username   : ", config.get("USERNAME"))
    ip = rlinput("       Ip         : ", config.get("IPADDRESS"))
    password = rlinput("       Password   : ", config.get("PASSWORD"))

    target_file = open(f"./targets/{file}", "w")
    target_file.write(f"{ip} \n{password} \n{username}")


def rlinput(prompt, prefill=''):
    readline.set_startup_hook(lambda: readline.insert_text(prefill))
    try:
        return input(prompt)  # or raw_input in Python 2
    finally:
        readline.set_startup_hook()


def new_file():
    file_name = input(f"Filename   : ")
    username = input(f"Username   : ")
    ip = input(f"Ip         : ")
    password = input(f"Password   : ")

    if not os.path.exists("./targets"):
        os.mkdir("./targets")
    target_file = open(f"./targets/{file_name}.fk", "x")
    target_file = open(f"./targets/{file_name}.fk", "w")
    target_file.write(f"{ip} \n{password} \n{username}")


def delete_file(file):
    os.remove("./targets/" + file)
