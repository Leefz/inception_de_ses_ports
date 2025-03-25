FROM debian:bullseye

RUN apt update && apt upgrade -y && apt install -y mariadb-server

COPY ./tools/setup.sh /setup.sh
     
RUN chmod +x /setup.sh

ENTRYPOINT [ "/setup.sh" ]