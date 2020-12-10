data "template_file" "public_subnet_template_file" {
  count    = var.number_of_subnets
  template = file("./env/${var.env}/templates/subnet.tmpl.yaml")

  vars = {
    name = element(var.public_subnets_names, count.index)
    cidr = lookup(var.public_subnets[count.index], "cidr_block")
    id = lookup(var.public_subnets[count.index], "id")
    type = "Public"
    availability_zone = lookup(var.public_subnets[count.index], "availability_zone")
  }
}

data "template_file" "private_subnet_template_file" {
  count    =  var.number_of_subnets
  template = file("./env/${var.env}/templates/subnet.tmpl.yaml")

  vars = {
    name = element(var.private_subnets_names, count.index)
    cidr = lookup(var.private_subnets[count.index], "cidr_block")
    id = lookup(var.private_subnets[count.index], "id")
    type = "Private"
    availability_zone = lookup(var.private_subnets[count.index], "availability_zone")
  }
}

data "template_file" "cluster_spec_value_file" {
  template = file("./env/${var.env}/templates/values.tmpl.yaml")

  vars = {
    cluster_name = var.cluster_name
    dns_zone = var.dns_zone
    kubernetes_version = var.kubernetes_version
    kops_state_bucket = var.kops_state_bucket
    node_image = var.node_image
    vpc_id = var.vpc_id
    vpc_cidr = var.vpc_cidr_block
    private_subnets = join("", data.template_file.private_subnet_template_file.*.rendered)
    public_subnets = join("", data.template_file.public_subnet_template_file.*.rendered)
    nat_gateway_id = var.nat_gateway_id

  }
}

resource "local_file" "cluster_spec_value_file" {
  content  = data.template_file.cluster_spec_value_file.rendered
  filename = "./output/kops/${var.env}/cluster_spec_values.yaml"
}

# TODO make more parameters
resource "null_resource" "provision_kops" {
  depends_on = ["local_file.cluster_spec_value_file"]
  provisioner "local-exec" {
    environment = {
      KOPS_STATE_STORE ="s3://${var.kops_state_bucket}"
    }

    command = <<EOT
    kops toolbox template --template ./env/${var.env}/templates/cluster_spec.tmpl.yaml --values ./output/kops/${var.env}/cluster_spec_values.yaml > ./output/kops/${var.env}/cluster_spec.yaml
EOT
  }


}

