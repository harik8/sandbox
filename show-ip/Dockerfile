FROM nginx:1.27.0

WORKDIR /usr/share/nginx/html

COPY src/index.html .
COPY src/nginx.conf /etc/nginx/conf.d/default.conf

# COPY src/stub_status.html /etc/nginx/html/stub_status.html