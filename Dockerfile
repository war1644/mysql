FROM registry.cn-beijing.aliyuncs.com/dxq_docker/base
LABEL author=dxq1994@gmail.com
# 回滚10.1.22可能解决共享卷问题 忽略无关紧要的error
RUN apk add --no-cache -X https://mirrors.aliyun.com/alpine/v3.7/main mariadb=10.1.40-r0 && \
	addgroup mysql mysql \
	;exit 0
	
EXPOSE 3306
COPY start.sh /start.sh
RUN chmod a+x /start.sh
#COPY my.cnf /etc/mysql/my.cnf
# 健康检查 --interval检查的间隔 超时timeout retries失败次数
HEALTHCHECK --interval=30s --timeout=3s --retries=3 \
    CMD ps -a | grep mysql || exit 1
CMD ["/start.sh"]
