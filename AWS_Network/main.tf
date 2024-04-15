terraform {
  required_providers {
    stackguardian = {
      source = "terraform/provider/stackguardian"
      version = "1.0.0"
    }
  }
}

provider "stackguardian" {}

resource "stackguardian_stack" "network_stack" {
  wfgroup = var.sg_workflow_group
  data = jsonencode(
{
    "ResourceName": "${var.workspace_id}_${var.project_id}_${var.description}",
    "TemplatesConfig": {
        "templateGroupId": "/rheinenergie/AWS_Network:4",
        "templates": [
            {
                "ResourceName": "aws-iam-ipam-role",
                "Description": "Role for accessing AWS IPAM",
                "Tags": [],
                "Approvers": [],
                "DeploymentPlatformConfig": [
                    {
                        "config": {
                            "profileName": "AWS",
                            "integrationId": "/integrations/AWS"
                        },
                        "kind": "AWS_RBAC"
                    }
                ],
                "WfType": "TERRAFORM",
                "EnvironmentVariables": [
                    {
                        "config": {
                            "textValue": "eu-central-1",
                            "varName": "AWS_DEFAULT_REGION"
                        },
                        "kind": "PLAIN_TEXT"
                    }
                ],
                "VCSConfig": {
                    "iacVCSConfig": {
                        "iacTemplate": "/rheinenergie/aws-iam-role",
                        "iacTemplateId": "/rheinenergie/aws-iam-role:2",
                        "useMarketplaceTemplate": true
                    },
                    "iacInputData": {
                        "schemaType": "RAW_JSON",
                        "data": {
                            "policies": [
                                "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
                            ],
                            "accountID": "708080821523"
                        }
                    }
                },
                "TerraformConfig": {
                    "terraformVersion": "1.3.6",
                    "approvalPreApply": false,
                    "managedTerraformState": true,
                    "driftCheck": false
                },
                "WfStepsConfig": [],
                "MiniSteps": {
                    "notifications": {
                        "email": {
                            "APPROVAL_REQUIRED": [],
                            "CANCELLED": [],
                            "COMPLETED": [],
                            "ERRORED": []
                        }
                    },
                    "wfChaining": {
                        "COMPLETED": [],
                        "ERRORED": []
                    }
                }
            },
            {
                "ResourceName": "aws-ipam-reservation",
                "Description": "IPAM reservation for new network",
                "Tags": [],
                "Approvers": [],
                "DeploymentPlatformConfig": [
                    {
                        "config": {
                            "profileName": "AWS",
                            "integrationId": "/integrations/AWS"
                        },
                        "kind": "AWS_RBAC"
                    }
                ],
                "WfType": "TERRAFORM",
                "EnvironmentVariables": [
                    {
                        "config": {
                            "textValue": "eu-central-1",
                            "varName": "AWS_DEFAULT_REGION"
                        },
                        "kind": "PLAIN_TEXT"
                    }
                ],
                "VCSConfig": {
                    "iacVCSConfig": {
                        "iacTemplateId": "/rheinenergie/aws-ipam-reservation:2",
                        "useMarketplaceTemplate": true
                    },
                    "iacInputData": {
                        "schemaType": "RAW_JSON",
                        "data": {
                            "external_id": "${reference::template-group.0.outputs.externalID.value}",
                            "shortDescription": "${var.description}",
                            "networkSize": var.size,
                            "role_arn": "${reference::template-group.0.outputs.roleARN.value}",
                            "platform": "AWS"
                        }
                    }
                },
                "TerraformConfig": {
                    "terraformVersion": "1.3.6",
                    "approvalPreApply": false,
                    "managedTerraformState": true,
                    "driftCheck": false
                },
                "WfStepsConfig": [],
                "MiniSteps": {
                    "notifications": {
                        "email": {
                            "APPROVAL_REQUIRED": [],
                            "CANCELLED": [],
                            "COMPLETED": [],
                            "ERRORED": []
                        }
                    },
                    "wfChaining": {
                        "COMPLETED": [],
                        "ERRORED": []
                    }
                },
                "GitHubComSync": {
                    "pull_request_opened": {
                        "createWfRun": {
                            "enabled": false
                        }
                    }
                }
            },
            {
                "ResourceName": "aws-iam-avx-role",
                "Description": "Role to deploy vpc and Aviatrix iam Role",
                "Tags": [],
                "Approvers": [],
                "DeploymentPlatformConfig": [
                    {
                        "config": {
                            "profileName": "AWS",
                            "integrationId": "/integrations/AWS"
                        },
                        "kind": "AWS_RBAC"
                    }
                ],
                "WfType": "TERRAFORM",
                "EnvironmentVariables": [
                    {
                        "config": {
                            "textValue": "eu-central-1",
                            "varName": "AWS_DEFAULT_REGION"
                        },
                        "kind": "PLAIN_TEXT"
                    }
                ],
                "VCSConfig": {
                    "iacVCSConfig": {
                        "iacTemplateId": "/rheinenergie/aws-iam-role:2",
                        "useMarketplaceTemplate": true
                    },
                    "iacInputData": {
                        "schemaType": "RAW_JSON",
                        "data": {
                            "policies": [
                                "arn:aws:iam::aws:policy/IAMFullAccess",
                                "arn:aws:iam::aws:policy/AmazonVPCFullAccess"
                            ],
                            "accountID": "${var.account}"
                        }
                    }
                },
                "TerraformConfig": {
                    "terraformVersion": "1.3.6",
                    "approvalPreApply": false,
                    "managedTerraformState": true,
                    "driftCheck": false
                },
                "WfStepsConfig": [],
                "MiniSteps": {
                    "notifications": {
                        "email": {
                            "APPROVAL_REQUIRED": [],
                            "CANCELLED": [],
                            "COMPLETED": [],
                            "ERRORED": []
                        }
                    },
                    "wfChaining": {
                        "COMPLETED": [],
                        "ERRORED": []
                    }
                },
                "GitHubComSync": {
                    "pull_request_opened": {
                        "createWfRun": {
                            "enabled": false
                        }
                    }
                }
            },
            {
                "ResourceName": "aws-network",
                "Description": "new aws network with Aviatrix Gateway",
                "Tags": [],
                "Approvers": [],
                "DeploymentPlatformConfig": [
                    {
                        "config": {
                            "profileName": "AWS",
                            "integrationId": "/integrations/AWS"
                        },
                        "kind": "AWS_RBAC"
                    }
                ],
                "WfType": "TERRAFORM",
                "EnvironmentVariables": [
                    {
                        "config": {
                            "textValue": "eu-central-1",
                            "varName": "AWS_DEFAULT_REGION"
                        },
                        "kind": "PLAIN_TEXT"
                    },
                    {
                        "config": {
                            "secretId": "/secrets/Aviatrix_Controller_IP",
                            "varName": "AVIATRIX_CONTROLLER_IP"
                        },
                        "kind": "VAULT_SECRET"
                    },
                    {
                        "config": {
                            "secretId": "/secrets/Aviatrix_Controller_Username",
                            "varName": "AVIATRIX_USERNAME"
                        },
                        "kind": "VAULT_SECRET"
                    },
                    {
                        "config": {
                            "secretId": "/secrets/Aviatrix_Controller_Password",
                            "varName": "AVIATRIX_PASSWORD"
                        },
                        "kind": "VAULT_SECRET"
                    }
                ],
                "VCSConfig": {
                    "iacVCSConfig": {
                        "iacTemplateId": "/rheinenergie/aws-network:7",
                        "useMarketplaceTemplate": true
                    },
                    "iacInputData": {
                        "schemaType": "RAW_JSON",
                        "data": {
                            "role_arn": "${reference::template-group.2.outputs.roleARN.value}",
                            "gwSize": "${var.gateway}",
                            "transit": "aws-transit-02",
                            "description": "${reference::template-group.1.outputs.description.value}",
                            "ha": "false",
                            "external_id": "${reference::template-group.2.outputs.externalID.value}",
                            "cidr_block": "${reference::template-group.1.outputs.cidr.value}",
                            "region": "eu-central-1",
                            "account": "${var.account}"
                        }
                    }
                },
                "TerraformConfig": {
                    "terraformVersion": "1.3.6",
                    "approvalPreApply": false,
                    "managedTerraformState": true,
                    "driftCheck": false
                },
                "WfStepsConfig": [],
                "MiniSteps": {
                    "notifications": {
                        "email": {
                            "APPROVAL_REQUIRED": [],
                            "CANCELLED": [],
                            "COMPLETED": [],
                            "ERRORED": []
                        }
                    },
                    "wfChaining": {
                        "COMPLETED": [],
                        "ERRORED": []
                    }
                },
                "GitHubComSync": {
                    "pull_request_opened": {
                        "createWfRun": {
                            "enabled": false
                        }
                    }
                }
            }
        ]
    }
} 
  )
}








