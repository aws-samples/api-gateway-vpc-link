module "ecr" {
  source               = "../../common/modules/ecr"
  for_each             = toset(var.ecr_name)
  environment          = var.environment
  name                 = each.value
  number_of_images     = var.number_of_images
  image_tag_mutability = var.image_tag_mutability
  scan_on_push         = var.scan_on_push
}