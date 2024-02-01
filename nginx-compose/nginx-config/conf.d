events {
    worker_connections 1024;  # Adjust the number based on your needs
}

http {
    server {
        listen 443 ssl;
        server_name flaskapp;

        ssl_certificate /etc/nginx/ssl/mywebsite.crt;
        ssl_certificate_key /etc/nginx/ssl/mywebsite.key;

        location / {
            proxy_pass http://192.168.1.15:5000/;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }

    server {
        listen 443 ssl;
        server_name phpmyadmin;

        ssl_certificate /etc/nginx/ssl/mywebsite.crt;
        ssl_certificate_key /etc/nginx/ssl/mywebsite.key;

        location / {
            proxy_pass http://192.168.1.15:8000;
            proxy_set_header Host $host;
            proxy_set_header X-Real-IP $remote_addr;
            proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
            proxy_set_header X-Forwarded-Proto $scheme;
        }
    }
}
