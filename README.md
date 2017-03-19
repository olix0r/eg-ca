# eg-ca #

An example Certificate Authority.  ONLY USEFUL FOR TESTING.  YOU HAVE BEEN WARNED.

Based on https://jamielinux.com/docs/openssl-certificate-authority/.

## Usage ##

```sh
:; ./init.sh >/dev/null 2>&1
:; ./mksvc.sh test.olix0r.net >/dev/null 2>&1
:; ls -1 test.olix0r.net.tls
ca-chain.cert.pem
cert.pem
private.pem
```
