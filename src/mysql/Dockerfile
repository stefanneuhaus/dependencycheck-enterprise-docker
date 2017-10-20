FROM mysql:5.7.20

LABEL maintainer="Stefan Neuhaus <stefan@stefanneuhaus.org>"

ENV MYSQL_DATABASE ${databaseName}
ENV MYSQL_ROOT_PASSWORD ${databaseRootPassword}

WORKDIR ${installDirectory}


RUN echo "deb http://http.debian.net/debian jessie-backports main" >/etc/apt/sources.list.d/jessie-backports.list && \
    apt-get update && \
    apt-get install -y -t jessie-backports \
        openjdk-8-jre-headless \
        cron \
        vim && \
    apt-get purge -y --auto-remove && \
    rm -rf /var/lib/apt && \
    echo "alias ll='ls -l'" >>/root/.bashrc


COPY gradle/wrapper/* ${installDirectory}/gradle/wrapper/
COPY gradlew ${installDirectory}

RUN ${installDirectory}/gradlew --no-daemon wrapper


RUN echo "${cronUpdateSchedule}  ${installDirectory}/update.sh" > /etc/cron.d/dependencycheck-database-update && \
    crontab /etc/cron.d/dependencycheck-database-update


COPY initialize.sql ${installDirectory}
COPY initialize.sh /docker-entrypoint-initdb.d/

COPY database.gradle ${installDirectory}
COPY update.sh ${installDirectory}

COPY wrapper.sh /wrapper.sh


EXPOSE 3306

CMD ["/wrapper.sh"]
