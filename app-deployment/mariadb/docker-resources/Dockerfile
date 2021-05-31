FROM mariadb:10.5.8

COPY chatty.sql /docker-entrypoint-initdb.d/
CMD ["mysqld"]
