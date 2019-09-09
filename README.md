# USBWS_Cert README
I wrote this script(s) as a developer so that I can my own self signed
certificates. USBWS_Cert will be include in updated USBWS.

Third party software used:
- CoreUtils     : https://packages.msys2.org/base/coreutils
- wget.exe      : https://eternallybored.org/misc/wget/
- cacert.pem    : https://curl.haxx.se/docs/caextract.html

Information used to create Certificates:
- Example 1: Creating SSL Files from the Command Line on Unix (https://dev.mysql.com/doc/refman/8.0/en/creating-ssl-files-using-openssl.html)
- 

------------
## Install Instructions:

Download and extract zip; to root of USBWS.

------------
## Setup Instructions:
1. Stop Webserver and DB Sever (httpd and mydqld)

2. Run CertPublicGet.bat (Downloads cacert.pem)

3. Run CertGenerate.bat (Generates client and server keys/cert/req)

4. Edit each server configuration files and add locations to certs.
   See Examples below are configured for use with USBWS.

------------
Exmaple Setting in confgiuration files for HTTPd,MariaDB,PHP,PHPMyAdmin for USBWS:

------------

## httpd.conf:
  NOTE: Uncomment "LoadModule ssl_module modules/mod_ssl.so" in modules section.
  LoadModule ssl_module modules/mod_ssl.so
  SSLCertificateFile "{path}/USBWS_Cert/server-cert.pem"
  SSLCertificateKeyFile "{path}/USBWS_Cert/server-key.pem"
  #SSLCertificateChainFile "{path}/USBWS_Cert/server-cert.pem"
  #SSLCACertificatePath "{path}/USBWS_Cert"
  SSLCACertificateFile "{path}/USBWS_Cert/ca.pem"

## my.ini:
  [mysqld]
  ssl = On
  ssl-ca = {path}/USBWS_Cert/ca.pem
  ssl-key = {path}/USBWS_Cert/server-key.pem
  ssl-cert = {path}/USBWS_Cert/server-cert.pem
  [mysql]
  ssl-ca = {path}/USBWS_Cert/ca.pem
  ssl-key = {path}/USBWS_Cert/client-key.pem
  ssl-cert = {path}/USBWS_Cert/client-cert.pem

## php.ini:
  [curl]
  curl.cainfo = "{path}\USBWS_Cert\cacert.pem"
  [openssl]
  openssl.cafile = "{path}\USBWS_Cert\cacert.pem"
  openssl.capath = "{path}\USBWS_Cert\"

## config.inc.php:
  $cfg['Servers'][$i]['ssl'] = true;  // USBWS Setting
  $cfg['Servers'][$i]['ssl_key'] = $_SERVER["DOCUMENT_ROOT"]."../USBWS_Cert/client-key.pem";  // USBWS Setting
  $cfg['Servers'][$i]['ssl_cert'] = $_SERVER["DOCUMENT_ROOT"]."../USBWS_Cert/client-cert.pem";  // USBWS Setting
  $cfg['Servers'][$i]['ssl_ca'] = $_SERVER["DOCUMENT_ROOT"]."../USBWS_Cert/ca.pem";  // USBWS Setting
  $cfg['Servers'][$i]['ssl_ca_path'] = $_SERVER["DOCUMENT_ROOT"]."../USBWS_Cert/";  // USBWS Setting
  $cfg['Servers'][$i]['ssl_ciphers'] = 'TLSv1.2'; // USBWS Setting

------------

**The Code for USBWS_Cert has been released under the MIT License:**

MIT License

Copyright (c) 2018  Piggaaon

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.
