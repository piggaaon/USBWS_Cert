rem Clear Command Line Screen
cls
@echo off 
setlocal EnableExtensions EnableDelayedExpansion
rem Set Variables:
  rem Set rootpath
  set "rootpath=%~dp0"
  rem Set rootpath to tools
  set "rootpathtools=%~dp0tools"
  rem Get current Date and Time
  for /f %%i in ('%rootpathtools%\date.exe +%%Y%%m%%d%%H%%M%%S') do set datetime1=%%i
rem Set Log file:
set "LOGFILE=%rootpath%\logs\USBWS_CertPublicGet_%datetime1%.log "
del %rootpath%\cacert.pem
call %rootpathtools%\wget.exe --no-hsts https://curl.haxx.se/ca/cacert.pem 2>&1 | %rootpathtools%\tee.exe -a %LOGFILE%