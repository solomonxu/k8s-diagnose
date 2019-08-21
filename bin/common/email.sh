#!/usr/bin/bash

## include shells
. ./common/logger.sh

## define const
nss_config_dir=/etc/pki/nssdb
export MAILRC=../conf/mail.rc

## notify recipients
notify()
{
    if [ "${notify_type}"=email ]; then
        notify_email $@
    else
        #echo "`date` No notify defined."
        logger_warn "No notify defined."
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
        #echo "`date` Enable mailx DEBUG mode."
        logger_info "Enable mailx DEBUG mode."
        EMAIL_DEBUG="-d"
    fi

    ## default message
    EMAIL_MESSAGE_SUBJECT="No message subject"
    EMAIL_MESSAGE_BODY="No message body."
    EMAIL_MESSAGE_ATTACHMENT=""
    ## make message subject
    if [ -n "${message_subject}" ]; then
        EMAIL_MESSAGE_SUBJECT="${message_subject}"
    fi
    ## make message body
    if [ -n "${message_body}" ]; then
        if [ -s '${message_body}' ]; then
            EMAIL_MESSAGE_BODY=`cat ${message_body}`
        else
            EMAIL_MESSAGE_BODY="${message_body}"
        fi
    fi
    ## make message attachment
    if [ -n "${message_attachment}" ]; then
        if [ -s "${message_attachment}" ]; then
            EMAIL_MESSAGE_ATTACHMENT="-a ${message_attachment}"
            #echo "file ${message_attachment} found."
            logger_info "file ${message_attachment} found."
        else
            #echo "file ${message_attachment} not found, can't be attached to email."
            logger_warn "file ${message_attachment} not found, can't be attached to email."
        fi
    fi
    ## make recipients and login
    EMAIL_LOGIN="-A ${notify_email_account}"
    EMAIL_CC="-c ${notify_email_account}"

    ## send mail
    #echo "`date` Send diagnose report by E-mail now. The report has subject: '${message_subject}', and the recipients are: ${notify_email_recipients}."	
    #echo MAILRC=${MAILRC}
    #echo EMAIL_MESSAGE_SUBJECT=${EMAIL_MESSAGE_SUBJECT}
    #echo EMAIL_MESSAGE_BODY=${EMAIL_MESSAGE_BODY}
    #echo EMAIL_MESSAGE_ATTACHMENT=${EMAIL_MESSAGE_ATTACHMENT}	
    logger_info "Send diagnose report by E-mail now. The report has subject: '${message_subject}', and the recipients are: ${notify_email_recipients}."	
    logger_info MAILRC = ${MAILRC}
    logger_info EMAIL_MESSAGE_SUBJECT = ${EMAIL_MESSAGE_SUBJECT}
    logger_info EMAIL_MESSAGE_BODY = ${EMAIL_MESSAGE_BODY}
    logger_info EMAIL_MESSAGE_ATTACHMENT = ${EMAIL_MESSAGE_ATTACHMENT}	
    SEND_COMMAND="mail ${EMAIL_DEBUG} ${EMAIL_LOGIN} ${EMAIL_CC} -s '${EMAIL_MESSAGE_SUBJECT}' ${EMAIL_MESSAGE_ATTACHMENT} ${notify_email_recipients}"
    #echo SEND_COMMAND="${SEND_COMMAND}"
    #echo "${EMAIL_MESSAGE_BODY}" | mail ${EMAIL_DEBUG} ${EMAIL_LOGIN} ${EMAIL_CC} -s "${EMAIL_MESSAGE_SUBJECT}" ${EMAIL_MESSAGE_ATTACHMENT} ${notify_email_recipients}
    logger_info SEND_COMMAND = "${SEND_COMMAND}"
    logger_info "${EMAIL_MESSAGE_BODY}" | mail ${EMAIL_DEBUG} ${EMAIL_LOGIN} ${EMAIL_CC} -s "${EMAIL_MESSAGE_SUBJECT}" ${EMAIL_MESSAGE_ATTACHMENT} ${notify_email_recipients}

    return 0;
}

## check if mailx installed, if not then install it
check_and_install_mailx()
{
    ## check and install mailx
    mailx_cmd=$(which mailx)
    #echo mailx_cmd = $mailx_cmd
    logger_info "mailx_cmd = ${mailx_cmd}"
    if [ -z "$mailx_cmd" ]; then
        #echo "`date` mailx not installed on this host. Start to install mailx now..."
        logger_warn "mailx not installed on this host. Start to install mailx now..."
        yum install -y mailx
    fi
}

## check if smtp sslcert downloaded, if not then download it
download_smtp_sslcert()
{
    ## check smtp sslcert
    smtp_sslcert_file=${nss_config_dir}/${notify_email_account}.crt
    #echo smtp_sslcert_file=$smtp_sslcert_file
    logger_info smtp_sslcert_file=$smtp_sslcert_file
    ## check smtp sslcert
    if [ -s "${smtp_sslcert_file}" ]; then
        return;
    fi
    ## 
    ## downlowd smtp sslcert
    #echo "`date` downlowd smtp sslcert for ${notify_email_account}..." 
    logger_info "Downlowd smtp sslcert for ${notify_email_account}..." 
    echo -n "" | openssl s_client -connect ${email_smtp} | sed -ne '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p' > ${smtp_sslcert_file}
    ## add sslcert file ${smtp_sslcert_file} to trusted list
    #echo "`date` add smtp sslcert ${notify_email_account} to trusted list."
    logger_info "Add smtp sslcert ${notify_email_account} to trusted list." 
    #certutil -A -n ${notify_email_account} -t "P,P,P" -d ${nss_config_dir} -i ${smtp_sslcert_file}
    certutil -A -n "GeoTrust SSL CA" -t "C,,"  -d ${nss_config_dir} -i ${smtp_sslcert_file}
    certutil -A -n "GeoTrust Global CA" -t "C,," -d ${nss_config_dir} -i ${smtp_sslcert_file}
    certutil -A -n "GeoTrust SSL CA - G3" -t "Pu,Pu,Pu" -d ${nss_config_dir} -i ${smtp_sslcert_file}
    certutil -L -d ${nss_config_dir}
}