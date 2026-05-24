resource "aws_ecr_repository" "my_app_repo" {
  name                 = "devops08-homework-nginx" # Jmeno, pod kterym registr uvidis v AWS konzoli
  image_tag_mutability = "MUTABLE"  # MUTABLE = umoznuje nahrat image se stejnym tagem (na vyvoj rychlejsi varianta), v produkci lepsi IMMUTABLE, aby omylem nekdo neprepsal bezici aplikaci

  image_scanning_configuration {
    scan_on_push = true # Automaticky otestuje image na zname zranitelnosti pri kazdem pushi
  }
}