# Steps for deployment



## Step 1 : Create EC2 Instance

Create an EC2 Instance and all ssh, http, https ports

## Step 2: Connect to EC2 Instance and run the following command

```bash
sudo apt update && sudo apt upgrade -y && sudo apt install python3 -y && sudo apt install python3-pip -y && sudo apt install python3-venv -y && sudo apt install nodejs -y && sudo apt install npm -y && sudo apt install vim -y && sudo apt install curl && sudo apt install docker.io -y && sudo apt install docker-compose -y && sudo apt install nginx -y

```


## Step 3: Copy the project using scp or git clone and setup all environment variables

## Step 4: Setup Nginx

```bash
sudo mv /etc/nginx/sites-available/default /etc/nginx/sites-available/default-demo
sudo nano /etc/nginx/sites-available/default
```

and paste the following
```nginx
server {
    listen 80;  
    server_name 34.201.65.58;  

    location /sms-gateway {
        rewrite ^/sms-gateway(/.*)$ $1 break;  # Strips the /sms-gateway prefix
        proxy_pass http://localhost:3000;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /notification-service {
        rewrite ^/notification-service(/.*)$ $1 break;  # Strips the /notification-service prefix
        proxy_pass http://localhost:9000;  
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /travel-service {
        rewrite ^/travel-service(/.*)$ $1 break;  # Strips the /travel-service prefix
        proxy_pass http://localhost:8000;  
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /chatbot-service {
        rewrite ^/chatbot-service(/.*)$ $1 break;  # Strips the /chatbot-service prefix
        proxy_pass http://localhost:8003;  
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /auth-service {
        rewrite ^/auth-service(/.*)$ $1 break;  # Strips the /auth-service prefix
        proxy_pass http://localhost:8080;  
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    location /sos-button-service {
        rewrite ^/sos-button-service(/.*)$ $1 break;  # Strips the /sos-button-service prefix
        proxy_pass http://localhost:8001;  
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

```

Then Save and Exit

Then restart nginx

```bash
sudo systemctl restart nginx
```

and allow traffic through firewall

```bash
sudo ufw allow 80
```

Check Nginx logs
```bash
sudo tail -f /var/log/nginx/error.log
```

Check for Errors in the NGINX Configuration
```bash
sudo nginx -t
```

## Step 5: Setup the kafka queue

```bash
cd notification-service/kafka
sudo docker-compose up -d
docker ps
docker exec -it kafka kafka-topics --create --topic notifications --bootstrap-server localhost:9092 --partitions 4 --replication-factor 1
docker exec -it kafka kafka-topics --describe --topic notifications --bootstrap-server localhost:9092
```

## Step 6: Create a new tmux session

```bash
tmux new -s guardian360
```


