# Etapa 1 — compilar
FROM ghcr.io/cirruslabs/flutter:stable AS builder

# Evitar el warning de root
ENV FLUTTER_SUPPRESS_ANALYTICS=true
ENV PUB_CACHE=/tmp/pub_cache

WORKDIR /app
COPY . .

# Verificar que pubspec.yaml existe
RUN ls -la && cat pubspec.yaml | head -5

RUN flutter config --enable-web --no-analytics
RUN flutter pub get
RUN flutter build web --release

# Etapa 2 — servir con nginx
FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
