@echo off
setlocal
set basedir=%~dp0
set file=%basedir%\addr_list.txt
start notepad %file%
endlocal