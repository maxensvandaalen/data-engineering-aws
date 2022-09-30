#!/bin/bash

# make sure aws cli is installed and configured
# see https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-configure.html for configuration

AWS_ID=$(aws sts get-caller-identity --query "Account" --output text) 

: '
Provide the following variables in a config_variables.sh file:
    S3_BUCKET="<YOUR S3 BUCKET NAME>"
    AWS_REGION="<YOUR AWS LOCATION>"
 
'
echo "Reading configuration variables"
source infra_variables.sh

echo "Creating bucket $S3_BUCKET"
aws s3api create-bucket \
    --region $AWS_REGION \
    --bucket $S3_BUCKET \
    --create-bucket-configuration LocationConstraint=$AWS_REGION \
    --output text >> setup.log

echo "Restricting public access to bucket"
aws s3api put-public-access-block \
    --bucket $S3_BUCKET \
    --public-access-block-configuration "BlockPublicAcls=true,IgnorePublicAcls=true,BlockPublicPolicy=true,RestrictPublicBuckets=true"