#!/usr/bin/env bash
# coding: utf-8
# Copyright (c) 2020
# Gmail: lucky@centoscn.vip
# blog:  www.centoscn.vip
#安装基础依赖
     which wget >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y wget
    fi
    if [ ! "$(rpm -qa | grep epel-release)" ]; then
        yum install -y epel-release
    fi
    if grep -q 'mirror.centos.org' /etc/yum.repos.d/CentOS-Base.repo; then
        wget -qO /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo
        sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/CentOS-Base.repo
        yum clean all
    fi
    if grep -q 'mirrors.fedoraproject.org' /etc/yum.repos.d/epel.repo; then
        wget -qO /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo
        sed -i -e '/mirrors.cloud.aliyuncs.com/d' -e '/mirrors.aliyuncs.com/d' /etc/yum.repos.d/epel.repo
        yum clean all
    fi
    which vim >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y vim
    fi
    which gcc >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y gcc
    fi
    which openssl >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y openssl
    fi
    which gcc-c++ >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y gcc-c++
    fi
    which chrony >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y chrony
    fi
    which zip >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y zip
    fi
    which unzip >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y unzip
    fi
    which openssl-devel >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y openssl-devel
    fi
    which lrzsz >/dev/null 2>&1
    if [ $? -ne 0 ];then
        yum install -y lrzsz
    fi
