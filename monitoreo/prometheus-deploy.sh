# Instalar Prometheus y Grafana usnado Helm (Manejador de paquetes para kubernetes)

# Agregar repo de prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Agregar repo de grafana
helm repo add grafana https://grafana.github.io/helm-charts

# Descargar repositorio oficial Prometheus
git clone https://github.com/prometheus-operator/kube-prometheus.git
cd kube-prometheus

# Instala Prometheus
kubectl apply --server-side -f manifests/setup
kubectl wait \
	--for condition=Established \
	--all CustomResourceDefinition \
	--namespace=monitoring
kubectl apply -f manifests/

# Crear namespace de monitorización
kubectl get ns monitoring
kubectl create -f manifests/
kubectl get pods -n monitoring -w

kubectl port-forward -n monitoring svc/grafana 3000

# Desplegar prometheus en EKS
helm install prometheus prometheus-community/prometheus \
--namespace monitoring \
--set alertmanager.persistentVolume.storageClass="gp2" \
--set server.persistentVolume.storageClass="gp2"

# Verificar la instalación
kubectl get all -n monitoring

# Exponer prometheus en la instancia de EC2 en el puerto 8080
kubectl port-forward -n monitoring deploy/prometheus-server 8080:9090 --address 0.0.0.0