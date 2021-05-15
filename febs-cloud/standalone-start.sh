#!/usr/bin/env bash

echo -e "\n脚本运行期间请勿做无效输入\n"

sysctl -w vm.max_map_count=262144
systemctl start docker

#运行MySQL Redis
echo -e "\n是否运行MySQL Redis？N/y"
read confirmation
if [[ ${confirmation} = "y" || ${confirmation} = "Y" ]]
then
    cd "/febs/febs-cloud/docker compose/third-part"
    docker-compose up -d --no-recreate --remove-orphans
    echo -e "\n请确认已完成数据库导入（press any key to continue...）"
    read tmp
    echo -e "Waiting for 30s..."
    sleep 30s
fi


#运行Nacos
echo -e "\n是否运行Nacos？N/y"
read confirmation
if [[ ${confirmation} = "y" || ${confirmation} = "Y" ]]
then
    cd "/febs/febs-cloud/docker compose/nacos"
    docker-compose up -d --no-recreate --remove-orphans
    echo -e "\nWaiting for 60s..."
    sleep 40s
fi

#运行skywalking-elk
echo -e "\n是否运行skywalking-elk？N/y"
read confirmation
if [[ ${confirmation} = "y" || ${confirmation} = "Y" ]]
then
    cd "/febs/febs-apm/skywalking-elk/"
    docker-compose up -d --no-recreate --remove-orphans
    echo -e "\nWaiting for 130s..."
    sleep 130s
fi

#运行FEBS-Cloud
echo -e "\n是否运行FEBS-Cloud？N/y"
read confirmation
if [[ ${confirmation} = "y" || ${confirmation} = "Y" ]]
then
    cd "/febs/febs-cloud/docker compose/febs-cloud"
    docker-compose up -d --no-recreate --remove-orphans
    echo -e "\nWaiting for 360s..."
    sleep 360s
fi

#运行prometheus-grafana
echo -e "\n是否启动prometheus-grafana？N/y"
read confirmation
if [[ ${confirmation} = "y" || ${confirmation} = "Y" ]]
then
    cd "/febs/febs-apm/prometheus-grafana/"
    docker-compose up -d --no-recreate --remove-orphans
    echo -e "\nWaiting for 30s..."
    sleep 30s
fi

#显示
clear
echo -e "Docker All Container List："
docker ps -a
echo
free
