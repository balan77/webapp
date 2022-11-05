image_id          = "ami-089a545a9ed9893b6"
no_of_instance    = 2
host_type         = "t2.micro"
instance_key      = "kp-lab"
instance_ecr_role = "role_ecradmin"
instance_tag = {
  env   = "prod"
  owner = "balan@mycompany.com"
}
ports_ingress = [22, 80, 0]
egress_ports  = []