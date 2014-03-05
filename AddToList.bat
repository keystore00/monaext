@echo Processing...
@echo off
setlocal
set basedir=%~dp0
set file=%basedir%\addr_list.txt
echo %1 >> %file%
endlocal