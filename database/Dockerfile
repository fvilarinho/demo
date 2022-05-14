# Define the base linux distribution.
FROM alpine:latest

# Define the maintainer of the project.
LABEL maintainer="fvilarinho@gmail.com"

# Default environment variables.
ENV MYSQL_ROOT_PASSWORD=demo
ENV HOME_DIR=/home/user
ENV ETC_DIR=${HOME_DIR}/etc
ENV BIN_DIR=${HOME_DIR}/bin
ENV SQL_DIR=${HOME_DIR}/sql

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
    mkdir -p ${SQL_DIR} ${BIN_DIR} ${ETC_DIR} && \
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
    ln -s ${SQL_DIR} /opt/flyway/sql

# Copy the default configurations, database scripts and boot script.
COPY bin/startup.sh ${BIN_DIR}
COPY etc/my.cnf ${ETC_DIR}
COPY etc/flyway.conf ${ETC_DIR}
COPY sql/* ${SQL_DIR}/

# Set the startup.
RUN chown -R user:group ${HOME_DIR} && \
    chmod -R o-rwx ${HOME_DIR} && \
    chmod +x ${BIN_DIR}/*.sh && \
    ln -s ${ETC_DIR}/flyway.conf /opt/flyway/conf/flyway.conf && \
    ln -s ${ETC_DIR}/my.cnf /etc/my.cnf && \
    ln -s ${BIN_DIR}/startup.sh /entrypoint.sh

# Set default work directory.
WORKDIR ${HOME_DIR}

# Set the default port.
EXPOSE 3306

# Boot script
ENTRYPOINT ["/entrypoint.sh"]
