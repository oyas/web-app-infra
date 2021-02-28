#!/bin/bash

#
# Setup
#   $ bash setup.sh
#
# Cleanup
#   $ bash setup.sh --cleanup
#

function waitfor(){
	name=$1
	namespace=$2

	echo "Waiting to $name ready..."
	kubectl get pods -l app.kubernetes.io/name=$name -n $namespace 2>/dev/null | sed -n '1p'
	for i in {1..600}; do
		stat=`kubectl get pods -l app.kubernetes.io/name=$name -n $namespace 2>/dev/null | sed -n '2p' | tr -d '\n'`
		echo -en "\r$stat"
		if [[ $stat == *Running* ]]; then
			echo ''
			break
		fi
		sleep 1
	done
}

# Move to this script dir
cd `dirname $0`

# Check requirements
if !(type "kind" > /dev/null 2>&1); then
	echo kind is not found. Please install.
	echo https://github.com/kubernetes-sigs/kind
	exit 1
fi
if !(type "kubectl" > /dev/null 2>&1); then
	echo kubectl is not found. Please install.
	echo https://kubernetes.io/docs/tasks/tools/install-kubectl/
	exit 1
fi

# Cleanup
if [[ $1 == '--cleanup' ]]; then
	kind delete cluster --name web-app
	exit
fi

# Create cluster
kind create cluster --name web-app --config kind-config.yaml

# Install Argo CD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Set admin password as 'admin'
kubectl -n argocd patch secret argocd-secret \
	-p '{"stringData": {
		"admin.password": "$2a$10$HvC0G7RMxR0PhEtZ9pFWseChNQH9EQcOByn2hFtuhdAlK0tvS4gD2",
		"admin.passwordMtime": "'$(date +%FT%T%Z)'"
	}}'

# Wait argocd-server ready
waitfor argocd-server argocd

# Add Argo CD root application
kubectl apply -n argocd -f ./application.yaml

echo ""
echo "Ready to use Argo CD! Please run following command."
echo ""
echo "  $ kubectl port-forward svc/argocd-server -n argocd 20000:443"
echo ""
echo "Then, you can use Argo CD at http://localhost:20000/"
echo "Note: 'port-forward.sh' is not available before all services ready."

