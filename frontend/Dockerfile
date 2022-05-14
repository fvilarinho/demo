# Define the base linux distribution.
FROM alpine:latest

# Define the maintainer of the project.
LABEL maintainer="fvilarinho@gmail.com"

# Default environment variables.
ENV HOME_DIR=/home/user
ENV ETC_DIR=${HOME_DIR}/etc
ENV BIN_DIR=${HOME_DIR}/bin

# Install essential packages.
RUN apk update && \
    apk add bash \
            curl \
            nginx

# Install the required directories.
RUN addgroup -S group && \
    adduser -S user -G group && \
    mkdir -p ${ETC_DIR} ${BIN_DIR} && \
    mkdir -p /run/nginx && \
    rm -rf /etc/nginx/http.d/default.conf

# Copy the default configurations and boot script.
COPY bin/startup.sh ${BIN_DIR}/startup.sh
COPY etc/nginx ${ETC_DIR}/nginx

# Set the startup.
RUN chown -R user:group ${HOME_DIR} && \
    chmod -R o-rwx ${HOME_DIR} && \
    chmod +x ${BIN_DIR}/*.sh && \
    ln -s ${ETC_DIR}/nginx/conf.d/default.conf /etc/nginx/http.d/default.conf && \
    ln -s ${ETC_DIR}/nginx/ssl /etc/nginx/ssl && \
    ln -s ${BIN_DIR}/startup.sh /entrypoint.sh

# Set default work directory.
WORKDIR ${HOME_DIR}

# Set the default port.
EXPOSE 80 443

# Boot script.
ENTRYPOINT ["/entrypoint.sh"]