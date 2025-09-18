# Setup Instructions
## Prerequesites:
Before deploying the LLM you need to have:
- Gcloud SDK installed and configured (with kubectl support)
- Terraform installed and configured
- Service Account json key with admin permissions from the project GCP project where you want to deploy
- Skypilot installed properly with Kubernetes

## Setup
### Terraform
There are 2 terraform stages:
- Preset: creates a GCS bucket that is used for the terraform backend in the subsequent stage 
- Stage1: Create the GKE cluster with 2xA100 GPUs, custom VPC network and subnet, a service account for skypilot
  
Starting with the Preset, after creating the `terraform.tfvars` and filling it properly with the values of the variables that are specified in the `variables.tf` file, you can `cd` to each stage separately and execute the following commands in order to provision the infrastructure:
```
terraform init
terraform apply
```
As you go through theses commands make sure to tnable if necessary the services in GCP that need to be enabled in order for terraform to function properly on GCP

### Skypilot
Once the Google Kubernetes Cluster created by the `terraform apply` command in the stage1.

Run the following command (after replacing `<CLUSTER-NAME>` and `<CLUSTER-ZONE>` with their adequate values) to connect your Skypilot with the Google Kubernetes Engine:
```
gcloud container clusters get-credentials <CLUSTER-NAME> --zone <CLUSTER-ZONE>
```
You can verify that your installations are working by running:
```
sky show-gpus --infra k8s
```

## Execution
In order to start your llama4 pod on Kubernetes using 1xA100 GPU use the following command:
```
HF_TOKEN=<YOUR-HUGGING-FACE-TOKEN> sky launch -c sglang --env HF_TOKEN llama4.yaml --infra kubernetes
```
You can check if your deployment was successfull using the following command:
```
sky status --endpoint 30000 sglang
```
