module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = local.cluster_name
  cluster_version = "1.26"
  subnets         = module.vpc.private_subnets

  tags = {
    Environment = "training"
    GithubRepo  = "terraform-aws-eks"
    GithubOrg   = "terraform-aws-modules"
  }

  vpc_id = module.vpc.vpc_id

  workers_group_defaults = {
    root_volume_type = "gp2"
  }

  eks_managed_node_groups = {
    blue = {}
    green = {
      min_size     = 3
      max_size     = 5
      desired_size = 3

      instance_types = ["t2.micro"]
      cluster_additional_security_group_ids = [aws_security_group.worker_group_mgmt_one.id]
      capacity_type  = "SPOT"
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}
