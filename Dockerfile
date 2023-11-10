FROM xeroxcom/xcom-apache-secure

# Put logs in /var/logs/apache (later to be handled with a volume)
#RUN mkdir /var/log/apache

#COPY ./apache/htdocs /usr/local/apache2/htdocs
#COPY ./apache/conf /usr/local/apache2/conf

COPY ./httpd/conf /etc/httpd/conf
COPY ./httpd/conf.d /etc/httpd/conf.d