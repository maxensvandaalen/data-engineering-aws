#!/bin/bash

AWS_ID=$(aws sts get-caller-identity --query "Account" --output text) 

echo "Reading configuration variables"
source infra_variables.sh

echo "Deleting all objects in bucket: $S3_BUCKET"
aws s3 rm s3://$S3_BUCKET \
    --recursive \
    --output text >> tear_down.log

echo "Deleting bucket $S3_BUCKET"
aws s3api delete-bucket \
    --bucket $S3_BUCKET \
    --output text >> tear_down.log