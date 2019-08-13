#!/usr/bin/bash

## define const
nss_config_dir=/etc/pki/nssdb

## notify recipients
notify()
{
	if [ "${notify_type}"=email ]; then
	    notify_email $@
	else
	    echo "`date` No notify defined."
	fi
}

## notify recipients by email
notify_email()
{
    ## check mailx command
    check_and_install_mailx;
	## install smtp sslcert
	download_smtp_sslcert;
	## debug mode
	echo "DEBUG=${DEBUG}"
	if [ "${DEBUG}" = "true" ]; then
	    echo "`date` Enable mailx DEBUG mode."
	    EMAIL_DEBUG="-d"
	fi
	## default message 
	EMAIL_MESSAGE_BODY="No message body."
	EMAIL_MESSAGE="-s 'No message subject'"
	## make message subject
	if [ -n '${message_subject}' ]; then
	    EMAIL_MESSAGE="-s '${message_subject}'"
	fi
	## make message body
	if [ -n '${message_body}' ]; then
	    if [ -s '${message_body}' ]; then
		    EMAIL_MESSAGE_BODY=`cat ${message_body}`
        else
            EMAIL_MESSAGE_BODY=${message_body}
		fi
	fi
	## make message attachment
	if [ -n '${message_attachment}' ]; then
		if [ -s '${message_attachment}' ]; then
	 	   EMAIL_MESSAGE="${EMAIL_MESSAGE} -a '${message_attachment}'"
		fi
	fi
	## make recipients and login
    EMAIL_RECIPIENT="-c ${email_sender_user}"
    EMAIL_LOGIN="-S smtp=smtp://${email_smtp} -S smtp-auth=${email_sender_auth} -S smtp-auth-user=${email_sender_user} -S smtp-auth-password=${email_sender_password} -S ssl-verify=${email_ssl_verify} -S nss-config-dir=${nss_config_dir} -S from=${email_sender_from} -S smtp-use-starttls=${email_use_starttls} ${email_recipients}"
	#EMAIL_LOGIN="-S smtp=smtp://${email_smtp} smtp-auth=${email_sender_auth} smtp-auth-user=${email_sender_user} smtp-auth-password=${email_sender_password} ssl-verify=${email_ssl_verify} nss-config-dir=${nss_config_dir} from='${email_sender_from}' smtp-use-starttls=${email_use_starttls} ${email_recipients}"
	## send mail
	echo EMAIL_MESSAGE=${EMAIL_MESSAGE}
	echo EMAIL_MESSAGE_BODY=${EMAIL_MESSAGE_BODY}
	SEND_COMMAND="mailx ${EMAIL_DEBUG} ${EMAIL_MESSAGE} ${EMAIL_RECIPIENT} ${EMAIL_LOGIN}"
	echo SEND_COMMAND="${SEND_COMMAND}"
	#echo "mailx ${EMAIL_DEBUG} ${EMAIL_MESSAGE} ${EMAIL_RECIPIENT} ${EMAIL_LOGIN}"
    #echo ${EMAIL_MESSAGE_BODY} | mailx ${EMAIL_DEBUG} ${EMAIL_MESSAGE} ${EMAIL_RECIPIENT} ${EMAIL_LOGIN}
	echo "`date` Send diagnose report by E-mail now. The report has subject: ${message_subject}, and recipients: ${email_recipients}."	
	echo ${EMAIL_MESSAGE_BODY} | ${SEND_COMMAND}
	
	return 0;
}

## check if mailx installed, if not then install it
check_and_install_mailx()
{
    ## check and install mailx
    mailx_cmd=`which mailx`
    echo mailx_cmd=$mailx_cmd
    if [ -z "$mailx_cmd" ]; then
       echo "`date` mailx not installed on this host. Start to install mailx now..."
       yum install -y mailx
    fi
}

## check if smtp sslcert downloaded, if not then download it
download_smtp_sslcert()
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
	echo "`date` downlowd smtp sslcert for ${email_sender_user}..." 
    echo -n "" | openssl s_client -connect ${email_smtp} | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ${smtp_sslcert_file}
	## add sslcert file ${smtp_sslcert_file} to trusted list
	echo "`date` add smtp sslcert ${email_sender_user} to trusted list." 
	#certutil -A -n ${email_sender_user} -t "P,P,P" -d ${nss_config_dir} -i ${smtp_sslcert_file}
	certutil -A -n "GeoTrust SSL CA" -t "C,,"  -d ${nss_config_dir} -i ${smtp_sslcert_file}
	certutil -A -n "GeoTrust Global CA" -t "C,," -d ${nss_config_dir} -i ${smtp_sslcert_file}
	certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu" -d ${nss_config_dir} -i ${smtp_sslcert_file}
	certutil -L -d ${nss_config_dir}
}

