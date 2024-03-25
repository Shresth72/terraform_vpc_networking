#!/bin/bash

# List hosted zones
aws route53 list-hosted-zones-by-name

# Run the AWS CLI command to list all domains
aws route53 list-domains --region us-west-2 --profile tf-dev