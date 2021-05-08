#!/bin/bash

#
# Setup
#   $ bash setup.sh # # Cleanup
#   $ bash setup.sh --cleanup
#

# set -eu

# Move to this script dir
cd `dirname $0`

# Check requirements
if !(type "gcloud" > /dev/null 2>&1); then
	echo gcloud is not found. Please install.
	echo https://cloud.google.com/sdk/docs/install
	exit 1
fi
if !(type "terraform" > /dev/null 2>&1); then
	echo terraform is not found. Please install.
	echo https://learn.hashicorp.com/tutorials/terraform/install-cli
	exit 1
fi

TERRAFORM="terraform -chdir=terraform"

# Cleanup
if [[ ${1-} == '--cleanup' ]]; then
	$TERRAFORM destroy
	exit
fi

# Terraform
$TERRAFORM apply

# ssh command
ZONE=`$TERRAFORM output -raw zone`
GATEWAY_INSTANCE_NAME=`$TERRAFORM output -raw gateway_instance_name`
PROJECT_ID=`$TERRAFORM output -raw project_id`
CLUSTER_NAME=`$TERRAFORM output -raw kubernetes_cluster_name`
SSH_GATEWAY="gcloud beta compute ssh --zone $ZONE $GATEWAY_INSTANCE_NAME --project $PROJECT_ID"

function waitfor(){
	name=$1
	namespace=$2

	echo "Waiting to $name ready..."
	$SSH_GATEWAY -- kubectl get pods -l app.kubernetes.io/name=$name -n $namespace 2>/dev/null | sed -n '1p'
	for i in {1..600}; do
		output=`$SSH_GATEWAY -- kubectl get pods -l app.kubernetes.io/name=$name -n $namespace 2>/dev/null`
		stat=`echo "$output" | sed -n '2p' | tr -d '\n'`
		echo -en "\r$stat"
		if [[ $stat == *Running* ]]; then
			echo ''
			break
		fi
		sleep 1
	done
}

# set up gateway-instance
$SSH_GATEWAY -- sudo apt-get update
$SSH_GATEWAY -- sudo apt-get install kubectl
$SSH_GATEWAY -- gcloud container clusters get-credentials $CLUSTER_NAME --zone $ZONE --project $PROJECT_ID

# Install Argo CD
$SSH_GATEWAY -- kubectl create namespace argocd
$SSH_GATEWAY -- kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Set admin password as 'admin'
# $SSH_GATEWAY -- kubectl -n argocd patch secret argocd-secret \
# 	-p "{\"stringData\": {
# 		\"admin.password\": \"\$2a\$10\$HvC0G7RMxR0PhEtZ9pFWseChNQH9EQcOByn2hFtuhdAlK0tvS4gD2\",
# 		\"admin.passwordMtime\": \"$(date +%FT%T%Z)\"
# 	}}"

# Wait argocd-server ready
waitfor argocd-server argocd

# Add Argo CD root application
$SSH_GATEWAY -- kubectl apply -n argocd -f https://raw.githubusercontent.com/oyas/web-app-infra/main/cluster/staging-gke/application.yaml

ARGOCD_PASSWORD=`$SSH_GATEWAY -- kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d`

echo ""
echo "Ready to use Argo CD!"
echo "Please open http://localhost:20000/"
echo "id=admin password=$ARGOCD_PASSWORD"
echo "Note: 'port-forward.sh' is not available before all services ready."
echo ""
echo "=== Ctrl-C to finish port-forwarding"
echo ""

$SSH_GATEWAY -- -L 20000:localhost:20000 kubectl port-forward svc/argocd-server -n argocd 20000:443

