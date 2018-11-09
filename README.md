hive 的安装依赖于hadoop ，上节基于docker的hadoop安装参见https://github.com/lennyhuanga/hadoopwithdocker
所以hive的安装是在hadoop的image基础上进行的。

第一步  完成hadoop的iamge构建
按照https://github.com/lennyhuanga/hadoopwithdocker 完成hadoop 的image 构建

第二步 完成mysql的构建

1、采用mysql5.7，为了docker 源速度，从阿里拉取
docker pull registry.cn-hangzhou.aliyuncs.com/acs-sample/mysql:5.7
2、docker images 查看已存在的镜像
3、重新打tag ，原有tag太长
docker tag registry.cn-hangzhou.aliyuncs.com/acs-sample/mysql:5.7 mysql:5.7 
4、构建mysql 容器
  # mysql启动时使用跟hadoop相同的网络分组
  docker network ls # 查看docker 所有的网络设置
  docker inspect b3b|grep IPAddress  # 查看hadoop 所使用的网络设置
  docker run --name mysql -e MYSQL_ROOT_PASSWORD=123456 --net hadoop -p 3306:3306  -d mysql:5.7

第三步 完成hive的安装和配置 参考https://www.cnblogs.com/liujinhong/p/8795387.html 安装过程
  首先 ：git clone https://github.com/lennyhuanga/docker-hive
1、hive的安装我们直接使用Dockerfile完成，里边不包括启动
2、所有的配置文件预先改好放在config文件夹
  其中mysql-connector-java-5.1.41-bin.jar是连接mysql的jdbc 驱动
  再就是注意hive-site.xml 里的相关配置
3、./build-image.sh 构建image
4、./start-container.sh 启动容器
5、进入容器中（默认自动进入了hadoop master节点（hive所在的节点））运行 ./start-hadoop.sh
6、jps 查看hadoop是否启动成功
7、初始化hive的数据源为mysql 
  schematool -dbType mysql -initSchema
8、hive 命令 启动hive

常见错误大全：
1、hive 启动时报 Relative path in absolute URI: ${system:java.io.tmpdir%7D/$%7Bhive.session.id%7D_resources
原因再hive-site.xml 文件夹中所有的${system:java.io.tmpdir} 改掉，hadoop 不支持${system:java.io.tmpdir}  这种带：的表达式
把{system:java.io.tmpdir} 改成 /home/hadoop/hive/tmp/
把 {system:user.name} 改成 {user.name}
2、schematool -dbType mysql -initSchema 初始化数据源时
Error: Duplicate key name 'PCS_STATS_IDX' (state=42000,code=1061) ----Hive schematool -initSchema
以上错误查看mysql是否已经创建了hive这个表, 如果创建，你想从新安装的话，把那个你创建的表删了即可


