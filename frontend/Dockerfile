# Define the base linux distribution.
FROM alpine:3.15.3

# Define the maintainer of the project.
LABEL maintainer="fvilarinho@gmail.com"

# Install essential packages.
RUN apk update && \
    apk add bash \
            curl \
            nginx

# Install the required directories.
RUN addgroup -S group && \
    adduser -S user -G group && \
    mkdir -p /home/user/etc && \
    mkdir -p /home/user/bin && \
    mkdir -p /run/nginx && \
    rm -rf /etc/nginx/http.d/default.conf

# Copy the default configurations and boot script.
COPY bin/startup.sh /home/user/bin/startup.sh
COPY etc/nginx /home/user/etc/nginx

# Set the startup.
RUN chmod +x /home/user/bin/*.sh && \
    chown -R user:group /home/user && \
    chmod -R o-rwx /home/user && \
    ln -s /home/user/etc/nginx/conf.d/default.conf /etc/nginx/http.d/default.conf && \
    ln -s /home/user/etc/nginx/ssl /etc/nginx/ssl && \
    ln -s /home/user/bin/startup.sh /entrypoint.sh

# Set default work directory.
WORKDIR /home/user

# Set the default port.
EXPOSE 80 443

# Boot script.
ENTRYPOINT ["/entrypoint.sh"]
