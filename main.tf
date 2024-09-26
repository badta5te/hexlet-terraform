terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.129.0"
    }
  }
  required_version = ">= 0.129"
}

variable "yc_token" {}

provider "yandex" {
  zone  = "ru-central1-a"
  token = var.yc_token
}

resource "yandex_compute_instance" "default" {
  name        = "test"
  platform_id = "standard-v1"
  zone        = "ru-central1-a"
  folder_id   = "b1gcj7qebvdr55der69j"

  resources {
    cores  = 2
    memory = 4
  }

  boot_disk {
    disk_id = yandex_compute_disk.default.id
  }

  network_interface {
    subnet_id = yandex_vpc_subnet.default.id
  }

  metadata = {
    ssh-keys = "ubuntu:${file("~/.ssh/id_ed25519.pub")}"
  }
}

resource "yandex_vpc_network" "default" {
  folder_id = "b1gcj7qebvdr55der69j"
}

resource "yandex_vpc_subnet" "default" {
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.default.id
  v4_cidr_blocks = ["10.5.0.0/24"]
  folder_id      = "b1gcj7qebvdr55der69j"
}

resource "yandex_compute_disk" "default" {
  name      = "disk-name"
  type      = "network-ssd"
  zone      = "ru-central1-a"
  image_id  = "fd83s8u085j3mq231ago"
  folder_id = "b1gcj7qebvdr55der69j"

  labels = {
    environment = "test"
  }
}
