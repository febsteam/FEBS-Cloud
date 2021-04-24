#!/usr/bin/env bash

echo  -e "\n本脚本运行中可能使用Maven, nodejs, docker, docker compose（press any key to continue...）"
read tmp1

mv /FEBS-Cloud /febs
chmod 777 -R /febs
sysctl -w vm.max_map_count=262144

#elasticsearch配置
rm -rf "/febs/elasticsearch"
mkdir -p "/febs/elasticsearch/data"
mkdir -p "/febs/elasticsearch/plugins"
mkdir -p "/febs/elasticsearch/logs"
cp "/febs/febs-apm/skywalking-elk/elasticsearch.yml" "/febs/elasticsearch/elasticsearch.yml"
chmod -R 777 "/febs/elasticsearch"

#logstash配置
rm -rf "/febs/logstash"
mkdir -p "/febs/logstash"
cp "/febs/febs-apm/skywalking-elk/logstash-febs.conf" "/febs/logstash/logstash-febs.conf"

#skywalking配置
rm -rf "/febs/skywalking/config"
mkdir -p "/febs/skywalking/config"
cp "/febs/febs-apm/skywalking-elk/skywalking_application.yml" "/febs/skywalking/config/skywalking_application.yml"

#Prometheus配置
rm -rf "/febs/prometheus"
mkdir -p "/febs/prometheus"
cp "/febs/febs-apm/prometheus-grafana/prometheus.yml" "/febs/prometheus/prometheus.yml"
cp "/febs/febs-apm/prometheus-grafana/memory_over.yml" "/febs/prometheus/memory_over.yml"
cp "/febs/febs-apm/prometheus-grafana/server_down.yml" "/febs/prometheus/server_down.yml"
cp "/febs/febs-apm/prometheus-grafana/more_rules.yml" "/febs/prometheus/more_rules.yml"

#alertmanager配置
rm -rf "/febs/alertmanager"
mkdir -p "/febs/alertmanager"
cp "/febs/febs-apm/prometheus-grafana/alertmanager.yml" "/febs/alertmanager/alertmanager.yml"

#MySQL Redis配置
echo -e "\n是否清除数据（第一次运行请选Y）？N/y"
read confirmation
if [[ ${confirmation} = "y" || ${confirmation} = "Y" ]]
then
    echo -e "\n确定清除数据！！！（press any key to continue...）"
    read tmp2
    rm -rf "/febs/mysql"
    rm -rf "/febs/redis"
    mkdir -p "/febs/mysql/data" "/febs/redis/data" "/febs/redis/conf"
    cp "/febs/febs-cloud/docker compose/third-part/redis.conf" "/febs/redis/conf/redis.conf"
fi

#nacos配置
mkdir -p "/febs/nacos/standalone-logs/"
touch "/febs/nacos/custom.properties"

#打包后端
echo -e "\n是否（重新）打包后端？Y/n"
read confirmation
if [[ ${confirmation} != "N" && ${confirmation} != "n" ]]
then
    cd "/febs/febs-cloud/"
    mvn clean
    mvn package
fi

#下载skywalking
echo -e "\n是否（重新）下载skywalking探针？Y/n"
read confirmation
if [[ ${confirmation} != "N" && ${confirmation} != "n" ]]
then
    rm -rf "/apache-skywalking-apm-bin"
    yum -y install wget
    wget -c https://mirrors.aliyun.com/apache/skywalking/8.5.0/apache-skywalking-apm-8.5.0.tar.gz -O - | tar -xz -C /
fi

#打包前端
echo -e "\n是否（重新）打包前端？Y/n"
read confirmation
if [[ ${confirmation} != "N" && ${confirmation} != "n" ]]
then
    cd "/FEBS-Cloud-Web"
    rm -rf "./package-lock.json" "./node_modules"
    npm cache clean --force
    npm run download --unsafe-perm=true --allow-root
    npm run package
fi

#生成Docker image
systemctl start docker

echo -e "\n是否（重新）生成后端项目的Docker镜像？Y/n"
read confirmation
if [[ ${confirmation} != "N" && ${confirmation} != "n" ]]
then
    echo  -e "\n请确认已完成后端项目打包以及下载完成skywalking探针（press any key to continue...）"
    read tmp3

    cp -r "/apache-skywalking-apm-bin/agent" "/febs/febs-apm/febs-admin/agent"
    docker build -t febs-admin "/febs/febs-apm/febs-admin"

    mv "/febs/febs-apm/febs-admin/agent" "/febs/febs-auth/agent"
    docker build -t febs-auth "/febs/febs-auth"

    mv "/febs/febs-auth/agent" "/febs/febs-gateway/agent"
    docker build -t febs-gateway "/febs/febs-gateway"

    mv "/febs/febs-gateway/agent" "/febs/febs-server/febs-server-generator/agent"
    docker build -t febs-server-generator "/febs/febs-server/febs-server-generator"

    mv "/febs/febs-server/febs-server-generator/agent" "/febs/febs-server/febs-server-job/agent"
    docker build -t febs-server-job "/febs/febs-server/febs-server-job"

    mv "/febs/febs-server/febs-server-job/agent" "/febs/febs-server/febs-server-system/agent"
    docker build -t febs-server-system "/febs/febs-server/febs-server-system"

    mv "/febs/febs-server/febs-server-system/agent" "/febs/febs-server/febs-server-test/agent"
    docker build -t febs-server-test "/febs/febs-server/febs-server-test"

    mv "/febs/febs-server/febs-server-test/agent" "/febs/febs-tx-manager/agent"
    docker build -t febs-tx-manager "/febs/febs-tx-manager"

    rm -rf "/febs/febs-tx-manager/agent"

    docker rmi $(docker images | grep "none" | awk '{print $3}')
fi

echo -e "\n是否（重新）生成前端项目的Docker镜像？Y/n"
read confirmation
if [[ ${confirmation} != "N" && ${confirmation} != "n" ]]
then
    echo  -e "\n请确认已完成前端项目打包（press any key to continue...）"
    read tmp4

    docker build -t febs-cloud-web "/FEBS-Cloud-Web"

    docker rmi $(docker images | grep "none" | awk '{print $3}')
fi

#清理Docker container / image
echo -e "\n是否强制清理Docker container / image？N/y"
read confirmation
if [[ ${confirmation} = "Y" || ${confirmation} = "y" ]]
then
    docker stop $(docker ps -aq)
    echo 'y' | docker container prune
    docker rmi $(docker images | grep "none" | awk '{print $3}')
fi

#显示
clear
echo -e "Docker Image List："
docker image list

echo -e "\nDocker Container List(All)："
docker ps -a