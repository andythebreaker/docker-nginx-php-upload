FROM richarvey/nginx-php-fpm:latest
RUN mkdir -p /run/nginx
RUN apk add --no-cache nginx-mod-http-lua
ENV PHP_UPLOAD_MAX_FILESIZE 10000
ENV PHP_POST_MAX_SIZE 10000
ENV PHP_MEM_LIMIT 10000
ENV RUN_SCRIPTS 1
RUN mkdir -p /var/www/html/uploads /var/www/html/conf/nginx/ /var/www/html/scripts /data
COPY nginx.conf /var/www/html/conf/nginx/
COPY index.php /var/www/html/
COPY upload_dir.sh /var/www/html/scripts/
RUN apk add --no-cache --update nodejs npm
RUN npm install -g pubhtmlhere
RUN apk add --no-cache --update tmux
RUN sed -i '$ d' /start.sh
RUN sed -i '$ d' /start.sh
RUN echo "tmux new-session -d -s autotests -n onlywindows" >> "/start.sh"
RUN echo "tmux send-keys -t autotests:onlywindows 'cd /var/www/html' Enter" >> "/start.sh"
RUN echo "tmux send-keys -t autotests:onlywindows 'pubhtml up -p 48748' Enter" >> "/start.sh"
RUN echo "exec /usr/bin/supervisord -n -c /etc/supervisord.conf" >> "/start.sh"

EXPOSE 48748
