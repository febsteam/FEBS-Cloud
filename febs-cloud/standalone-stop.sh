#!/usr/bin/env bash

#停止prometheus-grafana
echo -e "\n是否停止prometheus-grafana？Y/n"
read confirmation
if [[ ${confirmation} != "n" && ${confirmation} != "N" ]]
then
    cd "/febs/febs-apm/prometheus-grafana"
    docker-compose stop
fi

#停止FEBS-Cloud
echo -e "\n是否停止FEBS-Cloud？Y/n"
read confirmation
if [[ ${confirmation} != "n" && ${confirmation} != "N" ]]
then
    cd "/febs/febs-cloud/docker compose/febs-cloud"
    docker-compose stop
fi

#停止skywalking-elk
echo -e "\n是否停止skywalking-elk？Y/n"
read confirmation
if [[ ${confirmation} != "n" && ${confirmation} != "N" ]]
then
    cd "/febs/febs-apm/skywalking-elk"
    docker-compose stop
fi

#停止Nacos
echo -e "\n是否停止Nacos？Y/n"
read confirmation
if [[ ${confirmation} != "n" && ${confirmation} != "N" ]]
then
    cd "/febs/febs-cloud/docker compose/nacos"
    docker-compose stop
fi

#停止MySQL Redis
echo -e "\n是否停止MySQL Redis？Y/n"
read confirmation
if [[ ${confirmation} != "n" && ${confirmation} != "N" ]]
then
    cd "/febs/febs-cloud/docker compose/third-part"
    docker-compose stop
fi

#删除Docker container
echo -e "\n是否删除Docker container？N/y"
read confirmation
if [[ ${confirmation} = "Y" || ${confirmation} = "y" ]]
then
    docker stop $(docker ps -aq)
    echo 'y' | docker container prune
fi

#显示
clear
echo -e "Docker Alive Container List："
docker container list

echo -e "Docker All Container List："
docker ps -a