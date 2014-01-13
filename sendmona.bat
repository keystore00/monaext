@echo Processing...
@echo off
setlocal
set basedir=%~dp0
set sendto=%1
if "%2"=="" (
  set amount=0
) else (
  set amount=%2
)
call "%basedir%\params.bat"
if exist "%systemroot%\syswow64\" (
  C:\Windows\SysWOW64\cscript.exe "%basedir%\exec.vbs" %rpcuser%:%rpcpassword% %rpcallowip%:%rpcport% %sendto% %amount% %passphrase%
) else (
  cscript "%basedir%\exec.vbs" %rpcuser%:%rpcpassword% %rpcallowip%:%rpcport% %sendto% %amount% %passphrase%
)
endlocal