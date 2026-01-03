AWS Data Engineering CI/CD

## Overview

This project implements a stable and repeatable CI/CD setup for AWS Data Engineering workloads using AWS Glue, AWS Lambda, and AWS CloudFormation.

The solution intentionally separates build and deployment responsibilities to avoid CodePipeline CloudFormation session-policy limitations and to ensure deterministic, reliable infrastructure deployments.

## Architecture

Services Used:

- AWS Glue (ETL job)
- AWS Lambda
- AWS CloudFormation (Infrastructure as Code)
- AWS CodePipeline (Source + Build only)
- Amazon S3 (artifact storage)

High-Level Flow:

GitHub
|
v
CodePipeline

- Source
- Build (validation only, no deployment)

Deployment

- CloudFormation via AWS CLI

## Repository Structure

aws-data-engineering-cicd/

infra/
cloudformation/
glue-lambda-dev.yaml

glue/
sample_glue_job.py

lambda/
sample_lambda.py

deploy/
deploy-dev.ps1

buildspec.yml
README.txt
.gitignore

## Deployment Strategy

Deployment is intentionally NOT performed inside CodePipeline.

Reason:

- CodePipeline injects restrictive session policies
- CloudFormation deploy actions require S3 ListBucket permissions
- Console-based CloudFormation deploy is limited for S3 templates
- These limitations cause non-deterministic failures

To ensure stability, deployment is executed using AWS CLI outside the pipeline.
This is a deliberate architectural decision, not a workaround.

## Infrastructure Deployment

Infrastructure is deployed exclusively using AWS CLI and CloudFormation.

Prerequisites:

- AWS CLI installed and configured
- Permission to assume the CloudFormation deployment role

Deployment Role:
cloudformation-deploy-role

Deploy Command (from repo root):

.\deploy\deploy-dev.ps1

Deployment Behavior:

- Creates the stack if it does not exist
- Updates the stack if changes are detected
- Prints "No updates are to be performed" when already in sync

This indicates a successful deployment.

## Glue Job Updates

1. Modify:
   glue/sample_glue_job.py

2. Upload to S3:
   aws s3 cp glue/sample_glue_job.py s3://aws-data-engineering-ci-artifacts/aws-data-engineering-ci/artifacts/glue/sample_glue_job.py

CloudFormation deployment is NOT required unless Glue job configuration changes.

## Lambda Function Updates

1. Modify:
   lambda/sample_lambda.py

2. Package:
   zip sample_lambda.zip sample_lambda.py

3. Upload:
   aws s3 cp sample_lambda.zip s3://aws-data-engineering-ci-artifacts/aws-data-engineering-ci/artifacts/lambda/sample_lambda.zip

4. Deploy infrastructure:
   .\deploy\deploy-dev.ps1

## Validation

Deployment is successful when:

- CloudFormation stack status is CREATE_COMPLETE
- Glue job exists in AWS Glue console
- Lambda function exists in AWS Lambda console
- deploy-dev.ps1 executes without errors

## Design Principles

- Infrastructure as Code (CloudFormation)
- Deterministic, repeatable deployments
- No manual console-only deployment steps
- Clear separation of build and deploy responsibilities
- Minimal but stable CI/CD pipeline

## Future Enhancements

- Multi-environment stacks (dev / test / prod)
- Automated deployment via CodeBuild
- Full pipeline definition using AWS CDK
