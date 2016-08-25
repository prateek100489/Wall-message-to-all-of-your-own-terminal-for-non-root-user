#!/bin/bash

#####################################################
###Example:

### sh alert hello this is a test
### [08/11/16-09:40:53]:[172.26.10.1]:[Alert]: hello this is a test
#####################################################

###Capture the message from command line and store
### it in a variable named message.

message="$@"


###Find all the terminals open for the owner.

screen=$(w|grep `whoami` |awk '{print "/dev" "/" $2}')
ip=$(printenv | grep SSH_CLIENT | awk -F= '{print $2}' |awk '{print $1}')

### Loop this message to all the screens of this user.

for line in $(echo $screen)

    do
        echo "`tput setaf 1`[`date +%D-%T`]:[$ip]:[Alert]: $message" `tput setaf 0`> "$line"

    done

###End of script
