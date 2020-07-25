locals {
  fastly_sorted = sort(data.fastly_ip_ranges.fastly.cidr_blocks)
  whitelist_sorted = sort(concat(var.org,var.others))
}

resource "fastly_service_v1" "service" {
  name = "service-${var.domains[0]}"
  version_comment = "tf_managed"
  activate = var.activate

  dynamic "domain" {
    for_each = [ for d in var.domains : { name = d }]
    content {
      name = domain.value.name
    }
  }
    
  # create multiple backends
  dynamic "backend" {
    for_each = [ for b in var.origins : {
      name = b.name
      host = b.host
      ssl  = b.ssl
    }]
    content {
      name    = backend.value.name
      address = backend.value.host
      port    = backend.value.ssl ? 443 : 80
      use_ssl = backend.value.ssl
      auto_loadbalance  = false          # set to false if using multiple differing backends
      ssl_check_cert    = backend.value.ssl
      ssl_cert_hostname = backend.value.ssl ? backend.value.host : null
      ssl_sni_hostname  = backend.value.ssl ? backend.value.host : null
    }
  }

  # create s3 logging endpoint - push fastly logs to s3
  s3logging{
    name = "logs-${var.domains[0]}"
    bucket_name = var.logs_bucket
    s3_access_key = data.aws_ssm_parameter.s3_access_key.value
    s3_secret_key = data.aws_ssm_parameter.s3_secret_key.value
    path = "${var.domains[0]}/"
    domain = var.region
    period = contains(var.domains, "www.example.com") ? 60 : 600
    format = file("${path.module}/files/log-format.txt")
    format_version = 2
    message_type = "blank"
  }

  # create vcl snippets
  dynamic "snippet" {
    for_each = [ for s in ["recv","error","fetch","deliver","hit"] : { name = s }]
    content {
      name = snippet.value.name
      type = snippet.value.name
      content = file("${path.module}/vcl/${snippet.value.name}.vcl")
    }
  }

  # create acls to use in vcl
  dynamic "acl" {
    for_each = [ for a in [ "acl_1", "acl_2" ] : { name = a }]
    content {
      name = acl.value.name
    }
  }

  # create edge dictionaries to use in vcl
  dynamic "dictionary" {
    for_each = [ for dict in [ "edge_dict_1" ] : { name = dict }]
    content {
      name = dictionary.value.name
    }
  }

  force_destroy = true
  lifecycle {
    ignore_changes = [ version_comment ]
  }
}

# create acl entries
resource "fastly_service_acl_entries_v1" "fastly" {
  service_id = fastly_service_v1.service.id
  acl_id     = { for d in fastly_service_v1.service.acl : d.name => d.acl_id }[ "acl_1" ]
  dynamic "entry" {
    for_each = [for e in local.fastly_sorted : {
      ip      = split("/",e)[0]
      subnet  = split("/",e)[1]
      comment = "fastly"
    }]
    content {
      ip      = entry.value.ip
      subnet  = entry.value.subnet
      comment = entry.value.comment
      negated = false
    }
  }
}

# create acl entries
resource "fastly_service_acl_entries_v1" "whitelist" {
  service_id = fastly_service_v1.service.id
  acl_id     = { for d in fastly_service_v1.service.acl : d.name => d.acl_id }["acl_2"]
  dynamic "entry" {
    for_each = [for e in local.whitelist_sorted : {
      ip      = split("/",e)[0]
      subnet  = split("/",e)[1]
      comment = try(split("/",e)[2], "unspecified")
    }]
    content {
      ip      = entry.value.ip
      subnet  = entry.value.subnet
      comment = entry.value.comment
      negated = false
    }
  }
}
