resource "null_resource" "sg_integration" {
provisioner "local-exec" {
    command = <<EOF
curl -o sg-cli https://raw.githubusercontent.com/StackGuardian/sg-cli/main/shell/sg-cli
chmod +x sg-cli

./sg-cli stack create --org ${var.sg_organization} --workflow-group ${var.sg_workflow_group} --run --output-json --wait --patch-payload '{"ResourceName": "${var.workspace_id}_${var.project_id}_${var.description}","TemplatesConfig": {"templates": [{"ResourceName": "aws-iam-ipam-role"},{"VCSConfig":{"iacInputData":{"data":{"shortDescription":"${var.description}","networkSize":${var.size}}}}},{"EnvironmentVariables":[{"config": {"textValue": "${var.account}","varName": "GOOGLE_PROJECT"},"kind": "PLAIN_TEXT"},{"config": {"textValue": "${var.region}","varName": "GOOGLE_REGION"},"kind": "PLAIN_TEXT"},{"config": {"secretId": "/secrets/Aviatrix_Controller_IP","varName": "AVIATRIX_CONTROLLER_IP"},"kind": "VAULT_SECRET"},{"config": {"secretId": "/secrets/Aviatrix_Controller_Username","varName": "AVIATRIX_USERNAME"}, "kind": "VAULT_SECRET"},{"config": {"secretId": "/secrets/Aviatrix_Controller_Password","varName": "AVIATRIX_PASSWORD" },"kind": "VAULT_SECRET"}],"VCSConfig":{"iacInputData":{"data":{"gwSize":"${var.gateway}","account":"${var.account}"}}}}]}}' -- payload.json > output.txt

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
