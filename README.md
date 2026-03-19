# JO 2024 Ticketing - Docker Container

Ticketing application for the 2024 Olympic Games, containerized with Docker. This full-stack application combines a Spring Boot back-end and a React front-end in a single optimized container.

## Links to other documentation

* [Front-end](https://github.com/BDoryan/studi-jo2024-frontend/)
* [Back-end](https://github.com/BDoryan/studi-jo2024-backend/)

## Diagram

<img src="https://github.com/BDoryan/studi-jo2024-docker/blob/main/schema.png?raw=true">

## Table of Contents

* [Architecture](#architecture)
* [Technologies](#technologies)
* [Prerequisites](#prerequisites)
* [Installation](#installation)
* [Configuration](#configuration)
* [Usage](#usage)
* [Project Structure](#project-structure)
* [Ports and Access](#ports-and-access)
* [Deployment](#deployment)
* [Maintenance](#maintenance)

## Architecture

The application uses a multi-service Docker architecture:

* **`jo2024-app` container**: Main application containing:

  * Nginx (web server for the React front-end)
  * Spring Boot (back-end REST API)
  * Supervisord (process manager)

* **`jo2024-db` container**: MySQL 8 database

## Technologies

### Back-end

* **Java 21** (Eclipse Temurin JDK)
* **Spring Boot 3.x**
* **Spring Data JPA**
* **MySQL 8**
* **Spring Mail** (email sending)
* **Stripe API** (payments)

### Front-end

* **React** (SPA application)
* **Vite** (build tool)
* **Custom font**: Paris 2024

### Infrastructure

* **Docker** & **Docker Compose**
* **Nginx** (web server)
* **Supervisord** (process manager)

## Prerequisites

* Docker version 20.10+
* Docker Compose version 2.0+

## Installation

### 1. Clone the project

```bash
git clone <repository-url>
cd jo2024
```

### 2. Configure environment variables

Edit the `docker-compose.yml` file and configure the environment variables:

```yaml
environment:
  # Database
  SPRING_DATASOURCE_URL: jdbc:mysql://db:3306/jo2024
  SPRING_DATASOURCE_USERNAME: your_user
  SPRING_DATASOURCE_PASSWORD: your_password
  
  # Email configuration (SMTP)
  SPRING_MAIL_HOST: smtp.example.com
  SPRING_MAIL_PORT: 587
  SPRING_MAIL_USERNAME: your_email@example.com
  SPRING_MAIL_PASSWORD: your_password
  
  # Default admin account
  ADMIN_DEFAULT_EMAIL: admin@example.com
  ADMIN_DEFAULT_PASSWORD: secure_password
  
  # Application URLs
  CORS_ALLOWED_ORIGIN: https://jo2024.example.com
  APP_FRONTEND_URL: https://jo2024.example.com
  APP_BACKEND_URL: https://jo2024-api.example.com
  
  # Stripe configuration
  STRIPE_SECRET_KEY: sk_test_...
  STRIPE_WEBHOOK_SECRET: whsec_...
  STRIPE_PUBLIC_KEY: pk_test_...
  
  # Others
  APP_NAME: "JO 2024 Ticketing"
  SUPPORT_EMAIL: support@example.com
```

### 3. Start the application

```bash
docker-compose up -d
```

### 4. Verify startup

```bash
# Check logs
docker-compose logs -f

# Check container status
docker-compose ps
```

## Configuration

### MySQL Configuration

The MySQL database is configured with:

* Exposed port: `3307:3306`
* Persistent volume: `db_data`
* Automatic health check to start Spring Boot after MySQL is ready
* Automatic creation of the `jo2024` database

### Nginx Configuration

The `nginx.conf` file is configured to:

* Serve React static files
* Handle SPA (Single Page Application) routing
* Redirect all routes to `index.html`

### Supervisord Configuration

Supervisord manages two processes:

1. **Nginx** (priority 10) - starts first
2. **Spring Boot** (priority 20) - starts after Nginx

Both services automatically restart in case of failure.

## Usage

### Application access (on VPS output)

* **Front-end**: [http://localhost:8080](http://localhost:8080)
* **Back-end API**: [http://localhost:8081](http://localhost:8081)
* **Database**: localhost:3307

### Useful Docker commands

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View logs in real time
docker-compose logs -f

# View logs for a specific service
docker-compose logs -f jo2024

# Restart services
docker-compose restart

# Rebuild and restart
docker-compose up -d --build

# Stop and remove volumes (deletes data)
docker-compose down -v
```

### Container access

```bash
# Access application container
docker exec -it jo2024-app bash

# Access MySQL container
docker exec -it jo2024-db mysql -u root -p
```

## Project Structure

```text
.
├── Dockerfile
├── back-end
│   ├── jo2024-0.0.1-SNAPSHOT.jar
├── docker-compose.yml
├── front-end
│   ├── build
│   │   ├── assets
│   │   │   ├── index-B_8GwUsp.js
│   │   │   └── index-rtrBg8Oz.css
│   │   ├── favicon.ico
│   │   ├── fonts
│   │   │   └── paris2024.ttf
│   │   ├── imgs
│   │   │   ├── display.jpeg
│   │   │   ├── hero-bg.jpg
│   │   │   ├── logo-paralympiques.png
│   │   │   ├── logo.png
│   │   │   └── sports
│   │   │       ├── athletisme.jpeg
│   │   │       ├── football.jpeg
│   │   │       └── natation.jpeg
│   │   ├── index.html
│   │   ├── logo192.png
│   │   ├── logo512.png
│   │   ├── manifest.json
│   │   └── robots.txt
├── nginx.conf
└── supervisord.conf
```

## Ports and Access

| Service                | Host Port | Container Port | Description          |
| ---------------------- | --------- | -------------- | -------------------- |
| Front-end (Nginx)      | 8080      | 80             | React user interface |
| Back-end (Spring Boot) | 8081      | 8080           | REST API             |
| MySQL                  | 3307      | 3306           | Database             |

## Deployment

### Production environment

To deploy in production:

1. Configure environment variables in `docker-compose.yml`
2. Use secrets for sensitive data
3. Set up a reverse proxy (Traefik, Nginx) with SSL/TLS
4. Implement regular database backups

### Reverse proxy example

```nginx
server {
    listen 443 ssl;
    server_name jo2024.example.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}

server {
    listen 443 ssl;
    server_name jo2024-api.example.com;

    ssl_certificate /path/to/cert.pem;
    ssl_certificate_key /path/to/key.pem;

    location / {
        proxy_pass http://localhost:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
    }
}
```

## Maintenance

### Backups

#### Database backup

```bash
docker exec jo2024-db mysqldump -u root -p jo2024 > backup_$(date +%Y%m%d_%H%M%S).sql
```

#### Restore backup

```bash
docker exec -i jo2024-db mysql -u root -p jo2024 < backup_20241020_120000.sql
```

#### Volume backup

```bash
docker run --rm -v jo2024_db_data:/data -v $(pwd):/backup \
  ubuntu tar czf /backup/db_backup.tar.gz /data
```

### Updates

#### Back-end update

1. Replace the JAR file in `back-end/jo2024-0.0.1-SNAPSHOT.jar`
2. Rebuild and restart:

```bash
docker-compose up -d --build
```

#### Front-end update

1. Replace the build in `front-end/build/`
2. Rebuild and restart:

```bash
docker-compose up -d --build
```

### Monitoring

```bash
docker-compose logs -f jo2024
docker-compose logs -f db
docker exec jo2024-app tail -f /var/log/nginx/access.log
docker-compose logs -f jo2024 | grep "Spring"
```

### Troubleshooting

```bash
# Front-end
docker exec jo2024-app supervisorctl status nginx
docker exec jo2024-app cat /var/log/nginx/error.log
docker exec jo2024-app supervisorctl restart nginx

# Back-end
docker exec jo2024-app supervisorctl status backend
docker-compose logs jo2024
docker exec jo2024-app supervisorctl restart backend

# Database
docker-compose logs db
docker exec jo2024-db mysql -u root -p -e "SHOW DATABASES;"
docker inspect jo2024-db | grep -A 10 Health
```

## Important Notes

* The container waits for MySQL to be fully ready before starting
* Data is persisted in a Docker volume named `db_data`
* Supervisord ensures services stay running
* JPA is set to `update`, so the database is automatically created/updated

## License

This project was developed as part of a STUDI (HETIC) assessment.
