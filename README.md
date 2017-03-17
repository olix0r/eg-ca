# eg-ca #

An example Certificate Authority.  ONLY USEFUL FOR TESTING.  YOU HAVE BEEN WARNED.

Loosely based on [[https://jamielinux.com/docs/openssl-certificate-authority/index.html]].

## Usage ##

```sh
:; ./initca.sh
:; ./mksvc.sh buoyant.io
:; ls -1 **/buoyant.io*
certs/buoyant.io.cert.p12
certs/buoyant.io.cert.pem
csr/buoyant.io.csr.pem
private/buoyant.io.p12
private/buoyant.io.p8
private/buoyant.io.pem
```