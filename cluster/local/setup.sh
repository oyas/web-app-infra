#!/bin/bash

#
# Setup
#   $ bash setup.sh
#
# Cleanup
#   $ bash setup.sh --cleanup
#

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

# Add Argo CD application
kubectl apply -n argocd -f ./application.yaml

