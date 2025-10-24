FROM nginx:1.27.0

WORKDIR /usr/share/nginx/html

COPY src/index.html .

COPY src/stub_status.conf /etc/nginx/conf.d/stub_status.conf