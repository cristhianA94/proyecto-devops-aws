# Agregar repo de grafana
helm repo add grafana https://grafana.github.io/helm-charts

# Crear carpetas y archivo grafana.yaml
mkdir -p environment/grafana && echo "datasources:
  datasources.yaml:
    apiVersion: 1
    datasources:
    - name: Prometheus
      type: prometheus
      url: http://prometheus-server.prometheus.svc.cluster.local
      access: proxy
      isDefault: true" > environment/grafana/grafana.yaml

# Namespace para grafana
kubectl create namespace grafana

# Instala Grafana con la clave EKS!sAWSome
helm install grafana grafana/grafana \
    --namespace grafana \
    --set persistence.storageClassName="gp2" \
    --set persistence.enabled=true \
    --set adminPassword='EKS!sAWSome' \
    --values ${HOME}/environment/grafana/grafana.yaml \
    --set service.type=LoadBalancer

# Extrae la clave de grafana en base 64
kubectl get secret --namespace grafana grafana -o jsonpath="{.data.admin-password}" | base64 --decode ; echo

# Expone el hostname de grafana
export ELB=$(kubectl get svc -n grafana grafana -o jsonpath='{.status.loadBalancer.ingress[0].hostname}')
echo "http://$ELB"