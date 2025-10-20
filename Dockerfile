FROM eclipse-temurin:21-jdk

# Installer Nginx et Supervisord
RUN apt-get update && apt-get install -y nginx supervisor && apt-get clean

# Supprimer la config par défaut de Nginx (fichiers parasites)
RUN rm -f /etc/nginx/sites-enabled/default || true
RUN rm -rf /etc/nginx/conf.d/* || true

WORKDIR /app

# Copier le back-end
COPY back-end/jo2024-0.0.1-SNAPSHOT.jar /app/app.jar

# Copier le build React dans Nginx
COPY front-end/build /usr/share/nginx/html

# Copier ta configuration personnalisée
COPY nginx.conf /etc/nginx/conf.d/default.conf

# Copier la config Supervisord
COPY supervisord.conf /etc/supervisor/conf.d/supervisord.conf

# Exposer le port 80
EXPOSE 80

# Lancer Supervisord
CMD ["/usr/bin/supervisord", "-c", "/etc/supervisor/conf.d/supervisord.conf"]

