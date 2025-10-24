#!/bin/bash

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo add grafana https://grafana.github.io/helm-charts
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm repo add argo https://argoproj.github.io/argo-helm
helm repo update

cd ../charts

echo "Installing alloy..."
helm upgrade --install --atomic --create-namespace --namespace alloy --version 1.3.1 --values alloy/values.yaml alloy grafana/alloy

echo "Installing argo-rollouts..."
helm upgrade --install --atomic --create-namespace --namespace argo-rollouts --version 2.39.6 --values argo-rollouts/values.yaml  argo-rollouts argo/argo-rollouts

echo "Installing grafana..."
helm upgrade --install --atomic --create-namespace --namespace grafana --version 10.1.2 --values grafana/values.yaml grafana grafana/grafana

echo "Installing ingress-nginx..."
helm upgrade --install --atomic --create-namespace --namespace ingress-nginx --version 4.13.2 --values ingress-nginx/values.yaml ingress-nginx ingress-nginx/ingress-nginx

echo "Installing kafka..."
helm upgrade --install --atomic --create-namespace --namespace kafka --version 32.2.8 --values kafka/values.yaml kafka bitnami/kafka

echo "Installing loki..."
helm upgrade --install --atomic --create-namespace --namespace loki --version 6.43.0 --values loki/values.yaml loki grafana/loki

echo "Installing metrics-server..."
helm upgrade --install --atomic --create-namespace --namespace metrics-server --version 3.12.2 --values metrics-server/values.yaml metrics-server metrics-server/metrics-server

echo "Installing postgres..."
helm upgrade --install --atomic --create-namespace --namespace postgres --version 16.7.4 --values postgres/values.yaml postgres oci://registry-1.docker.io/bitnamicharts/postgresql

echo "Installing prometheus..."
helm upgrade --install --atomic --create-namespace --namespace prometheus --version 27.41.1 --values prometheus/values.yaml prometheus prometheus-community/prometheus

if [ $RUNNER_TOKEN ]; then
  cd ..
  echo "Installing gha-runner..."
  helm upgrade --install --atomic \
    --create-namespace \
    --namespace gha-runner \
	  --set image.tag=main-86127 \
	  --set env[1].value=$RUNNER_TOKEN \
    -f gha-runner/.helm/values.yaml -f gha-runner/.helm/sandbox/values.yaml \
    gha-runner .helm-tmpl
fi