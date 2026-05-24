# DevOps_08_GitOps_integrace_vs_delivery
Repozitoř k 8. lekci

# DevOps Úkol 08: CI/CD a GitOps integrace s AWS ECS Fargate

Tento repozitář obsahuje řešení domácího úkolu zaměřeného na plnou automatizaci nasazení kontejnerizované aplikace (Nginx) do AWS pomocí kombinace nástrojů GitHub Actions (CI/CD) a Terraform (IaC).

## 🎯 Cíle projektu
* **Infrastruktura jako kód (IaC):** Automatické vytvoření AWS ECR, ECS Clusteru, úlohy (Task Definition) a služby běžící na bezserverové platformě AWS Fargate.
* **Vysoká dostupnost a síť:** Nasazení Application Load Balanceru (ALB) distribuovaného přes veřejné subnety, včetně Target Group a provázaných Security Groups (přístup na ECS povolen výhradně z ALB).
* **CI/CD / GitOps Pipeline:** Automatické sestavení Docker image z lokálního Dockerfile, autentizace do AWS a pushnutí image do AWS ECR při každém nahrání kódu do GitHubu.
* **Logování:** Sběr a ukládání logů z kontejneru do AWS CloudWatch logovací skupiny.

## 📂 Struktura projektu
Projekt je rozdělen do logických bloků pro správu Terraformu a GitHub Actions:

* `.github/workflows/deploy.yml` - Definiční soubor GitHub Actions pipeline (build, auth, push do ECR).
* `ecr.tf` - Definice AWS Elastic Container Registry pro bezpečné ukládání Docker images.
* `ecs.tf` - Definice ECS Clusteru, Fargate Task Definition (s definicí logování a portů) a ECS Service.
* `iam.tf` - Definice IAM rolí a provázání s `AmazonECSTaskExecutionRolePolicy` pro stahování image z ECR a zápis logů.
* `variables.tf` / `outputs.tf` - Proměnné a výstupy (URL adresa běžícího Load Balanceru).
* `Dockerfile` / `index.html` - Zdrojové soubory aplikace (Nginx s upravenou domovskou stránkou).
* Další pomocné `.tf` soubory z minulé lekce pro konfiguraci sítí a Load Balanceru.

## 🚀 Návod k použití

### 1. Prerekvizity
* Nakonfigurované **GitHub Repository Secrets** (`AWS_ACCESS_KEY_ID`, `AWS_SECRET_ACCESS_KEY`).
* Nainstalovaný **Terraform** a **AWS CLI**.

### 2. Spuštění (Postup "Slepice-Vejce")
Jelikož ECS Task Definition vyžaduje existující image v ECR, postup je rozdělen do kroků:

1. **Vytvoření ECR registru:**
   ```bash
   terraform init
   terraform apply -target=aws_ecr_repository.my_app_repo
   ```

2. **Spuštění CI/CD pipeline (Push do GitHubu):**
Nahráním kódu se spustí GitHub Actions, které sestaví Docker image a nahrají ho do ECR s tagem `latest`.

3. **Dostavba infrastruktury:**
```Bash
terraform apply
```

### 3. Ověření připojení
Po úspěšném dokončení Terraform vypíše výstupní proměnnou `load_balancer_url`. Webová aplikace je dostupná na této adrese přes protokol HTTP (port 80).

### 4. Úklid infrastruktury (Cleanup)
```Bash
terraform destroy
```

### Bezpečnost
Přístupové klíče k AWS a lokální stavové soubory Terraformu (`.tfstate`, `.tfstate.backup`) jsou přísně ignorovány pomocí `.gitignore`.
