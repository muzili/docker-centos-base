FROM centos:centos7
MAINTAINER Joshua Lee <muzili@gmail.com>

# Install base stuff.
RUN yum -y install epel-release python-setuptools \
  bash-completion curl wget unzip && \
  yum update -y && \
  easy_install supervisor && \
  yum clean all

# Create the sleleton 1st run
ADD scripts /scripts
RUN chmod +x /scripts/start.sh

# Expose our web root and log directories log.
VOLUME ["/var/log"]

# Kicking in
CMD ["/scripts/start.sh"]
