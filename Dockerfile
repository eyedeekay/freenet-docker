FROM debian:sid
ARG TAG
ENV USER=freenet HOME=/var/lib/freenet DEBIAN_FRONTEND=noninteractive
RUN apt-get update
RUN apt-get install -y default-jre-headless service-wrapper libbcprov-java wget cron
RUN addgroup --system -gid 1000 freenet
RUN adduser --system --uid 1000 --gid 1000 --home /var/lib/freenet --gecos ',,,,' freenet
RUN chown -R freenet:freenet /var/lib/freenet && chmod ug+rwx /var/lib/freenet
RUN wget "https://github.com/freenet/fred/releases/download/build0${TAG}/new_installer_offline_${TAG}.jar" -O new_installer_offline.jar
COPY setup.sh /bin/setup.sh
USER freenet
WORKDIR /var/lib/freenet
RUN setup.sh
RUN ls /var/lib/freenet/
CMD /var/lib/freenet/run.sh console | tee -a freenet.log
