FROM nginx:1.27.0

WORKDIR /usr/share/nginx/html

COPY src/index.html .

RUN sed -i "s/\$HOSTNAME/$HOSTNAME/g; s/\$IP_ADDR/$IP_ADDR/g" index.html
