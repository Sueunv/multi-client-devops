output "manager_public_ip" {
  value = aws_instance.manager.public_ip
}

output "worker_public_ip" {
  value = aws_instance.worker.public_ip
}
