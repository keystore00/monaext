@echo off
setlocal
set basedir=%~dp0
set sendto=%1
call "%basedir%\params.bat"
if exist "%systemroot%\syswow64\" (
  C:\Windows\SysWOW64\cscript.exe "%basedir%\exec.vbs" %rpcuser%:%rpcpassword% %rpcallowip%:%rpcport% %sendto% %passphrase%
) else (
  cscript "%basedir%\exec.vbs" %rpcuser%:%rpcpassword% %rpcallowip%:%rpcport% %sendto% %passphrase%
)
endlocal