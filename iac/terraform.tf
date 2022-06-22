terraform {
  cloud {
    organization = "fvilarinho"
    workspaces {
      name = "demo"
    }
  }
  required_providers {
    linode = {
      source  = "linode/linode"
      version = "1.27.0"
    }
  }
}

provider "linode" {
  token = var.linode_token
}

data "linode_sshkey" "default" {
  label = "default"
}

resource "linode_instance" "cluster-manager" {
  label           = "cluster-manager"
  image           = "linode/debian10"
  region          = "us-east"
  type            = "g6-standard-2"
  authorized_keys = [data.linode_sshkey.default.ssh_key]

  provisioner "remote-exec" {
    inline = [
      "hostnamectl set-hostname cluster-manager",
      "apt -y update ; pkill -9 dpkg ;  pkill -9 apt ; apt -y upgrade",
      "apt -y install curl wget htop unzip dnsutils",
      "export K3S_TOKEN=${var.k3s_token}",
      "curl -sfL https://get.k3s.io | sh -",
      "kubectl apply -n portainer -f https://raw.githubusercontent.com/portainer/k8s/master/deploy/manifests/portainer/portainer-lb.yaml",
      "export DD_AGENT_MAJOR_VERSION=7",
      "export DD_API_KEY=${var.datadog_agent_key}",
      "export DD_SITE=datadoghq.com",
      "curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh -o install_script.sh",
      "chmod +x ./install_script.sh",
      "./install_script.sh"
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

resource "linode_instance" "cluster-worker" {
  label           = "cluster-worker"
  image           = "linode/debian10"
  region          = "eu-central"
  type            = "g6-standard-2"
  authorized_keys = [data.linode_sshkey.default.ssh_key]
  depends_on      = [ linode_instance.cluster-manager ]

  provisioner "remote-exec" {
    inline = [
      "hostnamectl set-hostname cluster-manager",
      "apt -y update ; pkill -9 dpkg ;  pkill -9 apt ; apt -y upgrade",
      "apt -y install curl wget htop unzip dnsutils",
      "curl -sfL https://get.k3s.io | K3S_URL=https://${linode_instance.cluster-manager.ip_address}:6443 K3S_TOKEN=${var.k3s_token} sh -",
      "export DD_AGENT_MAJOR_VERSION=7",
      "export DD_API_KEY=${var.datadog_agent_key}",
      "export DD_SITE=datadoghq.com",
      "curl -L https://s3.amazonaws.com/dd-agent/scripts/install_script.sh -o install_script.sh",
      "chmod +x ./install_script.sh",
      "./install_script.sh"
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
  value = linode_instance.cluster-manager.ip_address
}