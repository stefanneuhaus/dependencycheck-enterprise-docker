FROM mysql:5.7.20

LABEL maintainer="Stefan Neuhaus <stefan@stefanneuhaus.org>"

ENV MYSQL_DATABASE ${databaseName}
ENV MYSQL_ROOT_PASSWORD ${databaseRootPassword}

WORKDIR ${installDirectory}


RUN echo "deb http://http.debian.net/debian jessie-backports main" >/etc/apt/sources.list.d/jessie-backports.list \
  && apt-get update \
  && apt-get install -y -t jessie-backports \
    openjdk-8-jre-headless \
    cron \
    vim \
  && apt-get purge -y --auto-remove \
  && rm -rf /var/lib/apt/lists/* \
  && echo "alias ll='ls -l'" >>/root/.bashrc


COPY build-context/gradle/wrapper/* ${installDirectory}/gradle/wrapper/
COPY build-context/gradlew ${installDirectory}

RUN ${installDirectory}/gradlew --no-daemon wrapper


RUN echo "${cronUpdateSchedule}  ${installDirectory}/update.sh" > /etc/cron.d/dependencycheck-database-update \
  && crontab /etc/cron.d/dependencycheck-database-update


COPY build-context/initialize.sql ${installDirectory}
COPY build-context/initialize.sh /docker-entrypoint-initdb.d/

COPY build-context/database.gradle ${installDirectory}
COPY build-context/update.sh ${installDirectory}

COPY build-context/wrapper.sh /wrapper.sh


EXPOSE 3306

CMD ["/wrapper.sh"]
