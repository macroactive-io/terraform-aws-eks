module "user_data" {
  for_each = { for k, v in var.worker_groups_launch_template : k => v if can(v.ami_type) }

  source = "./modules/_user_data"

  create = true
  # platform = local.user_data_type # default: linux
  ami_type = "AL2023_x86_64_STANDARD" # hardcoded
  is_eks_managed_node_group = false

  cluster_name = local.cluster_name
  cluster_endpoint = local.cluster_endpoint
  cluster_auth_base64 = local.cluster_auth_base64
  # cluster_ip_family = var.cluster_ip_family # not used
  cluster_service_cidr = "10.100.0.0/16" # <- hardcoded
  # additional_cluster_dns_ips = var.additional_cluster_dns_ips # not used

  enable_bootstrap_user_data = try(each.value.enable_bootstrap_user_data, false)
  # pre_bootstrap_user_data = var.pre_bootstrap_user_data
  # post_bootstrap_user_data = var.post_bootstrap_user_data
  # bootstrap_extra_args = var.bootstrap_extra_args
  # user_data_template_path = var.user_data_template_path

  cloudinit_pre_nodeadm = try(each.value.cloudinit_pre_nodeadm, null)
  cloudinit_post_nodeadm = try(each.value.cloudinit_post_nodeadm, null)
}

