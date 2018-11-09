#此image在https://github.com/lennyhuanga/hadoopwithdocker
FROM lenny/hadoop:2.7.2

MAINTAINER lennyhuang <524180539@qq.com>

WORKDIR /root


# install hive 2.3.4
RUN wget http://mirror.bit.edu.cn/apache/hive/hive-2.3.4/apache-hive-2.3.4-bin.tar.gz  && \
    tar -xzvf apache-hive-2.3.4-bin.tar.gz && \
    mv apache-hive-2.3.4-bin /usr/local/hive && \
    rm apache-hive-2.3.4-bin.tar.gz
	
# install sqoop 1.4.7
RUN wget http://www.us.apache.org/dist/sqoop/1.4.7/sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz && \
    tar -xzvf sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz && \
    mv sqoop-1.4.7.bin__hadoop-2.6.0  /usr/local/sqoop && \
    rm sqoop-1.4.7.bin__hadoop-2.6.0.tar.gz

# set environment variable

ENV HIVE_HOME=/usr/local/hive
ENV PATH=$PATH:$HIVE_HOME/bin
ENV SQOOP_HOME=/usr/local/sqoop
ENV PATH=$PATH:$SQOOP_HOME/bin


#hive-site.xml 中使用
RUN mkdir -p /home/hadoop/hive/tmp 

# 拷贝配置文件
COPY config/* /tmp/

#将sqoop-1.4.7.jar放入$SQOOP_HOME/lib不然接下来会报错（不信你试试= =）
RUN mv /tmp/hive-env.sh $HIVE_HOME/conf/hive-site.sh && \
	cp  /tmp/hive-site.xml $HIVE_HOME/conf/hive-site.xml && \
   	mv /tmp/hive-log4j2.properties $HIVE_HOME/conf/hive-log4j2.properties && \ 
    mv /tmp/hive-exec-log4j2.properties $HIVE_HOME/conf/hive-exec-log4j2.properties && \ 
	cp  /tmp/mysql-connector-java-5.1.41-bin.jar $HIVE_HOME/lib/mysql-connector-java-5.1.41-bin.jar && \ 
mv /tmp/mysql-connector-java-5.1.41-bin.jar $SQOOP_HOME/lib/mysql-connector-java-5.1.41-bin.jar && \ 
	mv /tmp/sqoop-1.4.7.jar  $SQOOP_HOME/lib/sqoop-1.4.7.jar	&& \ 
mv /tmp/hive-site.xml $SQOOP_HOME/conf/hive-site.xml && \
	mv /tmp/sqoop-env.sh $SQOOP_HOME/conf/sqoop-env.sh
	

#初始化hive 会报错，在容器启动完成后再去执行。
#RUN schematool -dbType mysql -initSchema

# 启动hive
#RUN hive

CMD [ "sh", "-c", "service ssh start; bash"]
