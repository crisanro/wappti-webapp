# Etapa 1 — compilar
FROM ghcr.io/cirruslabs/flutter:stable AS builder
WORKDIR /app
COPY . .
RUN flutter config --enable-web
RUN flutter pub get
RUN flutter build web --release

# Etapa 2 — servir con nginx
FROM nginx:alpine
COPY --from=builder /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
