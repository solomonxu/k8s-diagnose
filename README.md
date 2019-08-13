# k8s-diagnose
This is a diagnose program for kubernetes and OS which runs on.
The version v0.0.2 can send test email using config.

How to use the shell:

1. Clone the project to your local directory.
   git clone https://github.com/solomonxu/k8s-diagnose.git
   
2. Create your own config files.
   cd  k8s-diagnose/conf
   cp diag-sample.conf diag.conf
   cp mail-sample.rc mail.rc
   
3. Modify config files, fit to your real email service.

   vi diag.conf
## email of notify
notify_type=email
notify_email_account=7094****@qq.com
notify_email_recipients=7000****@qq.com

   vi mail.rc
## 7094****@@qq.com
account 7094****@qq.com {
    set smtp=smtps://smtp.qq.com:465
    set smtp-auth=login
    set smtp-auth-user=7094****@@qq.com
    set smtp-auth-password="password or auth-code"
    set from=7094****@qq.com
    set ssl-verify=ignore
    set nss-config-dir=/etc/pki/nssdb
}

4. Change permission of shell.
   cd bin
   chmod -R a+x *
  
5. Run shell and test to send emal.
   cd bin
   ./test/test-common.sh
  
