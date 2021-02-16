web-app-infra
=====

Kubernetes manifests of [web-app](https://github.com/oyas/web-app).

## Setup

### Create local cluster

```
bash cluster/local/setup.sh
```

After creating, you can access to http://localhost:8080/

#### Admin tools

```
bash cluster/local/port-forward.sh
```

- [Argo CD](localhost:20000)
- [Consul](localhost:20001)
- [Grafana](localhost:20002)
- [Alertmanager](localhost:20003)
- [Prometheus](localhost:20004)

