# Billetterie JO 2024 - Docker Container

Application de billetterie pour les Jeux Olympiques 2024, containerisée avec Docker. Cette application full-stack combine un back-end Spring Boot et un front-end React dans un seul conteneur optimisé.

## Liens vers les autres documentations
- [Front-end](https://github.com/BDoryan/studi-jo2024-frontend/)
- [Back-end](https://github.com/BDoryan/studi-jo2024-backend/)

## Table des matières

- [Architecture](#architecture)
- [Technologies](#technologies)
- [Prérequis](#prérequis)
- [Installation](#installation)
- [Configuration](#configuration)
- [Utilisation](#utilisation)
- [Structure du projet](#structure-du-projet)
- [Ports et accès](#ports-et-accès)
- [Déploiement](#déploiement)
- [Maintenance](#maintenance)

## Architecture

L'application utilise une architecture Docker multi-services :

- **Container `jo2024-app`** : Application principale contenant :
  - Nginx (serveur web pour le front-end React)
  - Spring Boot (API REST back-end)
  - Supervisord (gestionnaire de processus)
  
- **Container `jo2024-db`** : Base de données MySQL 8



## Technologies

### Back-end
- **Java 21** (Eclipse Temurin JDK)
- **Spring Boot 3.x**
- **Spring Data JPA**
- **MySQL 8**
- **Spring Mail** (envoi d'emails)
- **Stripe API** (paiements)

### Front-end
- **React** (application SPA)
- **Vite** (build tool)
- **Font personnalisée** : Paris 2024

### Infrastructure
- **Docker** & **Docker Compose**
- **Nginx** (serveur web)
- **Supervisord** (gestionnaire de processus)

## Prérequis

- Docker version 20.10+
- Docker Compose version 2.0+

## Installation

### 1. Cloner le projet

```bash
git clone <repository-url>
cd jo2024
```

### 2. Configuration des variables d'environnement

Éditer le fichier `docker-compose.yml` et configurer les variables d'environnement :

```yaml
environment:
  # Base de données
  SPRING_DATASOURCE_URL: jdbc:mysql://db:3306/jo2024
  SPRING_DATASOURCE_USERNAME: your_user
  SPRING_DATASOURCE_PASSWORD: your_password
  
  # Configuration email (SMTP)
  SPRING_MAIL_HOST: smtp.example.com
  SPRING_MAIL_PORT: 587
  SPRING_MAIL_USERNAME: your_email@example.com
  SPRING_MAIL_PASSWORD: your_password
  
  # Compte administrateur par défaut
  ADMIN_DEFAULT_EMAIL: admin@example.com
  ADMIN_DEFAULT_PASSWORD: secure_password
  
  # URLs de l'application
  CORS_ALLOWED_ORIGIN: https://jo2024.example.com
  APP_FRONTEND_URL: https://jo2024.example.com
  APP_BACKEND_URL: https://jo2024-api.example.com
  
  # Configuration Stripe
  STRIPE_SECRET_KEY: sk_test_...
  STRIPE_WEBHOOK_SECRET: whsec_...
  STRIPE_PUBLIC_KEY: pk_test_...
  
  # Autres
  APP_NAME: "Billetterie JO 2024"
  SUPPORT_EMAIL: support@example.com
```

### 3. Lancer l'application

```bash
docker-compose up -d
```

### 4. Vérifier le démarrage

```bash
# Vérifier les logs
docker-compose logs -f

# Vérifier l'état des conteneurs
docker-compose ps
```

## Configuration

### Configuration MySQL

La base de données MySQL est configurée avec :
- Port exposé : `3307:3306`
- Volume persistant : `db_data`
- Health check automatique
- Création automatique de la base `jo2024`

### Configuration Nginx

Le fichier `nginx.conf` est configuré pour :
- Servir les fichiers statiques React
- Gérer le routage SPA (Single Page Application)
- Rediriger toutes les routes vers `index.html`

### Configuration Supervisord

Supervisord gère deux processus :
1. **Nginx** (priorité 10) - Démarrage en premier
2. **Spring Boot** (priorité 20) - Démarrage après Nginx

Les deux services redémarrent automatiquement en cas d'erreur.

## Utilisation

### Accès à l'application

- **Front-end** : http://localhost:8080
- **API Back-end** : http://localhost:8081
- **Base de données** : localhost:3307

### Commandes Docker utiles

```bash
# Démarrer les services
docker-compose up -d

# Arrêter les services
docker-compose down

# Voir les logs en temps réel
docker-compose logs -f

# Voir les logs d'un service spécifique
docker-compose logs -f jo2024

# Redémarrer les services
docker-compose restart

# Reconstruire et redémarrer
docker-compose up -d --build

# Arrêter et supprimer les volumes (⚠️ supprime les données)
docker-compose down -v
```

### Accès aux conteneurs

```bash
# Accéder au conteneur de l'application
docker exec -it jo2024-app bash

# Accéder au conteneur MySQL
docker exec -it jo2024-db mysql -u root -p
```

## Structure du projet

```
.
├── Dockerfile
├── back-end
│   ├── jo2024-0.0.1-SNAPSHOT.jar
├── docker-compose.yml
├── front-end
│   ├── build
│   │   ├── assets
│   │   │   ├── index-B_8GwUsp.js
│   │   │   └── index-rtrBg8Oz.css
│   │   ├── favicon.ico
│   │   ├── fonts
│   │   │   └── paris2024.ttf
│   │   ├── imgs
│   │   │   ├── display.jpeg
│   │   │   ├── hero-bg.jpg
│   │   │   ├── logo-paralympiques.png
│   │   │   ├── logo.png
│   │   │   └── sports
│   │   │       ├── athletisme.jpeg
│   │   │       ├── football.jpeg
│   │   │       └── natation.jpeg
│   │   ├── index.html
│   │   ├── logo192.png
│   │   ├── logo512.png
│   │   ├── manifest.json
│   │   └── robots.txt
├── nginx.conf
└── supervisord.conf

28 directories, 87 files
```

**Structure simplifiée :**

```
.
├── Dockerfile                    # Configuration Docker de l'application
├── docker-compose.yml            # Orchestration des services
├── nginx.conf                    # Configuration du serveur Nginx
├── supervisord.conf              # Configuration du gestionnaire de processus
├── README.md                     # Documentation du projet
│
├── back-end/                     # Application Spring Boot
│   └── jo2024-0.0.1-SNAPSHOT.jar # JAR exécutable du back-end
│
└── front-end/                    # Application React
    └── build/                    # Build de production React
        ├── index.html            # Point d'entrée de l'application
        ├── manifest.json         # Manifeste PWA
        ├── robots.txt            # Configuration SEO
        ├── assets/               # Fichiers JS et CSS bundlés
        │   ├── index-B_8GwUsp.js
        │   └── index-rtrBg8Oz.css
        ├── fonts/                # Polices personnalisées
        │   └── paris2024.ttf
        └── imgs/                 # Images et assets
            ├── logo.png
            ├── logo-paralympiques.png
            ├── hero-bg.jpg
            ├── display.jpeg
            └── sports/           # Images des sports
                ├── athletisme.jpeg
                ├── football.jpeg
                └── natation.jpeg
```

## Ports et accès

| Service | Port hôte | Port conteneur | Description |
|---------|-----------|----------------|-------------|
| Front-end (Nginx) | 8080 | 80 | Interface utilisateur React |
| Back-end (Spring Boot) | 8081 | 8080 | API REST |
| MySQL | 3307 | 3306 | Base de données |

## Déploiement

### Environnement de production

Pour déployer en production :

1. **Configurer les variables d'environnement** dans `docker-compose.yml`
2. **Utiliser des secrets** pour les informations sensibles
3. **Configurer un reverse proxy** (Traefik, Nginx) avec SSL/TLS
4. **Mettre en place des sauvegardes** régulières de la base de données

### Exemple avec reverse proxy

```nginx
# Configuration Nginx en reverse proxy
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

### Sauvegardes

#### Sauvegarde de la base de données

```bash
# Créer une sauvegarde
docker exec jo2024-db mysqldump -u root -p jo2024 > backup_$(date +%Y%m%d_%H%M%S).sql

# Restaurer une sauvegarde
docker exec -i jo2024-db mysql -u root -p jo2024 < backup_20241020_120000.sql
```

#### Sauvegarde des volumes

```bash
# Sauvegarder le volume de données
docker run --rm -v jo2024_db_data:/data -v $(pwd):/backup \
  ubuntu tar czf /backup/db_backup.tar.gz /data
```

### Mises à jour

#### Mise à jour du back-end

1. Placer le nouveau JAR dans `back-end/jo2024-0.0.1-SNAPSHOT.jar`
2. Reconstruire et redémarrer :

```bash
docker-compose up -d --build
```

#### Mise à jour du front-end

1. Placer le nouveau build dans `front-end/build/`
2. Reconstruire et redémarrer :

```bash
docker-compose up -d --build
```

### Monitoring

#### Vérifier les logs

```bash
# Logs de l'application
docker-compose logs -f jo2024

# Logs de la base de données
docker-compose logs -f db

# Logs spécifiques à Nginx
docker exec jo2024-app tail -f /var/log/nginx/access.log

# Logs de Spring Boot
docker-compose logs -f jo2024 | grep "Spring"
```

#### Vérifier l'état des services

```bash
# État des conteneurs
docker-compose ps

# Ressources utilisées
docker stats

# Health check de MySQL
docker exec jo2024-db mysqladmin -u root -p ping
```

### Résolution de problèmes

#### Le front-end ne charge pas

```bash
# Vérifier que Nginx est démarré
docker exec jo2024-app supervisorctl status nginx

# Vérifier les logs Nginx
docker exec jo2024-app cat /var/log/nginx/error.log

# Redémarrer Nginx
docker exec jo2024-app supervisorctl restart nginx
```

#### Le back-end ne répond pas

```bash
# Vérifier que Spring Boot est démarré
docker exec jo2024-app supervisorctl status backend

# Voir les logs de l'application
docker-compose logs jo2024

# Redémarrer le back-end
docker exec jo2024-app supervisorctl restart backend
```

#### Problèmes de connexion à la base de données

```bash
# Vérifier que MySQL est prêt
docker-compose logs db

# Tester la connexion
docker exec jo2024-db mysql -u root -p -e "SHOW DATABASES;"

# Vérifier le health check
docker inspect jo2024-db | grep -A 10 Health
```

## Notes importantes

- Le conteneur attend que MySQL soit complètement démarré (via health check) avant de lancer l'application
- Les données de la base sont persistées dans un volume Docker nommé `db_data`
- Supervisord garantit que Nginx et Spring Boot sont toujours en cours d'exécution
- La configuration JPA est en mode `update`, la base de données sera créée/mise à jour automatiquement

## Licence

Ce projet est développé dans le cadre d'une évaluation STUDI.

## Support

Pour toute question ou problème, contactez : support@doryanbessiere.fr

---