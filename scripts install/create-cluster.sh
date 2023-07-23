eksctl create cluster \
--name eks-mundos-e-13 \
--region us-east-2 \
--node-type t2.micro \
--with-oidc \
--ssh-access \
--ssh-public-key jenkins_ec2 \
--managed \
--full-ecr-access \
--zones us-east-2a,us-east-2b,us-east-2c