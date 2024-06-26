# xcom-vds
xerox.com Virtual Domain Service

The Virtual Domain Service provides the ability to have virtual (or "vanity") domains that exist only to redirect to another site/URL. This is a replacement for the "bulkvirt" service hosted on the XCOM DA platform.

# Architecture
VDS is deployed as an AWS ECS service, based on a Docker image. The infrastructure for this service is deployed via a CloudFormation script located in aws/cf-vds-infra.yml.

ECS Cluster, ECS Service and Task, deployed with an ApplicationLoadBalancer

It can be deployed via command line:
    $ aws cloudformation create-stack --capabilities CAPABILITY_NAMED_IAM --stack-name xcom-vds-poc --template-body file://fargate.yml

The AWS client will need to be configured, with a user account with sufficient privileges (to be tweaked for minimum perms):
- AmazonEC2FullAcces
- AmazonECS_FullAccess
- AmazonRoute53FullAcccess
- AmazonVPCFullAccess
- AWSCloudFormationFullAccess
- CloudWatchLogsFullAccess
- IAMFullAccess


## Docker Image
The docker image is based on the official RHEL HTTPD image. mod_security is layered on top of the image, using the default mod_security configuration (for now). 

mod_security config notes
https://www.linode.com/docs/guides/securing-apache2-with-modsecurity/

The redirect configuration is then mounted on the image. See the "httpd" folder contents.

## Configuration
Virtual Domains: The virtual domains and their respective redirects are in the httpd/conf.d/vanity-redirect-map.txt. The contents of this file are straight from the bulkVirt.txt file stored in Razuna (raz1). 

Blacklist: The blacklist is maintained in httpd/conf.d/blacklist-map.txt

# CICD
This project includes a github action. On push, and new docker image will be built and published to docker.io at xeroxcom/xcom-vds. The image is currently public.

When a new image is published, there is no automated deployment into AWS ECS. The task definition will need to be updated with a new version. This is done via "Create new revision" in the task definition screen in AWS.


# Testing
curl -H "Host: www.assetdb.com" http://vdspoc.awscloud.goxerox.com


# Project TODO
- Bind allocated EIPs to ALB. IPs cannot change over time.
- Rename to remove "POC" from resource names
- Standard Xerox AWS tags on resources
- Script to register new taskdefinition revision via AWS CLI or CloudFormation

# Notes
- Describe task definition
    aws ecs describe-task-definition --task-definition VdsPocServiceTaskDefinition --output yaml
