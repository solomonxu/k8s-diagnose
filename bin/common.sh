#!/usr/bin/bash

## define const
nss_config_dir=/etc/pki/nssdb

## notify receivers
notify()
{
	if [ "${notify_type}"=email ]; then
	    notify_email $@
	else
	    echo "No notify defined."
	fi
}

## notify receivers by email
notify_email()
{
    ## check mailx command
    check_and_install_mailx;
	## install smtp sslcert
	install_smtp_sslcert;
	## debug mode
	echo "DEBUG=${DEBUG}"
	if [ "${DEBUG}" = "true" ]; then
	    echo "Enable mailx DEBUG mode."
	    EMAIL_DEBUG="-d"
	fi
	## make message 
	EMAIL_MESSAGE_BODY="echo 'No message body.'"
	EMAIL_MESSAGE="-s 'No message subject'"
	if [ $# -ge 1 ]; then
	    EMAIL_MESSAGE="-s '$1'"
	fi
	if [ $# -ge 2 ]; then
	    if [ -s '$2' ]; then
		    EMAIL_MESSAGE_BODY="cat '$2'"
        else
            EMAIL_MESSAGE_BODY="echo '$2'"
		fi 
	    EMAIL_MESSAGE="${EMAIL_MESSAGE} -q '$2'"
	fi
	if [ $# -ge 3 ]; then
		if [ -s '$3' ]; then
	 	   EMAIL_MESSAGE="${EMAIL_MESSAGE} -a '$3'"
		fi
	fi
	## make receivers and login
    EMAIL_RECEIVER="-c ${email_receivers}"
    #EMAIL_LOGIN="-S smtp=smtp://${email_smtp} -S smtp-auth=${email_sender_auth} -S smtp-auth-user=${email_sender_user} -S smtp-auth-password=${email_sender_password} -S ssl-verify=${email_ssl_verify} -S nss-config-dir=${nss_config_dir} -S from=${email_sender_from} -S smtp-use-starttls=${email_use_starttls} ${email_receivers}"
	EMAIL_LOGIN="-S smtp=smtp://${email_smtp} smtp-auth=${email_sender_auth} smtp-auth-user=${email_sender_user} smtp-auth-password=${email_sender_password} ssl-verify=${email_ssl_verify} nss-config-dir=${nss_config_dir} from=${email_sender_from} smtp-use-starttls=${email_use_starttls} ${email_receivers}"
	## send mail
	echo ${EMAIL_MESSAGE_BODY}
    `${EMAIL_MESSAGE_BODY}` | mailx ${EMAIL_DEBUG} ${EMAIL_MESSAGE} ${EMAIL_RECEIVER} ${EMAIL_LOGIN}
	
	return 0;
}

## check if mailx installed, if not then install it
check_and_install_mailx()
{
    ## check and install mailx
    mailx_cmd=`which mailx`
    echo mailx_cmd=$mailx_cmd
    if [ -z "$mailx_cmd" ]; then
       echo "mailx not installed on this host. Start to install mailx now..."
       yum install -y mailx
    fi
}

## check if smtp sslcert installed, if not then install it
install_smtp_sslcert()
{
    ## check smtp sslcert
	smtp_sslcert_file=${nss_config_dir}/${email_sender_user}.crt
    echo smtp_sslcert_file=$smtp_sslcert_file
	## check smtp sslcert
    if [ -s "${smtp_sslcert_file}" ]; then
	   return;
    fi
	## 
	## downlowd smtp sslcert
	echo "downlowd smtp sslcert for ${email_sender_user}..." 
    echo -n "" | openssl s_client -connect ${email_smtp} | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ${smtp_sslcert_file}
	## add sslcert file ${smtp_sslcert_file} to trusted list
	echo "add smtp sslcert ${email_sender_user} to trusted list." 
	certutil -A -n ${email_sender_user} -t "P,P,P" -d ${nss_config_dir} -i ${smtp_sslcert_file}
}

