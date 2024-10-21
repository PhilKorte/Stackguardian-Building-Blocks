terraform {
  required_providers {
    stackguardian = {
      source  = "StackGuardian/stackguardian"
      version = "0.2.0-beta2"
    }
  }
}

provider "stackguardian" {}

resource "stackguardian_stack" "network" {
  wfgrp = var.sg_workflow_group
  data = jsonencode(
    {
      "ResourceName" : "${var.workspace_id}_${var.project_id}_${var.description}",
      "TemplatesConfig" : {
        "templateGroupId" : "/rheinenergie/Azure_Networks:3",
        "templates" : [
          {
            "ResourceName" : "aws-iam-ipam-role",
            "id" : 0,
            "Description" : "Role for accessing AWS IPAM",
            "Tags" : [],
            "Approvers" : [],
            "DeploymentPlatformConfig" : [
              {
                "config" : {
                  "profileName" : "AWS",
                  "integrationId" : "/integrations/AWS"
                },
                "kind" : "AWS_RBAC"
              }
            ],
            "WfType" : "TERRAFORM",
            "EnvironmentVariables" : [
              {
                "config" : {
                  "textValue" : "eu-central-1",
                  "varName" : "AWS_DEFAULT_REGION"
                },
                "kind" : "PLAIN_TEXT"
              }
            ],
            "VCSConfig" : {
              "iacVCSConfig" : {
                "iacTemplate" : "/rheinenergie/aws-iam-role",
                "iacTemplateId" : "/rheinenergie/aws-iam-role:2",
                "useMarketplaceTemplate" : true
              },
              "iacInputData" : {
                "schemaType" : "RAW_JSON",
                "data" : {
                  "policies" : [
                    "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
                  ],
                  "accountID" : "708080821523"
                }
              }
            },
            "TerraformConfig" : {
              "terraformVersion" : "1.5.7",
              "approvalPreApply" : false,
              "managedTerraformState" : true,
              "driftCheck" : false
            },
            "WfStepsConfig" : [],
            "MiniSteps" : {
              "notifications" : {
                "email" : {
                  "APPROVAL_REQUIRED" : [],
                  "CANCELLED" : [],
                  "COMPLETED" : [],
                  "ERRORED" : []
                }
              },
              "wfChaining" : {
                "COMPLETED" : [],
                "ERRORED" : []
              }
            }
          },
          {
            "ResourceName" : "aws-ipam-reservation",
            "id" : 1,
            "Description" : "IPAM reservation for new network",
            "Tags" : [],
            "Approvers" : [],
            "DeploymentPlatformConfig" : [
              {
                "config" : {
                  "profileName" : "AWS",
                  "integrationId" : "/integrations/AWS"
                },
                "kind" : "AWS_RBAC"
              }
            ],
            "WfType" : "TERRAFORM",
            "EnvironmentVariables" : [
              {
                "config" : {
                  "textValue" : "eu-central-1",
                  "varName" : "AWS_DEFAULT_REGION"
                },
                "kind" : "PLAIN_TEXT"
              }
            ],
            "VCSConfig" : {
              "iacVCSConfig" : {
                "iacTemplateId" : "/rheinenergie/aws-ipam-reservation:2",
                "useMarketplaceTemplate" : true
              },
              "iacInputData" : {
                "schemaType" : "RAW_JSON",
                "data" : {
                  "external_id" : "$${reference::template-group.0.outputs.externalID.value}",
                  "shortDescription" : var.description,
                  "networkSize" : var.size,
                  "role_arn" : "$${reference::template-group.0.outputs.roleARN.value}",
                  "platform" : "AZ"
                }
              }
            },
            "TerraformConfig" : {
              "terraformVersion" : "1.5.7",
              "approvalPreApply" : false,
              "managedTerraformState" : true,
              "driftCheck" : false
            },
            "WfStepsConfig" : [],
            "MiniSteps" : {
              "notifications" : {
                "email" : {
                  "APPROVAL_REQUIRED" : [],
                  "CANCELLED" : [],
                  "COMPLETED" : [],
                  "ERRORED" : []
                }
              },
              "wfChaining" : {
                "COMPLETED" : [],
                "ERRORED" : []
              }
            },
            "GitHubComSync" : {
              "pull_request_opened" : {
                "createWfRun" : {
                  "enabled" : false
                }
              }
            }
          },
          {
            "ResourceName" : "azure-networks",
            "id" : 2,
            "Description" : "new azure network with Aviatrix Gateway",
            "Tags" : [],
            "Approvers" : [],
            "DeploymentPlatformConfig" : [],
            "WfType" : "TERRAFORM",
            "EnvironmentVariables" : [
              {
                "config" : {
                  "secretId" : "/secrets/Azure_Client_ID",
                  "varName" : "ARM_CLIENT_ID"
                },
                "kind" : "VAULT_SECRET"
              },
              {
                "config" : {
                  "secretId" : "/secrets/Azure_Client_Secret",
                  "varName" : "ARM_CLIENT_SECRET"
                },
                "kind" : "VAULT_SECRET"
              },
              {
                "config" : {
                  "secretId" : "/secrets/Azure_Tenant_ID",
                  "varName" : "ARM_TENANT_ID"
                },
                "kind" : "VAULT_SECRET"
              },
              {
                "config" : {
                  "textValue" : var.account,
                  "varName" : "ARM_SUBSCRIPTION_ID"
                },
                "kind" : "PLAIN_TEXT"
              },
              {
                "config" : {
                  "secretId" : "/secrets/Aviatrix_Controller_IP",
                  "varName" : "AVIATRIX_CONTROLLER_IP"
                },
                "kind" : "VAULT_SECRET"
              },
              {
                "config" : {
                  "secretId" : "/secrets/Aviatrix_Controller_Username",
                  "varName" : "AVIATRIX_USERNAME"
                },
                "kind" : "VAULT_SECRET"
              },
              {
                "config" : {
                  "secretId" : "/secrets/Aviatrix_Controller_Password",
                  "varName" : "AVIATRIX_PASSWORD"
                },
                "kind" : "VAULT_SECRET"
              },
              {
                "config" : {
                  "textValue" : "true",
                  "varName" : "ARM_SKIP_PROVIDER_REGISTRATION"
                },
                "kind" : "PLAIN_TEXT"
              }
            ],
            "VCSConfig" : {
              "iacVCSConfig" : {
                "iacTemplateId" : "/rheinenergie/azure-networks:10",
                "useMarketplaceTemplate" : true
              },
              "iacInputData" : {
                "schemaType" : "RAW_JSON",
                "data" : {
                  "clientID" : "$${secret::Azure_Client_ID}",
                  "gwSize" : var.gateway,
                  "description" : "$${reference::template-group.1.outputs.description.value}",
                  "cidr_block" : "$${reference::template-group.1.outputs.cidr.value}",
                  "directoryID" : "$${secret::Azure_Tenant_ID}",
                  "secret" : "$${secret::Azure_Client_Secret}",
                  "subscriptionID" : var.account
                }
              }
            },
            "TerraformConfig" : {
              "terraformVersion" : "1.5.7",
              "approvalPreApply" : false,
              "managedTerraformState" : true,
              "driftCheck" : false
            },
            "WfStepsConfig" : [],
            "MiniSteps" : {
              "notifications" : {
                "email" : {
                  "APPROVAL_REQUIRED" : [],
                  "CANCELLED" : [],
                  "COMPLETED" : [],
                  "ERRORED" : []
                }
              },
              "wfChaining" : {
                "COMPLETED" : [],
                "ERRORED" : []
              }
            },
            "GitHubComSync" : {
              "pull_request_opened" : {
                "createWfRun" : {
                  "enabled" : false
                }
              }
            }
          }
        ]
      }
    }
  )
}

