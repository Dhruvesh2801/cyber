@echo off
cd /d "%~dp0"
git add -A
git commit -m "Backup %date% %time%"
git push
echo Backup completed!
pause