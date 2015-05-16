FROM centos:centos7
MAINTAINER Joshua Lee <muzili@gmail.com>

# Install base stuff.
# 禁用 fastestmirror 插件
RUN yum -y install epel-release && \
    rpm -Uvh http://rpms.famillecollet.com/enterprise/remi-release-7.rpm && \
    yum update -y && \
    yum -y install python-setuptools wget curl tar gzip unzip bash-completion && \
    yum -y install postfix cyrus-sasl-plain cyrus-sasl-md5 && \
    easy_install supervisor && \
    yum clean all

ENV ETCD_NODE 172.17.42.1:4001
ENV CONFD_VERSION 0.9.0
ENV ETCD_VERSION 2.0.10

#Add the etcd binary
RUN wget --progress=bar:force --retry-connrefused -t 5  https://github.com/coreos/etcd/releases/download/v${ETCD_VERSION}/etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -O etcd-v${ETCD_VERSION}-linux-amd64.tar.gz && \
    tar xzvf etcd-v${ETCD_VERSION}-linux-amd64.tar.gz -C /tmp/ && \
    cp /tmp/etcd-v${ETCD_VERSION}-linux-amd64/etcd* /usr/bin/ && \
    rm -rf /tmp/etcd-v${ETCD_VERSION}-linux-amd64

#Add confd to centos base
RUN wget --progress=bar:force --retry-connrefused -t 5 http://github.com/kelseyhightower/confd/releases/\download/v${CONFD_VERSION}/confd-${CONFD_VERSION}-linux-amd64 -O /bin/confd && \
    chmod +x /bin/confd
ADD confd /etc/confd

# Create the sleleton 1st run
ADD scripts /scripts
RUN chmod +x /scripts/start.sh && touch /first_run

# Expose our web root and log directories log.
VOLUME ["/var/log", "/data"]

EXPOSE 25

# Kicking in
CMD ["/scripts/start.sh"]
