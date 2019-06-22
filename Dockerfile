FROM registry.cn-beijing.aliyuncs.com/dxq_docker/base
LABEL author=dxq1994@gmail.com
RUN set -x \
	&& addgroup -g 82 -S mysql \
	&& adduser -u 82 -D -S -G mysql mysql \
	&& chmod 777 /tmp
RUN apk add --no-cache mysql && rm -f /var/cache/apk/*
EXPOSE 3306
COPY start.sh /start.sh
RUN chmod a+x /start.sh
#COPY my.cnf /etc/mysql/my.cnf
# 健康检查 --interval检查的间隔 超时timeout retries失败次数
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD ps -a | grep mysql || exit 1
CMD ["/start.sh"]
