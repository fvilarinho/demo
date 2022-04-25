terraform {
  cloud {
    organization = "fvilarinho"
    workspaces {
      name = "demo"
    }
  }
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
      version = "2.19.0"
    }
    linode = {
      source  = "linode/linode"
      version = "1.27.0"
    }
  }
}

provider "digitalocean" {
  token = var.digitalocean_token
}

provider "linode" {
  token = var.linode_token
}

data "digitalocean_ssh_key" "default" {
  name = "default"
}

data "linode_sshkey" "default" {
  label = "default"
}

resource "digitalocean_droplet" "cluster-manager" {
  image    = "debian-10-x64"
  name     = "cluster-manager"
  region   = "nyc1"
  size     = "s-2vcpu-4gb"
  ssh_keys = [data.digitalocean_ssh_key.default.id]

  provisioner "remote-exec" {
    inline = [
      "hostnamectl set-hostname cluster-manager",
      "apt -y update",
      "sleep 2",
      "apt -y upgrade",
      "apt -y install curl wget htop unzip dnsutils",
      "export K3S_TOKEN=${var.k3s_token}",
      "curl -sfL https://get.k3s.io | sh -",
      "kubectl apply -n portainer -f https://raw.githubusercontent.com/portainer/k8s/master/deploy/manifests/portainer/portainer-lb.yaml" #,
#      "export DD_AGENT_MAJOR_VERSION=7",
#      "export DD_API_KEY=${var.datadog_agent_key}",
#      "export DD_SITE=datadoghq.com",
#      "curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh -o install_script.sh",
#      "chmod +x ./install_script.sh",
#      "./install_script.sh"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      agent       = false
      private_key = var.digitalocean_ssh_key
      host        = self.ipv4_address
    }
  }
}

resource "linode_instance" "cluster-worker" {
  label           = "cluster-worker"
  image           = "linode/debian10"
  region          = "eu-central"
  type            = "g6-standard-2"
  authorized_keys = [data.linode_sshkey.default.ssh_key]
  depends_on      = [digitalocean_droplet.cluster-manager]

  provisioner "remote-exec" {
    inline = [
      "hostnamectl set-hostname cluster-worker",
      "apt -y update",
      "apt -y upgrade",
      "apt -y install curl wget htop unzip dnsutils",
      "export K3S_URL=https://${digitalocean_droplet.cluster-manager.ipv4_address}:6443",
      "export K3S_TOKEN=${var.k3s_token}",
      "curl -sfL https://get.k3s.io | sh -" #,
#      "export DD_AGENT_MAJOR_VERSION=7",
#      "export DD_API_KEY=${var.datadog_agent_key}",
#      "export DD_SITE=datadoghq.com",
#      "curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh -o install_script.sh",
#      "chmod +x ./install_script.sh",
#      "./install_script.sh"
    ]

    connection {
      type        = "ssh"
      user        = "root"
      agent       = false
      private_key = var.linode_ssh_key
      host        = self.ip_address
    }
  }
}

output "cluster-manager-ip" {
  value = digitalocean_droplet.cluster-manager.ipv4_address
}