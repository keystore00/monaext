@echo Processing...
@echo off
setlocal
set basedir=%~dp0
set txid=%1
call "%basedir%\prepare.bat"

copy "%basedir%\util.vbs" + "%basedir%\FindAddress.vbs" "%basedir%\exec.vbs" /A
%cscript% "%basedir%\exec.vbs" %rpcuser% %rpcpassword% %rpcallowip%:%rpcport%
endlocal