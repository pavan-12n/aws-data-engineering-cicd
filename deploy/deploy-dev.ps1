$STACK_NAME = "aws-de-dev-stack"
$TEMPLATE_URL = "https://aws-data-engineering-ci-artifacts.s3.ap-south-1.amazonaws.com/infra/cloudformation/glue-lambda-dev.yaml"
$ROLE_ARN = "arn:aws:iam::814724283102:role/cloudformation-deploy-role"

Write-Host "Updating stack $STACK_NAME..."

aws cloudformation update-stack `
  --stack-name $STACK_NAME `
  --template-url $TEMPLATE_URL `
  --capabilities CAPABILITY_NAMED_IAM `
  --role-arn $ROLE_ARN

if ($LASTEXITCODE -ne 0) {
    Write-Host "No updates or stack in stable state."
}

Write-Host "Deployment finished."
