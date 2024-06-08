resource "tls_private_key" "ssh_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "ubuntu_key_pair" {
  key_name   = var.key_name
  public_key = tls_private_key.ssh_key.public_key_openssh
}


#Comment out the following code block when using the Windows version of the provisioner

resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${var.key_name}.pem"

  provisioner "local-exec" {
    command = "chmod 600 ${var.key_name}.pem"
  }
}

#Uncomment the following code block to use the Windows version of the provisioner

/*
resource "local_file" "private_key" {
  content  = tls_private_key.ssh_key.private_key_pem
  filename = "${var.key_name}.pem"

  provisioner "local-exec" {
    command = "powershell.exe -Command \"Set-ItemProperty -Path '${var.key_name}.pem' -Name IsReadOnly -Value $true\""
  }
}
*/