#!/usr/bin/env bash
# coding: utf-8
# Copyright (c) 2020
# Gmail: lucky@centoscn.vip
# blog:  www.centoscn.vip
flag=0
echo -ne "root   Check \t........................ "
isRoot=`id -u -n | grep root | wc -l`
if [ "x$isRoot" == "x1" ];then
  echo -e "[\033[32m OK \033[0m]"
else
  echo -e "[\033[31m ERROR \033[0m] 请用 root 用户执行安装脚本"
  flag=1
fi
#操作系统检测
echo -ne "CentOS7 Check \t........................ "
if [ -f /etc/redhat-release ];then
  osVersion=`cat /etc/redhat-release | grep -oE '[0-9]+\.[0-9]+'`
  majorVersion=`echo $osVersion | awk -F. '{print $1}'`
  if [ "x$majorVersion" == "x" ];then
    echo -e "[\033[31m ERROR \033[0m] 操作系统类型版本不符合要求，请使用 CentOS 7 64 位版本"
    flag=1
  else
    if [[ $majorVersion == 7 ]];then
      is64bitArch=`uname -m`
      if [ "x$is64bitArch" == "xx86_64" ];then
         echo -e "[\033[32m OK \033[0m]"
      else
         echo -e "[\033[31m ERROR \033[0m] 操作系统必须是 64 位的，32 位的不支持"
         flag=1
      fi
    else
      echo -e "[\033[31m ERROR \033[0m] 操作系统类型版本不符合要求，请使用 CentOS 7"
      flag=1
    fi
  fi
else
    echo -e "[\033[31m ERROR \033[0m] 操作系统类型版本不符合要求，请使用 CentOS 7"
    flag=1
fi
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
