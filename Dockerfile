FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
    apt install -y dropbear python3 && \
    apt clean

# Create dummy index page
RUN mkdir -p /app && echo "SSHx Session Running..." > /app/index.html
WORKDIR /app

# Set up Dropbear SSH server
RUN mkdir -p /etc/dropbear && \
    echo "root:x:0:0:root:/root:/bin/bash" > /etc/passwd && \
    echo "root::0:0:root:/root:/bin/bash" > /etc/shadow && \
    mkdir -p /root/.ssh && \
    chmod 700 /root/.ssh

# Add your public key for access (replace with your actual key)
RUN echo "ssh-rsa AAAA... your_key_here" > /root/.ssh/authorized_keys && \
    chmod 600 /root/.ssh/authorized_keys

# Expose fake web port to keep Railway alive
EXPOSE 6080
EXPOSE 22

# Start dummy web server and Dropbear SSH server
CMD python3 -m http.server 6080 & \
    dropbear -E -F -p 22
