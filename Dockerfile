FROM lenny/hadoop:2.7.2

MAINTAINER lennyhuang <524180539@qq.com>

WORKDIR /root


# install hive 2.3.4
RUN wget http://mirror.bit.edu.cn/apache/hive/hive-2.3.4/apache-hive-2.3.4-bin.tar.gz
&& \
    tar -xzvf apache-hive-2.3.4-bin.tar.gz && \
    mv apache-hive-2.3.4-bin /usr/local/hive && \
    rm apache-hive-2.3.4-bin.tar.gz

# set environment variable

export HIVE_HOME=/usr/local/hive
export PATH=$PATH:$HIVE_HOME/bin

source /etc/profile 

#hive-site.xml 中使用
RUN mkdir /home/hadoop/hive/tmp 

# 在hdfs 中创建下面的目录 ，并且授权
RUN hdfs dfs -mkdir -p /user/hive/warehouse && \
	hdfs dfs -mkdir -p /user/hive/tmp && \
	hdfs dfs -mkdir -p /user/hive/log && \
	hdfs dfs -chmod -R 777 /user/hive/warehouse && \
	hdfs dfs -chmod -R 777 /user/hive/tmp && \
	hdfs dfs -chmod -R 777 /user/hive/log

# 拷贝配置文件
COPY config/* /tmp/

RUN mv /tmp/hive-env.sh $HIVE_HOME/conf/hive-site.sh && \
	mv /tmp/hive-site.xml $HIVE_HOME/conf/hive-site.xml && \
   	mv /tmp/hive-log4j2.properties $HIVE_HOME/conf/hive-log4j2.properties && \ 
    mv /tmp/hive-exec-log4j2.properties $HIVE_HOME/conf/hive-exec-log4j2.properties

#初始化hive
RUN schematool -dbType mysql -initSchema

# 启动hive
RUN hive

CMD [ "sh", "-c", "service ssh start; bash"]
