#!/bin/bash

#######################################################
## To prevent this tool to print on terminal         ##
## mesg n                                            ##
## To enable this tool ability to print on terminal  ##
## mesg y                                            ##
#######################################################

#if this is set to 1, all your messages will be stored at ${log_location}
 logging_enabled=0
 log_location=/home/${USER}/.personal/wall_messages.log
 term_list=$(find /dev/pts -mindepth 1 -maxdepth 1 -type c -user "${USER}" ! -path "$(tty)" -print 2>/dev/null)


 if [ "${term_list:-0}" == "0" ];then
     echo "Error: No other terminal open to wall"
     exit 1;
 fi

 if [ $# -eq 0 ];then
      message=$(</dev/stdin)
 elif [ $# -eq 1 ];then
     message="$1"
 else
     echo -e 'Syntax: wallme "message to be walled over all terminals"\nor\nJust use "wallme" CTRL + D to exit.'
     exit 2;
 fi

 if [ ${logging_enabled} -ne 0 ];then
     if [ ! -d ${log_location} ];then
         mkdir -p ${log_location} 2>/dev/null
         if [ $? -ne 0 ];then
             echo "Error: Could not create ${log_location}"
         fi
         chmod -R 700 ${log_location}
     fi
     log_file=${log_location}/$(date +%s)
     echo -e "$(date)\n$message" >> "${log_file}"
 fi

 while IFS= read -r term
 do
     echo -e "$(date)\n${message}"  |write  "${USER}" "$term" 2>/dev/null
 done <<< "${term_list}"

 if [ ${logging_enabled} -ne 0 ];then
     echo "This record has been stored at ${log_file}"
 fi
