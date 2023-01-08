FROM docker.io/library/alpine:latest
LABEL "copyright"="&copy 2023 Philip aka RobertoTorino"
LABEL version="1.0"
LABEL description="oceanblue"
LABEL maintainer="Philip aka RobertoTorino"
COPY . /usr/share/nginx/html
EXPOSE 80/tcp
RUN apk update && apk add nginx && apk add nano && apk add curl shadow bind-tools tcpdump
RUN mkdir -p /run/nginx && mkdir -p /etc/nginx/conf.d && mkdir -p etc/nginx/sites-available && touch !$/default
COPY nginx/nginx.conf /etc/nginx
COPY nginx/health-check.conf /etc/nginx/conf.d/health-check.conf
CMD ["nginx", "-g", "daemon off;"]
HEALTHCHECK --interval=1m --timeout=3s CMD curl -f http://localhost/ || exit 1
