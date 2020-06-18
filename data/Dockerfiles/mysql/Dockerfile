FROM mariadb:10.1
MAINTAINER Nikolay Ivanov <nikolay@appsofart.com>
#reduce the max connection to 2 only, because we got out of memory
RUN sed -i 's/^max_connections.*/max_connections \t= 30/' /etc/mysql/my.cnf
RUN sed -i 's/^connect_timeout.*/connect_timeout \t= 20/' /etc/mysql/my.cnf

