@echo Processing...
@echo off
setlocal
set basedir=%~dp0
set address=%1
call "%basedir%\prepare.bat"

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

copy "%basedir%\util.vbs" + "%basedir%\SendTo.vbs" "%basedir%\exec.vbs" /A
%cscript% "%basedir%\exec.vbs" %rpcuser% %rpcpassword% %rpcallowip%:%rpcport% %address% %amount% %passphrase%
endlocal