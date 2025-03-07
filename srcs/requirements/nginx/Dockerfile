FROM debian:bullseye

RUN apt update -y && apt upgrade -y && \
    apt install nginx -y && \
    apt install curl -y && \
    apt install openssl -y

COPY ./tools/setup.sh /setup.sh

RUN chmod +x /setup.sh && /setup.sh

CMD [ "nginx", "-g", "daemon off;" ]