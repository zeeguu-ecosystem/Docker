#!/bin/bash

# API keys should be in the environment; otherwise, you can also set them here...
# export MICROSOFT_TRANSLATE_API_KEY=''
# export GOOGLE_TRANSLATE_API_KEY=''
# export WORDNIK_API_KEY=''

# on some Linuxes route and ifconfig are not available
if ! {  which route >/dev/null &&  which ifconfig >/dev/null  ; } ; then
    apt-get install -y net-tools
fi
# same with curl
if ! {  which curl >/dev/null ; } ; then
    apt-get install curl -y
fi

# Set to YES if running in the cloud
RUNNING_IN_CLOUD='NO'

# Trying to detect if running in a cloud...
curl metadata.google.internal -si 2>&1>/dev/null
if [ $? -eq 0 ]; then
    RUNNING_IN_CLOUD='YES'
fi
curl http://169.254.169.254/1.0/meta-data/instance-id -s 2>&1>/dev/null
if [ $? -eq 0 ]; then
    RUNNING_IN_CLOUD='YES'
fi

if [ "$RUNNING_IN_CLOUD" == "NO" ]; then
    DEFAULT_INTERFACE=$(route | grep -m 1 -oP '^default.*\s+\K.*')
    export SERVER_IP=$(ifconfig $DEFAULT_INTERFACE | grep "inet " | awk '{print $2}')
else
    # Get the public IP if running in the cloud
    export SERVER_IP="$(dig +short myip.opendns.com @resolver1.opendns.com)"
fi
