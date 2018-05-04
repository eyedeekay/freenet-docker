FROM debian:sid
ARG TAG
ENV USER=freenet HOME=/var/lib/freenet DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y default-jre-headless service-wrapper libbcprov-java wget cron
RUN addgroup --system -gid 1000 freenet
RUN adduser --system --uid 1000 --gid 1000 --home /var/run/freenet --gecos ',,,,' freenet
RUN mkdir -p /var/run/freenet /var/lib/freenet && \
    chown -R freenet:freenet /var/lib/freenet /var/run/freenet && \
    chmod ug+rwx /var/lib/freenet /var/run/freenet
RUN wget "https://github.com/freenet/fred/releases/download/build0${TAG}/new_installer_offline_${TAG}.jar" -O new_installer_offline.jar
COPY setup.sh /bin/setup.sh
USER freenet
WORKDIR /var/lib/freenet
RUN setup.sh
COPY freenet.ini /var/lib/freenet/freenet.ini
EXPOSE 9481 8888
WORKDIR /var/run/freenet
CMD /var/lib/freenet/run.sh console | tee -a freenet.log
