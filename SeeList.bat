@echo Address list
@echo off
setlocal
set basedir=%~dp0
set file=%basedir%\addr_list.txt
type %file%
pause
endlocal