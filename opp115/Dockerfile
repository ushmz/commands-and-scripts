FROM mysql:8.0

RUN apt-get update
RUN apt-get -y install locales-all

ENV LANG ja_JP.UTF-8
ENV LANGUAGE ja_JP:ja
ENV LC_ALL ja_JP.UTF-8

ENV MYSQL_ROOT_PASSWORD rootpass
ENV MYSQL_DATABASE opp115
ENV MYSQL_USER opp115
ENV MYSQL_PASSWORD opp115

COPY ./my.conf /etc/mysql/conf.d/my.cnf
