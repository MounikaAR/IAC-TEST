data "template_file" "public_subnet_template_file" {
  count    = length(data.aws_subnet_ids.public.ids)
  template = file("./env/${var.env}/templates/subnet.tmpl.yaml")

  vars = {
    name              = lookup(data.aws_subnet.public[count.index], "availability_zone")
    cidr              = lookup(data.aws_subnet.public[count.index], "cidr_block")
    id                = lookup(data.aws_subnet.public[count.index], "id")
    type              = "Public"
    availability_zone = lookup(data.aws_subnet.public[count.index], "availability_zone")
  }
}

data "template_file" "private_subnet_template_file" {
  count    = length(data.aws_subnet_ids.private.ids)
  template = file("./env/${var.env}/templates/subnet.tmpl.yaml")

  vars = {
    name              = lookup(data.aws_subnet.private[count.index], "availability_zone")
    cidr              = lookup(data.aws_subnet.private[count.index], "cidr_block")
    id                = lookup(data.aws_subnet.private[count.index], "id")
    type              = "Private"
    availability_zone = lookup(data.aws_subnet.private[count.index], "availability_zone")
  }
}

data "template_file" "cluster_spec_value_file" {
  template = file("./env/${var.env}/templates/values.tmpl.yaml")

  vars = {
    cluster_name       = var.cluster-name
    dns_zone           = var.dns-zone
    kubernetes_version = var.k8s-version
    kops_state_bucket  = var.kops-state-bucket
    node_image         = var.node-image
    vpc_id             = data.aws_vpc.kops.id
    vpc_cidr           = data.aws_vpc.kops.cidr_block
    private_subnets    = join("", data.template_file.private_subnet_template_file.*.rendered)
    public_subnets     = join("", data.template_file.public_subnet_template_file.*.rendered)
    nat_gateway_id     = var.nat-gateway-id
    key_name           = var.public-key-pair-name
  }
}

resource "aws_key_pair" "k8s_public_key" {
  count      = var.add-key-pair ? 1 : 0
  public_key = data.aws_ssm_parameter.public-key
  key_name   = var.public-key-pair-name
}

resource "local_file" "cluster_spec_value_file" {
  content  = data.template_file.cluster_spec_value_file.rendered
  filename = "./output/kops/${var.env}/cluster_spec_values.yaml"
}

# TODO make more parameters
resource "null_resource" "provision_kops" {
  depends_on = [local_file.cluster_spec_value_file]
  provisioner "local-exec" {
    environment = {
      KOPS_STATE_STORE = "s3://${var.kops-state-bucket}"
    }

    command = <<EOT
    kops toolbox template --template ./env/${var.env}/templates/cluster_spec.tmpl.yaml --values ./output/kops/${var.env}/cluster_spec_values.yaml > ./output/kops/${var.env}/cluster_spec.yaml
    kops create -f ./output/kops/${var.env}/cluster_spec.yaml

    kops update cluster  ${var.cluster-name}.${var.dns-zone} --yes
    kops create secret --name ${var.cluster-name}.${var.dns-zone} sshpublickey admin -i ${data.aws_ssm_parameter.public-key}
    kops update cluster  ${var.cluster-name}.${var.dns-zone} --yes
EOT
  }
}

resource "null_resource" "destroy-time" {
  triggers = {
    kops-state-bucket = var.kops-state-bucket
  }

  provisioner "local-exec" {
    when = destroy
    environment = {
      KOPS_STATE_STORE = "s3://${self.triggers.kops-state-bucket}"
    }
    command = "echo $KOPS_STATE_STORE"
  }
}