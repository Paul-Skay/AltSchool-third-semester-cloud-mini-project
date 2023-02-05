# Setup Keypair
resource "tls_private_key" "algo" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.ssh_key
  public_key = tls_private_key.algo.public_key_openssh
}

resource "local_file" "ssh_key" {
  filename        = "${var.ssh_key}.pem"
  content         = tls_private_key.algo.private_key_pem
  file_permission = "0400"
}

# Creating 3 EC2 Instances:
resource "aws_instance" "instance" {
  count           = length(aws_subnet.public_subnet.*.id)
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = element(aws_subnet.public_subnet.*.id, count.index)
  security_groups = [aws_security_group.ec2_sg.id, ]
  associate_public_ip_address = true
  key_name        = var.ssh_key

  tags = {
    "Name"        = "Instance-${count.index}"
    "Environment" = "Test"
    "CreatedBy"   = "Terraform"
  }

  timeouts {
    create = "10m"
  }

  provisioner "local-exec" {
    command = "echo '${self.public_ip}' >> ${var.filename}"
  }
}

resource "null_resource" "ansible-playbook" {
  provisioner "local-exec" {
    command = "ansible-playbook -i host-inventory --private-key ${var.ssh_key}.pem ./main.yml"
  }

  depends_on = [aws_instance.instance]
}