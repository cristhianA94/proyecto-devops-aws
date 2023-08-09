# Creacion de cluster Kubernetes en EKS. 
# Se declara el nombre del cluster, la región y el nombre del pair-keys.pem generadas
eksctl create cluster \
--name eks-mundos-e-group-13 \
--region us-east-2 \
--with-oidc \
--ssh-access \
--ssh-public-key jenkins_ec2 \
--managed \
--full-ecr-access \
--zones us-east-2a,us-east-2b,us-east-2c

# Una vez creado se edita la configuracion para autorizar a nuestro usuario IAM
kubectl edit -n kube-system configmap/aws-auth

# Se copia el código ARN del usuario grupo-13 creado
# y se copia en la siguiente sección de mapRoles
  mapUsers: |
    - userarn: arn:aws:iam::265198653890:user/grupo-13
      username: grupo-13
      groups:
      - system:masters

# Se guarda y se sale con Nano mediante el comando :wq!