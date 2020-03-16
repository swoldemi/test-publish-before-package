#!/bin/bash

BUCKET_PREFIX=swoldemi
APPLICATION=test-publish-before-package
ACCOUNT=273450712882
declare -a REGIONS=(
    "ap-east-1"
    "ap-south-1"
    "ap-northeast-2"
    "ap-southeast-1"
)

publish_all_regions()
{   
    for REGION in "${REGIONS[@]}"
    do  
        echo Deploying to region $REGION
        sam publish --region $REGION --template packaged.yaml 
	    sam package --template-file template.yaml --s3-bucket $BUCKET_PREFIX-$REGION --output-template-file packaged.yaml
        aws serverlessrepo put-application-policy \
            --region $REGION \
            --application-id arn:aws:serverlessrepo:us-east-1:273450712882:applications/$APPLICATION \
            --statements Principals=*,Actions=Deploy
    done
}

echo "On branch `basename $CODEBUILD_WEBHOOK_HEAD_REF`"
if [ "`basename $CODEBUILD_WEBHOOK_HEAD_REF`" = "master" ]
then 
    publish_all_regions
else
    echo Skipping publish
fi
