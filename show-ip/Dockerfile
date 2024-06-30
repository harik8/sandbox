FROM nginx:1.27.0

RUN sed -i "s/\$HOSTNAME/$HOSTNAME/g; s/\$IP_ADDR/$IP_ADDR/g" index.html
 
COPY src/index.html /usr/share/nginx/html/index.html

