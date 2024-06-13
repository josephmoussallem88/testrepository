resource "github_repository" "github_rep" {
  name        = "TestProject"
  description = "testing terraform with github"

  visibility = "public"

  template {
    owner                = "github"
    repository           = "terraform-template-module"
    include_all_branches = true
  }
}

module "compute" {
 source = "./_modules/compute"
}

module "S3" {
 source = "./_modules/s3"
}
