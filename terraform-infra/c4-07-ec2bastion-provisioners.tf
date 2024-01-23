resource "null_resource" "copy_ec2_keys" {
  depends_on = [module.ec2_public]

  # Connection Block for Provisioners to connect to EC2 Instance
  connection {
    type        = "ssh"
    host        = aws_eip.bastion_eip.public_ip
    user        = "ec2-user"
    private_key = file("InstanceForAMI.pem")
  }

  # provisioner "remote-exec" {
  #   inline = [
  #     "ls -l /tmp",
  #     "id"
  #   ]
  # }

  # File Provisioner: Only copy if the file doesn't exist
  provisioner "file" {
    source = "./InstanceForAMI.pem"
    destination = "/tmp/InstanceForAMI.pem"
  }
  # provisioner "remote-exec" {
  #   inline = [
  #     "test -e /tmp/InstanceForAMI.pem && echo 'File exists' || echo 'File does not exist'",
  #   ]
  # }

  # provisioner "remote-exec" {
  #   inline = [
  #     "test ! -e /tmp/InstanceForAMI.pem && cp 'InstanceForAMI.pem' /tmp/InstanceForAMI.pem",
  #   ]
  # }

  # Remote Exec Provisioner: Fix the private key permissions on the Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/InstanceForAMI.pem"
    ]
  }
}
