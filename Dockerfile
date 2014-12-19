FROM centos:centos7
MAINTAINER Joshua Lee <muzili@gmail.com>

# Install EPEL repo.
RUN yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
RUN yum -y upgrade

# Install base stuff.
RUN yum -y install \
  bash-completion \
  curl \
  wget \
  unzip

# Clean up YUM when done.
RUN yum clean all

# Create the sleleton 1st run
ADD scripts /scripts
RUN chmod +x /scripts/start.sh

# Expose our web root and log directories log.
VOLUME ["/var/log"]

# Kicking in
CMD ["/scripts/start.sh"]