/* resource "null_resource" "sg_integration" {
provisioner "local-exec" {
    command = <<EOF
curl -o sg-cli https://raw.githubusercontent.com/StackGuardian/sg-cli/main/sg-cli
chmod +x sg-cli

./sg-cli stack create --org ${var.sg_organization} --workflow-group ${var.sg_workflow_group} --run --output-json --wait --patch-payload '{"ResourceName": "${var.workspace_id}_${var.project_id}_${var.description}","TemplatesConfig": {"templates": [{"ResourceName": "aws-iam-ipam-role"},{"VCSConfig":{"iacInputData":{"data":{"shortDescription":"${var.description}","networkSize":${var.size}}}}},{"VCSConfig":{"iacInputData":{"data":{"accountID":"${var.account}"}}}},{"VCSConfig":{"iacInputData":{"data":{"gwSize":"${var.gateway}","account":"${var.account}"}}}}]}}' -- payload.json > output.txt

if grep -qi 'Stack name not unique' output.txt
then
  echo "Stack Name: ${var.workspace_id}_${var.project_id}_${var.description} already exists. Running APPLY on existing Stack"
  ./sg-cli stack apply --org ${var.sg_organization} --workflow-group ${var.sg_workflow_group} --stack-id ${var.workspace_id}_${var.project_id}_${var.description} --output-json --wait > output.txt
fi

cat output.txt
rm output.txt
EOF
  }
} */
