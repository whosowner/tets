FROM ubuntu:22.04

# Install dependencies
RUN apt update && \
    apt install -y python3 screen && \
    apt clean

# Create dummy index page
RUN mkdir -p /app && echo "Shell Session Running..." > /app/index.html
WORKDIR /app

# Optional: Custom shell prompt
RUN echo 'export PS1="root@hyperclouds:~# "' >> /root/.bashrc

# Expose fake web port to keep Railway alive
EXPOSE 6080

# Start dummy web server and launch shell in screen
CMD python3 -m http.server 6080 & \
    screen -dmS shell bash && \
    tail -f /dev/null
