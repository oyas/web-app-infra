Setup cluster on google kubernetes engine

## Requirements

- [gcloud](https://cloud.google.com/sdk/docs/install)
- [terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)


## Setup

```
bash setup.sh
```

## Cleanup

```
bash setup.sh --cleanup
```

## Memo

### Register Static IP

Requires a static IP named `web-app-staging-ip`.
https://cloud.google.com/kubernetes-engine/docs/tutorials/configuring-domain-name-static-ip

### Firewall rule

Requires to allow 8080 port from master node to worker node.
https://github.com/hashicorp/consul-k8s/issues/270

