#!/bin/bash
if [[ $1 == "apply" ]] || [[ $1 == "destroy" ]]; then
  export AWS_ACCESS_KEY_ID=${aws_creds_aws_write_access_key}
  export AWS_SECRET_ACCESS_KEY=${aws_creds_aws_write_secret_key}
  export AWS_DEFAULT_REGION=us-east-1
fi

if [[ $1 == "plan" ]]; then
  export AWS_ACCESS_KEY_ID=${aws_creds_aws_readonly_access_key}
  export AWS_SECRET_ACCESS_KEY=${aws_creds_aws_readonly_secret_key}
  export AWS_DEFAULT_REGION=us-east-1
fi

# AWS credentials are eventually consistent, wait a little before running terraform
sleep 10

terraform init
terraform $1 $2
