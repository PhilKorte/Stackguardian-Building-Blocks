resource "null_resource" "sg_integration" {
  provisioner "local-exec" {
    command = <<EOF
curl -o sg-cli https://raw.githubusercontent.com/StackGuardian/sg-cli/main/sg-cli
chmod +x sg-cli

./sg-cli stack create --org ${var.sg_organization} --workflow-group ${var.sg_workflow_group} --run --output-json --wait --patch-payload '{"ResourceName": "${var.workspace_id}_${var.project_id}_${var.description}","TemplatesConfig": {"templates": [{"ResourceName": "aws-iam-ipam-role"},{"VCSConfig":{"iacInputData":{"data":{"shortDescription":"${var.description}","networkSize":${var.size}}}}},{"EnvironmentVariables":[{"config": {"secretId": "/secrets/Azure_Client_ID","varName": "ARM_CLIENT_ID"},"kind": "VAULT_SECRET"},{"config": {"secretId": "/secrets/Azure_Client_Secret","varName": "ARM_CLIENT_SECRET"},"kind": "VAULT_SECRET"},{"config": {"secretId": "/secrets/Azure_Tenant_ID","varName": "ARM_TENANT_ID"},"kind": "VAULT_SECRET" },{"config": {"textValue": "${var.account}","varName": "ARM_SUBSCRIPTION_ID"},"kind": "PLAIN_TEXT"},{"config": {"secretId": "/secrets/Aviatrix_Controller_IP","varName": "AVIATRIX_CONTROLLER_IP"},"kind": "VAULT_SECRET"},{"config": {"secretId": "/secrets/Aviatrix_Controller_Username","varName": "AVIATRIX_USERNAME"}, "kind": "VAULT_SECRET"},{"config": {"secretId": "/secrets/Aviatrix_Controller_Password","varName": "AVIATRIX_PASSWORD" },"kind": "VAULT_SECRET"}],"VCSConfig":{"iacInputData":{"data":{"gwSize":"${var.gateway}","subscriptionID":"${var.account}"}}}}]}}' -- payload.json > output.txt

if grep -qi 'Stack name not unique' output.txt
then
  echo "Stack Name: ${var.workspace_id}_${var.project_id}_${var.description} already exists. Running APPLY on existing Stack"
  ./sg-cli stack apply --org ${var.sg_organization} --workflow-group ${var.sg_workflow_group} --stack-id ${var.workspace_id}_${var.project_id}_${var.description} --output-json --wait > output.txt
fi

cat output.txt
rm output.txt
EOF
  }
}
