FROM centos:centos7
MAINTAINER Joshua Lee <muzili@gmail.com>

# Install base stuff.
# 禁用 fastestmirror 插件
RUN yum -y install epel-release wget curl unzip bash-completion && \
    sed -i.backup 's/^enabled=1/enabled=0/' /etc/yum/pluginconf.d/fastestmirror.conf && \
    mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup && \
    wget -O /etc/yum.repos.d/CentOS-Base-aliyun.repo http://mirrors.aliyun.com/repo/Centos-7.repo && \
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    if [[ ! -f /etc/yum.repos.d/epel.repo.backup ]]; then  \
       mv /etc/yum.repos.d/epel.repo /etc/yum.repos.d/epel.repo.backup;  \
    fi && \
    if [[ ! -f /etc/yum.repos.d/epel-testing.repo.backup ]]; then \
       mv /etc/yum.repos.d/epel-testing.repo /etc/yum.repos.d/epel-testing.repo.backup;  \
    fi && \
    wget -O /etc/yum.repos.d/epel.repo http://mirrors.aliyun.com/repo/epel-7.repo && \
    yum -y install python-setuptools && \
    yum update -y && \
    easy_install supervisor && \
    yum clean all


ENV ETCD_NODE 172.17.42.1:4001
ENV CONFD_VERSION 0.9.0
ENV ETCD_VERSION 2.0.10

#Add the etcd binary
RUN wget --progress=bar:force --retry-connrefused -t 5  https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -o etcd-v${ETCD_VERSION}-linux-amd64.tar.gz && \
    tar xzvf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -C /tmp/ && \
    cp /tmp/etcd-v${ETCD_VERSION}-linux-amd64/etcd* /usr/bin/ && \
    rm -rf /tmp/etcd-v${ETCD_VERSION}-linux-amd64

#Add confd to centos base
RUN wget --progress=bar:force --retry-connrefused -t 5 http://github.com/kelseyhightower/confd/releases/\download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 -O /bin/confd && \
    chmod +x /bin/confd

# Create the sleleton 1st run
ADD scripts /scripts
RUN chmod +x /scripts/start.sh

# Expose our web root and log directories log.
VOLUME ["/var/log"]

# Kicking in
CMD ["/scripts/start.sh"]