resource "null_resource" "sg_integration" {
  triggers = {
    sg_organization   = var.sg_organization
    sg_workflow_group = var.sg_workflow_group
    workspace_id      = var.workspace_id
    project_id        = var.project_id
    description       = var.description
  }

  provisioner "local-exec" {
    when    = create
    command = <<EOF
curl -o sg-cli https://raw.githubusercontent.com/StackGuardian/sg-cli/main/sg-cli
chmod +x sg-cli

./sg-cli stack apply --org ${self.triggers.sg_organization} --workflow-group ${self.triggers.sg_workflow_group} --stack-id ${self.triggers.workspace_id}_${self.triggers.project_id}_${self.triggers.description} --output-json --wait > output.txt

cat output.txt
rm output.txt
EOF
  }

  provisioner "local-exec" {
    when    = destroy
    command = <<EOF
curl -o sg-cli https://raw.githubusercontent.com/StackGuardian/sg-cli/main/sg-cli
chmod +x sg-cli

./sg-cli stack destroy --org ${self.triggers.sg_organization} --workflow-group ${self.triggers.sg_workflow_group} --stack-id ${self.triggers.workspace_id}_${self.triggers.project_id}_${self.triggers.description} --output-json --wait > output.txt

cat output.txt
rm output.txt
EOF
  }
  
  depends_on = [stackguardian_stack.network]
}
