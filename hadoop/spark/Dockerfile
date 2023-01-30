FROM docker.io/bitnami/spark:3.3
LABEL description="Docker image with Spark (3.3.1) and Hadoop (3.3.2), based on bitnami/spark:3.3 ."

USER root

# 设置 Hadoop 环境变量
ENV HADOOP_HOME="/opt/hadoop"
ENV HADOOP_CONF_DIR="$HADOOP_HOME/etc/hadoop"
ENV HADOOP_LOG_DIR="/var/log/hadoop"
ENV PATH="$HADOOP_HOME/sbin:$HADOOP_HOME/bin:$PATH"

WORKDIR /opt

# 更换镜像源
# RUN sed -i 's/deb.debian.org/mirrors.ustc.edu.cn/g' /etc/apt/sources.list
RUN mv /etc/apt/sources.list /etc/apt/sources.list.backup && \
    echo "deb http://mirrors.ustc.edu.cn/debian stable main contrib non-free" >> /etc/apt/sources.list && \
    echo "# deb-src http://mirrors.ustc.edu.cn/debian stable main contrib non-free" >> /etc/apt/sources.list && \
    echo "deb http://mirrors.ustc.edu.cn/debian stable-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "# deb-src http://mirrors.ustc.edu.cn/debian stable-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "# deb http://mirrors.ustc.edu.cn/debian stable-proposed-updates main contrib non-free" >> /etc/apt/sources.list && \
    echo "# deb-src http://mirrors.ustc.edu.cn/debian stable-proposed-updates main contrib non-free" >> /etc/apt/sources.list

# 安装 SSH 服务和 curl
RUN apt-get update && \ 
    apt-get install -y openssh-server && \
    apt-get install -y curl

# 配置免密登陆
RUN ssh-keygen -t rsa -f /root/.ssh/id_rsa -P '' && \
    cat /root/.ssh/id_rsa.pub >> /root/.ssh/authorized_keys

# 下载安装 Hadoop
RUN curl -OL https://mirrors.ustc.edu.cn/apache/hadoop/common/hadoop-3.3.2/hadoop-3.3.2.tar.gz
RUN tar -zxvf hadoop-3.3.2.tar.gz && \
    mv hadoop-3.3.2 hadoop && \
    rm -rf hadoop-3.3.2.tar.gz && \
    mkdir /var/log/hadoop
  
# 创建 HDFS NameNode 和 DataNode 工作目录
RUN mkdir -p /root/hdfs/namenode && \
    mkdir -p /root/hdfs/datanode 

COPY config/* /tmp/

# 拷贝文件，并覆盖 $HADOOP_CONF_DIR 目录下的 Hadoop 配置文件
RUN mv /tmp/ssh_config /etc/ssh/ssh_config.d/my_ssh.conf && \
    mv /tmp/start-hadoop.sh /opt/start-hadoop.sh && \
    mv /tmp/hadoop-env.sh $HADOOP_CONF_DIR/hadoop-env.sh && \
    mv /tmp/hdfs-site.xml $HADOOP_CONF_DIR/hdfs-site.xml && \ 
    mv /tmp/core-site.xml $HADOOP_CONF_DIR/core-site.xml && \
    mv /tmp/mapred-site.xml $HADOOP_CONF_DIR/mapred-site.xml && \
    mv /tmp/yarn-site.xml $HADOOP_CONF_DIR/yarn-site.xml && \
    mv /tmp/workers $HADOOP_CONF_DIR/workers

# 设置为可执行文件
RUN chmod +x /opt/start-hadoop.sh && \
    chmod +x $HADOOP_HOME/sbin/start-dfs.sh && \
    chmod +x $HADOOP_HOME/sbin/start-yarn.sh

# 格式化 HDFS 文件系统
RUN hdfs namenode -format

ENTRYPOINT [ "/opt/bitnami/scripts/spark/entrypoint.sh" ]
CMD [ "/opt/bitnami/scripts/spark/run.sh" ]