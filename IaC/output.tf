output "ELB" {
  value = aws_elb.my-elb.dns_name
}

output "bastion-host-ip" {
  value = aws_eip.bastion-host.public_ip
}