#!/bin/bash
set -eux

source config-default.env.sh
source config.env.sh

# usage:
# delete and create: ./01_create-nodes.sh
# delete only:       ./01_create-nodes.sh DELETE

DELETE=${1:-}

IGNORE() {
    true
}

wait_for_wake() {
    local NODE_NAME=$1
    until lxc exec ${NODE_NAME} -- cloud-init status --wait; do
        sleep 1
    done
    # until lxc exec ${NODE_NAME} -- ping -q -4 -c 1 ${DNS_CHECK}; do
    #     sleep 1
    # done
}

exec_retry() {
    local NODE_NAME=$1
    shift
    until lxc exec ${NODE_NAME} -- "$@"; do
        sleep 1
    done
}

validate() {
    [ $NUM_NODES -le $MAX_NUM_NODES ]
}

validate

for i in `seq $MAX_NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    VOLUME_NAME=${VOLUME_PREFIX}${i}
    lxc stop ${NODE_NAME} || IGNORE
    lxc delete ${NODE_NAME} || IGNORE
    lxc storage volume delete ${STORAGE_POOL} ${VOLUME_NAME} || IGNORE
done

if [ "$DELETE" = "DELETE" ]; then
    exit 0
fi

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    VOLUME_NAME=${VOLUME_PREFIX}${i}
    lxc storage volume create ${STORAGE_POOL} ${VOLUME_NAME} --type block
    lxc launch ${IMAGE} ${NODE_NAME} ${VM} -c limits.cpu=2 -c limits.memory=2GiB
    lxc config device add ${NODE_NAME} disk1 disk pool=${STORAGE_POOL} source=${VOLUME_NAME}
done
# TODO lxc storage volume set oauthssh cephtest1 size 15GiB

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    VOLUME_NAME=${VOLUME_PREFIX}${i}
    wait_for_wake ${NODE_NAME}
    # https://github.com/canonical/microcloud
    lxc exec ${NODE_NAME} snap install lxd microceph microovn microcloud &
done
wait

for i in `seq $NUM_NODES`; do
    NODE_NAME=${NODE_PREFIX}${i}
    VOLUME_NAME=${VOLUME_PREFIX}${i}
    lxc exec ${NODE_NAME} -- snap list
done
