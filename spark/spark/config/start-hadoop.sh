#!/bin/bash
# 依次启动 HDFS 和 YARN 集群
$HADOOP_HOME/sbin/start-dfs.sh
$HADOOP_HOME/sbin/start-yarn.sh