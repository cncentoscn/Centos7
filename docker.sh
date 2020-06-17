#!/usr/bin/env bash
# coding: utf-8
# Copyright (c) 2020
# Gmail: lucky@centoscn.vip
# blog:  www.centoscn.vip
echo "安装基本依赖"
{
 yum install -y yum-utils device-mapper-persistent-data lvm2
}|| {
echo "yum出错，请更换源重新运行"
exit 1
}

echo "Install Docker"
{
    yum-config-manager --add-repo http://mirrors.aliyun.com/docker-ce/linux/centos/docker-ce.repo
    rpm --import https://mirrors.aliyun.com/docker-ce/linux/centos/gpg
    yum install -y docker-ce
}|| {
echo "repo出错，请更换源重新运行"
exit 1
}

echo "speed Docker"
{
mkdir -p /etc/docker/
cat >> /etc/docker/daemon.json <<EOF

{
    "registry-mirrors": ["https://mirror.ccs.tencentyun.com", "https://dockerhub.azk8s.cn", "https://hub.wuxiaobai.win"]
}
EOF
}|| {
echo "docker，加速已存在"
exit 1
}
echo "service Docker"
{
    systemctl start docker
    systemctl enable docker
}|| {
echo "docker，启动失败"
exit 1
}
echo "status Docker"
{
    which docker >/dev/null 2>&1
    if [ $? -ne 0 ];then
        install_docker
    fi
    if [ ! -f "/etc/docker/daemon.json" ]; then
        config_docker
    fi
    if [ ! "$(systemctl status docker | grep Active | grep running)" ]; then
        start_docker
    fi
}|| {
echo "docker，服务未运行"
exit 1
}
