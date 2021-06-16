#!/bin/bash

kubectl port-forward deployment/nginx-internal 20000:20000 &  # argocd
kubectl port-forward deployment/nginx-internal 20001:20001 &  # consul
kubectl port-forward deployment/nginx-internal 20002:20002 &  # grafana
kubectl port-forward deployment/nginx-internal 20003:20003 &  # alertmanager
kubectl port-forward deployment/nginx-internal 20004:20004 &  # prometheus
kubectl port-forward svc/jaeger-query -n jaeger 20005:80 &    # jaeger

wait
