#!/bin/bash
# Starts up the Centos Base container.

# Stop on error
set -e

LOG_DIR=/var/log

echo "booting container. ETCD: $ETCD_NODE"

# Loop until confd has updated the default config
n=0
until confd -onetime -node "$ETCD_NODE"; do
    if [ "$n" -eq "4" ];  then
        echo "Failed to start due to config error"
        break;
    fi
    echo "waiting for confd to refresh configurations"
    n=$((n+1))
    sleep $n
done


if [[ -e /first_run ]]; then
    source /scripts/first_run.sh
else
    source /scripts/normal_run.sh
fi

pre_start_action
post_start_action

exec supervisord
