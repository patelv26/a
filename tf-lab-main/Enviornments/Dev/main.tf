provider "aws" {
    region = "us-west-1"
}

provider "cloudflare" {
  email   = var.cloudflare_email
  api_key = var.cloudflare_api_key
}

module "vpc" {
    source = "../Modules/Network/"
    
    vpc_cidr = "10.200.0.0/16"
    public_subnet = "10.200.1.0/24"
    private_subnet = "10.200.2.0/24"
_
}

module "security_group" {
    source = "../Modules/Security"
    vpc_id = module.vpc.vpc_id
}
module "compute" {

    source = "../Modules/Compute/"

    subnet_id = module.vpc.private.id
    security_groups = module.security_group.id
}

module "waf" {

    source = "../Modules/Cloudflare"
    
    zone_id = var.cloudflare_zone_id

}