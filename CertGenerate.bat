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
set "LOGFILE=%rootpath%logs\USBWS_CertGenerate_%datetime1%.log "
rem ------------------------------------------------------------------------
(
  rem Script Variables:
  rem Set Hostname for Cert to use (ie.. localhost, 127.0.0.1, server1.a.com)
    set "loca=localhost"
  rem ------------------------------------------------------------------------
  echo Create SSL CA/Cert/Key for Server/Client in Windows
  echo ------------------------------------------------------------------------------------------------
  set OPENSSL_CONF=%~dp0/../USBWS_HTTPd/conf/openssl.cnf
  echo Create CA certificate
  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  %~dp0/../USBWS_HTTPd/bin/openssl.exe genrsa 2048 > ./ca-key.pem
  %~dp0/../USBWS_HTTPd/bin/openssl.exe req -new -x509 -nodes -days 3650 -key ./ca-key.pem -out ./ca.pem -subj "/C=US/ST=USBWState/L=USBWSTown/O=USBWS/OU=USBWSSecure/CN=%loca%Ca"
  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  echo Create server certificate, remove passphrase, and sign it
  echo server-cert.pem = public key, server-key.pem = private key
  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  %~dp0/../USBWS_HTTPd/bin/openssl.exe req -newkey rsa:2048 -nodes -keyout ./server-key.pem -out ./server-req.pem -subj "/C=US/ST=USBWState/L=USBWSTown/O=USBWS/OU=USBWSSecure/CN=%loca%"
  %~dp0/../USBWS_HTTPd/bin/openssl.exe rsa -in ./server-key.pem -out ./server-key.pem
  %~dp0/../USBWS_HTTPd/bin/openssl.exe x509 -req -in ./server-req.pem -days 3650 -CA ./ca.pem -CAkey ./ca-key.pem -set_serial 01 -out ./server-cert.pem
  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  echo Create client certificate, remove passphrase, and sign it
  echo client-cert.pem = public key, client-key.pem = private key
  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  %~dp0/../USBWS_HTTPd/bin/openssl.exe req -newkey rsa:2048 -nodes -keyout ./client-key.pem -out ./client-req.pem -subj "/C=US/ST=USBWState/L=USBWSTown/O=USBWS/OU=USBWSSecure/CN=%loca%"
  %~dp0/../USBWS_HTTPd/bin/openssl.exe rsa -in ./client-key.pem -out ./client-key.pem
  %~dp0/../USBWS_HTTPd/bin/openssl.exe x509 -req -in ./client-req.pem -days 3650 -CA ./ca.pem -CAkey ./ca-key.pem -set_serial 01 -out ./client-cert.pem
  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  echo Certificate Verification:
  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
  %~dp0/../USBWS_HTTPd/bin/openssl verify -CAfile ./ca.pem ./server-cert.pem ./client-cert.pem
  echo ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
) > %LOGFILE% 2>&1 
type %LOGFILE%