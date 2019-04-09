FROM registry.cn-beijing.aliyuncs.com/dxq_docker/base
LABEL author=dxq1994@gmail.com
RUN set -x \
	&& addgroup -g 82 -S mysql \
	&& adduser -u 82 -D -S -G mysql mysql \
	&& chmod 777 /tmp
RUN apk add --update mariadb mariadb-client && rm -f /var/cache/apk/*
EXPOSE 3306
COPY start.sh /start.sh
RUN chmod a+x /start.sh
COPY my.cnf /etc/mysql/my.cnf
CMD ["/start.sh"]
