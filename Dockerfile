#此image在https://github.com/lennyhuanga/hadoopwithdocker
FROM lenny/hadoop:2.7.2

MAINTAINER lennyhuang <524180539@qq.com>

WORKDIR /root


# install hive 2.3.4
RUN wget http://mirror.bit.edu.cn/apache/hive/hive-2.3.4/apache-hive-2.3.4-bin.tar.gz  && \
    tar -xzvf apache-hive-2.3.4-bin.tar.gz && \
    mv apache-hive-2.3.4-bin /usr/local/hive && \
    rm apache-hive-2.3.4-bin.tar.gz

# set environment variable

ENV HIVE_HOME=/usr/local/hive
ENV PATH=$PATH:$HIVE_HOME/bin


#hive-site.xml 中使用
RUN mkdir -p /home/hadoop/hive/tmp 

# 拷贝配置文件
COPY config/* /tmp/

RUN mv /tmp/hive-env.sh $HIVE_HOME/conf/hive-site.sh && \
	mv /tmp/hive-site.xml $HIVE_HOME/conf/hive-site.xml && \
   	mv /tmp/hive-log4j2.properties $HIVE_HOME/conf/hive-log4j2.properties && \ 
    mv /tmp/hive-exec-log4j2.properties $HIVE_HOME/conf/hive-exec-log4j2.properties && \ 
	mv /tmp/mysql-connector-java-5.1.41-bin.jar $HIVE_HOME/lib/mysql-connector-java-5.1.41-bin.jar 

#初始化hive 会报错，在容器启动完成后再去执行。
#RUN schematool -dbType mysql -initSchema

# 启动hive
#RUN hive

CMD [ "sh", "-c", "service ssh start; bash"]
