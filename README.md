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
│   ├── main.tf
│   ├── vpc.tf
│   ├── alb.tf
│   ├── rds.tf
│   ├── s3.tf
│   ├── cloudfront.tf
│   ├── route53.tf
│   ├── certificate.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── user_data.sh.tpl  # installs Node API on EC2
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
 │    todo.krunal.bar     │
 │  (CloudFront + ACM)    │
 └───────────┬────────────┘
             │
   ┌─────────▼─────────┐
   │   S3 Static Site  │
   └─────────┬─────────┘
             │ (fetches)
             ▼
 ┌──────────────────────────────┐
 │     api.krunal.bar (ALB)     │
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
- ✅ A domain name (e.g., `krunal.bar`)
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

```bash
terraform apply \
  -var="root_domain=krunal.bar" \
  -var="db_username=admin" \
  -var="db_password=StrongPassw0rd" \
  -var="key_pair_name=my-keypair" \
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

⚠️ **Until you do this, `todo.krunal.bar` and `api.krunal.bar` will not resolve!**

### 🌐 Application Endpoints

| Tier     | URL                                                | Notes                      |
| -------- | -------------------------------------------------- | -------------------------- |
| Frontend | [https://todo.krunal.bar](https://todo.krunal.bar) | Served via CloudFront + S3 |
| Backend  | [https://api.krunal.bar](https://api.krunal.bar)   | Node API on EC2 + ALB      |
| Database | RDS MySQL (private)                                | Connect via EC2            |

### 🔒 Security Notes

- Public access to S3 is restricted to `GET` for website only
- EC2 SSH is allowed only from your current IP
- ACM SSL certs are auto-validated using Route 53

### ✅ To Do After Setup

- Upload your custom frontend (HTML/CSS/JS) to the S3 bucket
- Confirm both URLs (`todo.krunal.bar` and `api.krunal.bar`) work
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
