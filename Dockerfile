FROM php:8.4

# definition de l'espace de travail
WORKDIR /project
#copie du projet app dans project
COPY app/ .
#installation des dependances
RUN apt update && apt install -y\
	libfreetype-dev\
	libjpeg62-turbo-dev\
	libpng-dev\
	libpq-dev\
	zip unzip \
&& docker-php-ext-install bcmath pgsql pdo_pgsql pdo \
#&& apt install php:8.4\
&& php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"\
&& php composer-setup.php\
&& php -r "unlink('composer-setup.php');"\
&& mv composer.phar /usr/local/bin/composer

EXPOSE 8000

RUN adduser www \
&& usermod -aG www www


#generation des clé 

RUN chmod u+x /project/entrypoint.sh\
&& composer install\
&& php artisan key:gen
#&& php migrate 

RUN chown -R www:www /project \
&& chmod -R 775 /project/storage

USER www

#ENTRYPOINT ["/bin/bash"]
#start main process
#ENTRYPOINT ["sleep 10000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000"]
ENTRYPOINT ["php", "artisan", "serve", "--host", "0.0.0.0"]
