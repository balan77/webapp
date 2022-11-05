resource "aws_instance" "docker_host" {
  count = var.no_of_instance
  #id = "docker_host"
  ami                  = var.image_id
  instance_type        = var.host_type
  user_data            = file("scripts/host_prep.sh")
  key_name             = var.instance_key
  iam_instance_profile = var.instance_ecr_role
  tags                 = var.instance_tag
  security_groups      = [aws_security_group.allow_ssh_http.name]
  # root_block_device {
  #   volume_size           = 20
  #   volume_type           = "gp2"
  #   delete_on_termination = true
  # }
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Allow ssh and htp inbound traffic"
  vpc_id      = "vpc-0b4b2f4dfb66edb33"

  dynamic "ingress" {
    for_each = var.ports_ingress
    iterator = port
    content {
      description = "inbound rules"
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
      #ipv6_cidr_blocks = [aws_vpc.main.ipv6_cidr_block]
    }
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    #ipv6_cidr_blocks = ["::/0"]
  }

  tags = {
    Name = "allow ssh and http"
  }
}

resource "time_sleep" "wait_for_ec2_reboot_60s" {
  depends_on      = [aws_instance.docker_host]
  create_duration = "60s"

}

resource "null_resource" "pull_image" {
  depends_on = [time_sleep.wait_for_ec2_reboot_60s]
  count      = var.no_of_instance
  connection {
    type        = "ssh"
    host        = aws_instance.docker_host[count.index].public_ip
    user        = "ec2-user"
    password    = ""
    private_key = file("keypair/kp_lab.pem")
  }

  provisioner "remote-exec" {
    inline = [
      "docker container rm $(docker ps -q) -f",
      "docker image rm $(docker image ls -q)",
      "aws ecr get-login-password --region us-east-2 | docker login --username AWS --password-stdin 711471052521.dkr.ecr.us-east-2.amazonaws.com",
      "docker pull 711471052521.dkr.ecr.us-east-2.amazonaws.com/homelab:latest",
      "docker run -itd --name my-web -p 80:80 $(docker image ls -q)"
    ]
  }
}

/* Load balancer */
resource "aws_lb" "prod_lb" {
  depends_on = [
    aws_instance.docker_host
  ]
  name               = "prodlb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.allow_ssh_http.id]
  subnets            = ["subnet-0f28d65266c9a8346", "subnet-04d0f37873ffa8394", "subnet-09714f6f5f4dcbc79"]

  tags = {
    Environment = "production"
  }
}

resource "aws_lb_listener" "webapp_front_end" {
  load_balancer_arn = aws_lb.prod_lb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.wepapp_tg.arn
  }
}

resource "aws_lb_target_group" "wepapp_tg" {
  name        = "wepapptg"
  port        = 80
  protocol    = "HTTP"
  target_type = "instance"
  vpc_id      = "vpc-0b4b2f4dfb66edb33"
  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 10
    matcher            = 200
    path                = "/"
    unhealthy_threshold = 3
  }
}

resource "aws_lb_target_group_attachment" "webapp_target_attach" {
  count            = var.no_of_instance
  target_group_arn = aws_lb_target_group.wepapp_tg.arn
  target_id        = aws_instance.docker_host[count.index].id
  port             = 80
}