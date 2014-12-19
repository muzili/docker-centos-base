FROM centos:centos7
MAINTAINER Joshua Lee <muzili@gmail.com>

# Install EPEL repo.
RUN yum -y install http://dl.fedoraproject.org/pub/epel/7/x86_64/e/epel-release-7-2.noarch.rpm
RUN yum -y upgrade

# Install base stuff.
RUN yum -y install \
  bash-completion \
  curl \
  pwgen \
  mc \
  vim-enhanced \
  syslog-ng \
  syslog-ng-libdbi \
  wget \
  yum-plugin-fastestmirror 

# Clean up YUM when done.
RUN yum clean all

ADD scripts /scripts
RUN chmod +x /scripts/start.sh
RUN touch /first_run
RUN echo "UseDNS no" >> /etc/ssh/sshd_config
RUN sed -i 's/UsePrivilegeSeparation sandbox/UsePrivilegeSeparation no/' /etc/ssh/sshd_config

# Change the root password. The password should be changed and/or managed via Puppet.
RUN echo 'root:Ch4ng3M3' | chpasswd

# Expose our web root and log directories log.
VOLUME ["/vagrant", "/var/log"]

# Kicking in
CMD ["/scripts/start.sh"]
