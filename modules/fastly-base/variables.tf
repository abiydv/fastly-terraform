variable "domains" {
    type    = list(string)
}
variable "org" {
    type    = list(string)
}
variable "others" {
    type    = list(string)
}
variable "origins" {
    type    = list(map(string))
}
variable "activate" {
    default = true
}
variable "logs_bucket" {
    default = "s3-example"
}
variable "region" {
    default = "us-east-1"
}
