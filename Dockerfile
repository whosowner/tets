FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
    apt install -y dropbear python3 passwd && \
    apt clean

# Create dummy index page
RUN mkdir -p /app && echo "SSHx Session Running..." > /app/index.html
WORKDIR /app

# Generate RSA host key
RUN mkdir -p /etc/dropbear && \
    dropbearkey -t rsa -f /etc/dropbear/dropbear_rsa_host_key

# Create root user and set password
RUN echo "root:toor" | chpasswd

# Optional: Custom shell prompt
RUN echo 'export PS1="root@hyperclouds:~# "' >> /root/.bashrc

# Expose ports
EXPOSE 22
EXPOSE 6080

# Start dummy web server and Dropbear SSH server
CMD python3 -m http.server 6080 & \
    dropbear -E -F -p 22 -r /etc/dropbear/dropbear_rsa_host_key
