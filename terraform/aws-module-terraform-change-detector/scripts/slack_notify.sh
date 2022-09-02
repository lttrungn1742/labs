#!/bin/bash 

function install_aws_cliv2(){
     if [ ! -d "/root/aws/" ]; then
        curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "/root/awscliv2.zip" 2>/dev/null
        unzip -q /root/awscliv2.zip -d /root
    fi
    sudo /root/aws/install --bin-dir /usr/local/bin --install-dir /usr/local/aws-cli --update 1>/dev/null
}

function get_errorlog_file (){
    /usr/local/bin/aws --version
    /usr/local/bin/aws logs tail ${LOG_GROUP_NAME} --log-stream-names ${CODEBUILD_LOG_PATH} --since ${LOG_GROUP_PERIOD}  > failed.log
    datetime="`date '+%Y-%m-%dT'`"
    cat failed.log | sed $'s/\e\\[[0-9;:]*[a-zA-Z]//g' | sed 's/\\/\\\\/g' | sed 's/\"/\\"/g' | sed "s/${CODEBUILD_LOG_PATH}//g" | sed "s/$datetime*[0-9][0-9]:[0-9][0-9]:[0-9][0-9].[0-9][0-9][0-9][0-9][0-9][0-9]+[0-9][0-9]:[0-9][0-9]//g"  > failed_2.log
}


function make_cloudwatchlogs_url (){
    ENCODED_URL=`echo ${LOG_GROUP_NAME} |sed -e 's|/|$252F|g'`
    CLOUDWATCHLOGS_URL="https://${REGION}.console.aws.amazon.com/cloudwatch/home?region=${REGION}#logsV2:log-groups/log-group/"$ENCODED_URL"/log-events"
}

function slack_chat_post() {
    for (( c=`cat failed.log | wc -l`; c>=1; c-=10 ))
    do  
        if [ `tail -n $c failed_2.log | wc -c` -lt ${COUNT_CHARACTER}  ]
        then
            tail -n $c failed_2.log > tmp.log
             SLACK_ATTACHMENT=$(python -c "import json; \
                payload = { \
                    'channel': '${SLACK_CHANNELS}', \
                    'blocks': [{\
                            'type': 'section',\
                            'text': {\
                                'type': 'mrkdwn',\
                                'text':  '''\`\`\` %s \`\`\`'''%( open('tmp.log','r').read())  \
                            }\
                        },\
                        {\
                            'type': 'divider'\
                        }\
                    ]
                }; \
                print(json.dumps(payload))")
            break
        fi
    done

 
    curl -X POST \
        -H 'Content-type: application/json; charset=utf-8'  \
        -H "Authorization: Bearer ${SLACK_TOKEN}" \
        --data "$SLACK_ATTACHMENT"\
        https://slack.com/api/chat.postMessage
}

function slack_file_upload (){

    RESULT_FILE=failed.log
    
    curl -XPOST \
         -F file=@$RESULT_FILE \
         -F "initial_comment=Failed.log" \
         -F "filetype=text" \
         -F "channels=${SLACK_CHANNELS}" \
         -H "Authorization: Bearer $SLACK_TOKEN" \
         https://slack.com/api/files.upload
}

if [ "${ENABLE_ALERT_ERROR_LOG}" != "" ]
then 
    install_aws_cliv2
    make_cloudwatchlogs_url
    SLACK_TOKEN="${SLACK_TOKEN}"
    SLACK_CHANNELS="${SLACK_CHANNELS}"
    SLACK_COLOR="warning"

    get_errorlog_file
    slack_chat_post
    slack_file_upload
fi



