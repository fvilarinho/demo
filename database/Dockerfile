# Define the base linux distribution.
FROM alpine:3.15.4

# Define the maintainer of the project.
LABEL maintainer="fvilarinho@gmail.com"

# Default environment variables.
ENV MYSQL_ROOT_PASSWORD=demo

# Install essential packages.
RUN apk update && \
    apk add bash \
            libxml2 \
            mariadb \
            mariadb-client \
            nss \
            openjdk11-jre

# Install the required directories.
RUN addgroup -S group && \
    adduser -S user -G group && \
    mkdir -p /home/user/etc && \
    mkdir -p /home/user/bin && \
    mkdir -p /home/user/sql && \
    mkdir -p /var/run/mysqld && \
    mkdir -p /var/lib/mysql && \
    mkdir -p /var/log/mysql && \
    rm -f /etc/my.cnf

# Install the version control.
RUN wget -qO- https://repo1.maven.org/maven2/org/flywaydb/flyway-commandline/7.2.0/flyway-commandline-7.2.0-linux-x64.tar.gz | tar xvz && \
    mv ./flyway-7.2.0 /opt && \
    ln -s /opt/flyway-7.2.0 /opt/flyway && \
    rm -rf /opt/flyway/sql && \
    rm -rf /opt/flyway/jre && \
    rm -f /opt/flyway/conf/flyway.conf && \
    ln -s /opt/flyway/flyway /usr/local/bin && \
    ln -s /home/user/sql /opt/flyway/sql

# Copy the default configurations, database scripts and boot script.
COPY bin/startup.sh /home/user/bin/startup.sh
COPY etc/my.cnf /home/user/etc/
COPY etc/flyway.conf /home/user/etc/
COPY sql/* /home/user/sql/

# Set the startup.
RUN chmod +x /home/user/bin/*.sh && \
    chown -R user:group /home/user && \
    chmod -R o-rwx /home/user && \
    ln -s /home/user/etc/flyway.conf /opt/flyway/conf/flyway.conf && \
    ln -s /home/user/etc/my.cnf /etc/my.cnf && \
    ln -s /home/user/bin/startup.sh /entrypoint.sh

# Set default work directory.
WORKDIR /home/user

# Set the default port.
EXPOSE 3306

# Boot script
ENTRYPOINT ["/entrypoint.sh"]
