# ☁️ 3-Tier Todo Application with Terraform on AWS

This project sets up a **complete, production-grade 3-tier web application** using:

- 🌐 **Frontend**: Static HTML/CSS (Todo UI) hosted on **S3** with HTTPS via **CloudFront**
- 🧠 **Backend**: Node.js API deployed on **EC2 (Auto Scaling + ALB)** behind a custom domain
- 🗃️ **Database**: **RDS MySQL**
- 🌍 **DNS & SSL**: Managed via **Route 53 + ACM**

---

## 📁 Folder Structure

```graphql
todo-app/
├── terraform/
│   ├── alb.tf
│   ├── certificate.tf
│   ├── ec2.tf
│   ├── main.tf
│   ├── output.tf
│   ├── rds.tf
│   ├── route53.tf
│   ├── s3.tf
│   ├── security_groups.tf
│   ├── user_data.sh.tpl  # installs Node API on EC2
│   ├── variables.tf
│   └── vpc.tf
├── backend/              # Express.js Todo API (MySQL)
├── frontend/             # HTML/CSS + config.js (api url)
└── README.md
```

---

## 🔧 Architecture Overview

```scss
        User (Browser)
             │
 ┌───────────┴────────────┐
 │    todo.domain.com    │
 │  (CloudFront + ACM)    │
 └───────────┬────────────┘
             │
   ┌─────────▼─────────┐
   │   S3 Static Site  │
   └─────────┬─────────┘
             │ (fetches)
             ▼
 ┌──────────────────────────────┐
 │     api.domain.com (ALB)     │
 │    Node.js Backend on EC2    │
 └────────────┬────────────────┘
              │
         ┌────▼────┐
         │  RDS    │
         │ MySQL   │
         └─────────┘
```

---

## 🛠 Prerequisites

- ✅ AWS CLI + credentials configured
- ✅ A domain name (e.g., `domain.com `)
- ✅ A registered key pair in AWS (for EC2 SSH access)
- ✅ Terraform

---

## 🚀 Setup Instructions

### 1️⃣ Clone & Enter Project

```bash
git clone https://github.com/krunalbhandekar/terraform-3tier-app.git
```

```bash
cd terraform
```

### 2️⃣ Run Terraform

```bash
terraform init
```

**Update Variables Before Applying**

🔔 **IMPORTANT:** Replace the placeholders below with your actual values:

- **`root_domain`: your registered domain (e.g., `domain.com`)**
- **`db_password`: a strong password for MySQL admin user**
- **`key_pair_name`: your EC2 key pair name (must exist in AWS)**
- **`allowed_ip`: your current IP address to allow SSH access to EC2**

Then run:

```bash
terraform apply \
  -var="root_domain=<domain.com >" \
  -var="db_username=admin" \
  -var="db_password=<StrongPassw0rd>" \
  -var="key_pair_name=<my-keypair>" \
  -var="allowed_ip=$(curl -s ifconfig.me)/32"
```

### 3️⃣ Update Your Domain’s Name Servers (Only Once)

If your domain is NOT registered with Route 53:

- After apply, you’ll see output like:

```ini
zone_name_servers = [
  "ns-1224.awsdns-25.org",
  "ns-1555.awsdns-02.co.uk",
  "ns-286.awsdns-35.com",
  "ns-600.awsdns-11.net",
]
```

- Go to your **domain registrar** (e.g., GoDaddy, Namecheap, etc.)
- Update the domain's nameservers to the 4 above.

⚠️ **Until you do this, `todo.domain.com ` and `api.domain.com ` will not resolve!**

### 🌐 Application Endpoints

| Tier     | URL                                                 | Notes                      |
| -------- | --------------------------------------------------- | -------------------------- |
| Frontend | [https://todo.domain.com ](https://todo.domain.com) | Served via CloudFront + S3 |
| Backend  | [https://api.domain.com ](https://api.domain.com)   | Node API on EC2 + ALB      |
| Database | RDS MySQL (private)                                 | Connect via EC2            |

### 🔒 Security Notes

- Public access to S3 is restricted to `GET` for website only
- EC2 SSH is allowed only from your current IP
- ACM SSL certs are auto-validated using Route 53

### ✅ To Do After Setup

- Upload your custom frontend (HTML/CSS/JS) to the S3 bucket
- Confirm both URLs (`todo.domain.com ` and `api.domain.com `) work
- Monitor DNS propagation (~5–20 mins after NS update)

### 🧹 Destroy

To tear everything down:

```bash
terraform destroy
```

Make sure you’ve backed up any DB data first!

---

### 👨‍💻 Author

Built by **[Krunal Bhandekar](https://www.linkedin.com/in/krunal-bhandekar/)** using Terraform, Node.js, AWS and best practices.

---

## 🆘 Need Help?

Open an issue or reach out to me if:

- DNS isn't resolving after 30 mins
- CloudFront gives **403 errors**
- S3 site shows **"Access Denied"**

---
