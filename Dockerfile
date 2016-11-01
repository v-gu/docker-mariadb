FROM lisnaz/archlinux

MAINTAINER Vincent Gu <0x6c34@gmail.com>

ENV MYSQL_ALLOW_EMPTY_PASSWORD="yes" \
    MYSQL_DATADIR=/var/lib/mysql \
    MYSQL_EXEC_USER=mysql \
    MYSQL_EXEC=mysqld

RUN yaourt -S -q --noconfirm mariadb mariadb-clients \
  && echo -n "yaourt -Scc:" && echo -n "Y" | yaourt -Scc  --noconfirm \
  && rm -rf ${MYSQL_DATADIR}/* \
  && sed -Ei 's/^(bind-address|log)/#&/' /etc/mysql/my.cnf \
  && printf 'skip-host-cache\nskip-name-resolve\n' | awk '{ print } $1 == "[mysqld]" && c == 0 { c = 1; system("cat") }' /etc/mysql/my.cnf > /tmp/my.cnf \
  && mv /tmp/my.cnf /etc/mysql/my.cnf

COPY entrypoint.sh /entrypoint.sh

EXPOSE 3306
VOLUME /var/lib/mysql

ENTRYPOINT ["/entrypoint.sh"]
CMD ["mysqld"]
