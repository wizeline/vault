#!/bin/bash
# Static environment variables
REGION='us-west-2'
BRAND='natgeo'
ENV='CC'
BASE_TEMPLATE='vault_template.yaml'
SERVICE="cup-manager-vault"
TEMPLATES_BUCKET="${BRAND}-cc-${SERVICE}-cf-templates"
STACK_NAME="${BRAND}-${ENV}-${SERVICE}-${NAME_VAR}-stack"
VPC="vpc-53f7a92a"
VPCCIDR="172.31.0.0/16"
KEYPAIR="vault_dev_wz_natgeo"
SubNet1="subnet-2d259f54"

BRAND_TEMPLATE="${BRAND}-${ENV}-${SERVICE}-${VERSION}-packaged-template.yaml"
./upload_config.sh

sam package \
    --template-file ${BASE_TEMPLATE} \
    --output-template-file ${BRAND_TEMPLATE} \
    --s3-bucket ${TEMPLATES_BUCKET}

sam deploy \
    --region ${REGION} \
    --template-file ${BRAND_TEMPLATE} \
    --stack-name ${STACK_NAME} \
    --s3-bucket ${TEMPLATES_BUCKET} \
    --capabilities CAPABILITY_IAM \
    --parameter-overrides \
        EnvType=${ENV} \
        KeyPair=${KEYPAIR} \
        VPCID=${VPC} \
        VPCCIDR=${VPCCIDR} \
        PrivateSubnet1ID=${SubNet1} \
        AccessCIDR="0.0.0.0/0"
        