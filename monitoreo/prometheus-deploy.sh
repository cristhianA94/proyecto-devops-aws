# Agregar repo de prometheus
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts

# Crear namespace para pods de Prometheus
kubectl create namespace prometheus

# Instalar Prometheus con helm
helm upgrade -i prometheus prometheus-community/prometheus \
    --namespace prometheus \
    --set alertmanager.persistentVolume.storageClass="gp2",server.persistentVolume.storageClass="gp2"

#Add IAM Role usando eksctl
eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster eks-mundos-e-group-13 \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve

# A continuación, añada EBS CSI a eks ejecutando el siguiente comando
eksctl create addon --name aws-ebs-csi-driver --cluster eks-mundos-e-group-13 --service-account-role-arn arn:aws:iam::265198653890:role/AmazonEKS_EBS_CSI_DriverRole --force
# Conectarse al pod
kubectl port-forward -n prometheus pod/prometheus-server-8486b7c658-85jw9 8080:9090 --address 0.0.0.0