Setup local kubernetes cluster

## Requirements

- [kind](https://github.com/kubernetes-sigs/kind)
- [kubectl](https://kubernetes.io/docs/tasks/tools/install-kubectl/)

## Setup

```
bash setup.sh
```

## Cleanup

```
bash setup.sh --cleanup
```

## How to access to ArgoCD web ui

```
kubectl port-forward svc/argocd-server -n argocd 28080:443
```

access to https://localhost:28080/

https://argoproj.github.io/argo-cd/getting_started/

## How to access to Consul web ui

```
kubectl port-forward -n consul service/consul-server 8500:8500
```

access to https://localhost:8500/

