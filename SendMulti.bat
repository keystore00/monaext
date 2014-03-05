@echo Processing...
@echo off
setlocal
set basedir=%~dp0
call "%basedir%\params.bat"
call "%basedir%\prepare.bat"

if "%1"=="" (
  ::default list
  set file=%basedir%\addr_list.txt
) else (
  set file=%1
)

if "%passphrase%"=="" (
  set passphrase=
) else (
  set passphrase="%passphrase%"
)

copy "%basedir%\util.vbs" + "%basedir%\SendMulti.vbs" "%basedir%\exec.vbs" /A
%cscript% "%basedir%\exec.vbs" %rpcuser% %rpcpassword% %rpcallowip%:%rpcport% %file% %passphrase%

:: if "%1"=="" (
::   ::reset list file
::   del %file%
:: )

endlocal