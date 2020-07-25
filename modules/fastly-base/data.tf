data "fastly_ip_ranges" "fastly" {}

data "aws_ssm_parameter" "s3_access_key"{
    name = "/fastly/logs/s3_access_key"
}

data "aws_ssm_parameter" "s3_secret_key"{
    name = "/fastly/logs/s3_secret_key"
}
