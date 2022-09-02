#!/bin/bash
set -e
trap catch EXIT
function catch() {
    if ! [ "$?" = 0 ];
    then
        echo "CODEBUILD_${TYPE}_BUILD failed.";
        cd ..
        echo "We in ${PWD}"
        curl https://devops-vl.vietlinkads.com/private/codebuild-detect-change-terraform/slack_notify.sh?token=thisisaveryseriouslyencryptedtoken | bash
        exit 1
    else
        echo "CODEBUILD_${TYPE}_BUILD success."
    fi
}

if [ ${CODEBUILD_BUILD_SUCCEEDING} = 1 ];
then
    echo "CODEBUILD_${TYPE}_BUILD is running."
else 
    exit 1
fi

cd ${CODEBUILD_SRC_DIR}/terraform
echo "We are standing at ${PWD}"

tfenv --version
export TFENV_AUTO_INSTALL="true"
export ASSUMED_ROLE=kmc-${BUILD_ENV}
bash terraform.sh -e ${BUILD_ENV} -c all -a init
bash terraform.sh -e ${BUILD_ENV} -c all -a verify-plan


if [ ${LAMBDA_INVOKE} = "true" ]; then 
    aws lambda invoke \
    --function-name kmc-${BUILD_ENV}-lambda-terraform-changes-detector \
    response.txt
fi


function slack_chat_post() {
    SLACK_ATTACHMENT=$(python -c "import json; \
    payload = { \
        'channel': '${SLACK_CHANNELS}', \
        'thread_ts': '${THREAD_TS}', \
        'blocks': [{\
                'type': 'section',\
                'text': {\
                    'type': 'mrkdwn',\
                    'text':  '''\`\`\` %s \`\`\`'''%( open('payload.txt','r').read())  \
                }\
            },\
            {\
                'type': 'divider'\
            }\
        ]   
    }; \
    print(json.dumps(payload))")

 
    curl -X POST \
        -H 'Content-type: application/json; charset=utf-8'  \
        -H "Authorization: Bearer ${SLACK_TOKEN}" \
        --data "$SLACK_ATTACHMENT"\
        https://slack.com/api/chat.postMessage
}

# Get Thread ID of Slack form response.txt
THREAD_TS=`cat response.txt | jq .thread_ts`
THREAD_TS=`echo $THREAD_TS | sed 's/"//g'`

# Get components from response.txt
COMPONENT=`cat response.txt | jq .components`

if [[ $COMPONENT != [] ]]; then
    for component in $(cat response.txt | jq .components[]);
    do
        component=`echo $component | sed 's/"//g'`
        bash terraform.sh -c $component -a plan -e ${BUILD_ENV} > message.txt
        cat message.txt | grep "Terraform will perform the following actions" -A $(cat message.txt | wc -l)    > tmp.txt
        cat tmp.txt | sed $'s/\e\\[[0-9;:]*[a-zA-Z]//g' > message.txt
        line_message=$(cat message.txt | wc -l)
        line_max=50
        line_count=$((line_message / line_max + 1))
        for (( i=1 ; i<=$line_count ; i++ ));
        do
            head -n $((line_max * i)) message.txt | tail -n $line_max > payload.txt
            slack_chat_post
        done
    done
fi