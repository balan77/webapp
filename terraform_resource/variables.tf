variable "image_id" {
  description = "Amazon Image ID"
  type        = string
  default     = "ami-09d3b3274b6c5d4aa"
}

variable "no_of_instance" {
  type        = number
  description = "No of docker hosts to be deployed"
  default     = 1

}

variable "host_type" {
  type        = string
  description = "EC2 instance type to launch"
  default     = "t2.micro"
}

variable "instance_key" {
  description = "EC2 Key for login"
  type        = string

}
variable "instance_ecr_role" {
  type        = string
  description = "ECR role for docker image pull"
}

variable "instance_tag" {
  type = object({
    env   = string
    owner = string
  })
  description = "ec2 tags"
}
variable "ports_ingress" {
  type        = list(number)
  description = "ingress ports to be allowed"
}

variable "egress_ports" {
  type        = list(number)
  description = "egress ports to be allowed"
}

# variable "vpc_id" {}
# variable "network_cidr" {}
