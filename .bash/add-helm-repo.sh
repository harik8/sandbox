#!/bin/bash

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update