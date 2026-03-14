FROM debian:bullseye
RUN apt-get update && apt-get upgrade -y && \
    apt-get install -y --no-install-recommends \
    mariadb-server \
    mariadb-client \
    && rm -rf /var/lib/apt/lists/* \
    && rm -rf /var/lib/mysql/*

RUN mkdir -p /var/run/mysqld && \
    chown -R mysql:mysql /var/run/mysqld && \
    chmod 777 /var/run/mysqld

COPY tools/mariadb.sh /mariadb.sh
RUN chmod +x /mariadb.sh
EXPOSE 3306
ENTRYPOINT ["/mariadb.sh"]
CMD ["mysqld"]