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
if "%passphrase%"=="" (
  set passphrase=
) else (
  set passphrase="%passphrase%"
)
call "%basedir%\params.bat"
if exist "%systemroot%\syswow64" (
  set cscript=%systemroot%\syswow64\cscript.exe
) else (
  set cscript=cscript
)

%cscript% "%basedir%\exec.vbs" %rpcuser% %rpcpassword% %rpcallowip%:%rpcport% %sendto% %amount% %passphrase%
endlocal