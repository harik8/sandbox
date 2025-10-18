helm repo update

# Install the GH runner manually at the destination Kubernetes cluster
export RUNNER_TOKEN=A**********************
helm upgrade --install --atomic \
	--create-namespace \
	--namespace gha-runner \
	gha-runner .helm-tmpl \
	--set image.tag=main-86127 -f gha-runner/.helm/values.yaml -f gha-runner/.helm/sandbox/values.yaml \
	--set env[0].name=REPO_URL \
	--set env[0].value=https://github.com/harik8/sandbox \
	--set env[1].name=RUNNER_TOKEN \
	--set env[1].value=$RUNNER_TOKEN

helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx --create-namespace \
  --set controller.kind=Deployment \
  --set controller.hostNetwork=true \
  --set controller.hostPort.enabled=true \
  --set controller.hostPort.http=80 \
  --set controller.hostPort.https=443 \
  --set controller.service.type="" \
  --set controller.admissionWebhooks.enabled=true \
  --set controller.replicaCount=1 \
  --set controller.config.allowSnippetAnnotations=true \
  --set controller.config.annotations-risk-level=Critical \
  --set controller.ingressClassResource.name=public \
  --set controller.config.log-format-upstream='remote_addr: $remote_addr host: $host remote_user: $remote_user time_local: [$time_local] request: $request status: $status body_bytes_sent: $body_bytes_sent http_referer: $http_referer http_user_agent: $http_user_agent request_length: $request_length request_time: $request_time proxy_upstream_name: [$proxy_upstream_name] proxy_alternative_upstream_name: [$proxy_alternative_upstream_name] upstream_addr: $upstream_addr upstream_response_length: $upstream_response_length upstream_response_time: $upstream_response_time upstream_status: $upstream_status req_id: $req_id canary: $http_canary'

# Bitnami Postgresql and Kafka are deprecated. Needs to be replaced in future.
helm repo add bitnami https://charts.bitnami.com/bitnami  
helm upgrade --install postgres \
  --namespace postgres \
  --create-namespace \
  oci://registry-1.docker.io/bitnamicharts/postgresql \
  --set primary.resources.requests.cpu=50m \
  --set primary.resources.requests.memory=256Mi \
  --set primary.resources.limits.memory=512Mi
  
helm upgrade --install add-postgresql \
	--namespace add-postgresql \
	--create-namespace \
	bitnami/postgresql --version 16.7.4

helm upgrade --install kafka bitnami/kafka \
  --namespace kafka \
  --create-namespace \
  --set kraft.enabled=true \
  --set replicaCount=1 \
  --set controller.replicaCount=1 \
  --set listeners.client.protocol=PLAINTEXT \
  --set listeners.controller.protocol=PLAINTEXT \
  --set storage.size=10Gi
  --set resources.requests.cpu=50m \
  --set resources.requests.memory=64Mi \
  --set resources.limits.memory=256Mi

helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm upgrade --install --atomic \
	--create-namespace \
	--namespace prometheus \
	--set prometheus-node-exporter.hostRootFsMount.enabled=false \
	prometheus prometheus-community/prometheus
	
helm repo add grafana https://grafana.github.io/helm-charts
helm upgrade --install --atomic \
	--create-namespace \
	--namespace grafana \
	--set persistence.type=pvc \
	--set persistence.enabled=false \
	grafana grafana/grafana
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo
	
helm repo add metrics-server https://kubernetes-sigs.github.io/metrics-server/
helm upgrade --install --atomic \
	--create-namespace \
	--namespace metrics-server \
	metrics-server metrics-server/metrics-server

helm repo add argo https://argoproj.github.io/argo-helm
helm install argo-rollouts argo/argo-rollouts   --namespace argo-rollouts --create-namespace   --set dashboard.enabled=true
