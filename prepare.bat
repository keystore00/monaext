call "%basedir%\params.bat"
if exist "%systemroot%\syswow64" (
  set cscript=%systemroot%\syswow64\cscript.exe
) else (
  set cscript=cscript
)
