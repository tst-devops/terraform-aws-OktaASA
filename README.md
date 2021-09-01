# terraform-aws-OktaASA
Testing deploying EC2 instance and Okta ASA

Certificate verification errors when using Zscaler ZIA with SSL Inspection
Normally the Zscaler root certificate is installed in the approriate system Root Certificate store so that the system/browsers trusts the certificate generated during TLS Inspection. However, some applications do not read the system certificate store.

Typical Error
unable to access <Git_Reo>: server certificate verification failed. CAfile: none CRLfile: none

Windows
    GIT
        - From Powershell run
        - gc .\ZscalerRootCertificate-2048-SHA256.crt| ac $(git config --get http.sslcainfo)

Linux
    Base Operating System
        - cp ZscalerRootCertificate-2048-SHA256.crt $(openssl version -d | cut -f2 -d \")/certs
        - Alternatively you can place the file into the anchors directory
            cp ZscalerRootCertificate-2048-SHA256.crt /etc/pki/ca-trust/source/anchors/ && update-ca-trust


        