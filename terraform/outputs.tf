output "external_ip_address_app_1" {
  value = yandex_compute_instance.app[0].network_interface[0].nat_ip_address
}
output "external_ip_address_lb" {
  value = yandex_compute_instance.lb-server.network_interface[0].nat_ip_address
}
