#!/bin/bash
apt update -y
apt install -y nodejs npm git mysql-client-core-8.0
git clone https://github.com/krunalbhandekar/terraform-3tier-app.git /opt/todo-app
cd /opt/todo-app/backend
npm install

cat > .env <<EOF 
PORT=3000
DB_HOST=${db_host}
DB_USER=${db_user}
DB_PASS=${db_pass}
DB_NAME=${db_name}
EOF

npm install -g pm2
pm2 start index.js --name todo-api
pm2 save
