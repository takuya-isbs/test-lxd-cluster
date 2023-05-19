# test-lxd-cluster

```bash
./01_create-nodes.sh
./SHELL.sh
```

in VM

```bash
microcloud init
```

OK

```text
root@testcluster1:~# microcloud init
Select an address for MicroCloud's internal traffic:

 Using address "10.217.240.184" for MicroCloud

Limit search for other MicroCloud servers to 10.217.240.184/24? (yes/no) [default=yes]:
Scanning for eligible servers ...

 Selected "testcluster3" at "10.217.240.193"
  Selected "testcluster2" at "10.217.240.106"

Would you like to set up local storage? (yes/no) [default=yes]: no
Would you like to set up distributed storage? (yes/no) [default=yes]:
Select from the available unpartitioned disks:

Select which disks to wipe:

 Using 1 disk(s) on "testcluster1" for remote storage pool
 Using 1 disk(s) on "testcluster2" for remote storage pool
 Using 1 disk(s) on "testcluster3" for remote storage pool

No dedicated uplink interfaces detected, skipping distributed networking
Initializing a new cluster
Local MicroCloud is ready
Local LXD is ready
Local MicroOVN is ready
Local MicroCeph is ready
Awaiting cluster formation ...
Peer "testcluster3" has joined the cluster
Peer "testcluster2" has joined the cluster
Cluster initialization is complete
MicroCloud is ready

root@testcluster1:~# lxc storage list
If this is your first time running LXD on this machine, you should also run: lxd init
To start your first container, try: lxc launch ubuntu:22.04
Or for a virtual machine: lxc launch ubuntu:22.04 --vm

+--------+--------+-----------------------------+---------+---------+
|  NAME  | DRIVER |         DESCRIPTION         | USED BY |  STATE  |
+--------+--------+-----------------------------+---------+---------+
| remote | ceph   | Distributed storage on Ceph | 1       | CREATED |
+--------+--------+-----------------------------+---------+---------+

root@testcluster1:~# lxc cluster list
+--------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
|     NAME     |             URL             |      ROLES      | ARCHITECTURE | FAILURE DOMAIN | DESCRIPTION | STATE  |      MESSAGE      |
+--------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| testcluster1 | https://10.217.240.184:8443 | database-leader | x86_64       | default        |             | ONLINE | Fully operational |
|              |                             | database        |              |                |             |        |                   |
+--------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| testcluster2 | https://10.217.240.106:8443 | database        | x86_64       | default        |             | ONLINE | Fully operational |
+--------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+
| testcluster3 | https://10.217.240.193:8443 | database        | x86_64       | default        |             | ONLINE | Fully operational |
+--------------+-----------------------------+-----------------+--------------+----------------+-------------+--------+-------------------+

root@testcluster1:~# microceph cluster list
+--------------+---------------------+-------+------------------------------------------------------------------+--------+
|     NAME     |       ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+--------------+---------------------+-------+------------------------------------------------------------------+--------+
| testcluster1 | 10.217.240.184:7443 | voter | 40f46ddf77025740251dadd1fc82b70a228b7d1a1c0c65c29bfd893681441368 | ONLINE |
+--------------+---------------------+-------+------------------------------------------------------------------+--------+
| testcluster2 | 10.217.240.106:7443 | voter | bba8008959e3dd592cef9312331b23e94db31f55864053f400dea12c31d04f92 | ONLINE |
+--------------+---------------------+-------+------------------------------------------------------------------+--------+
| testcluster3 | 10.217.240.193:7443 | voter | 3b411af0f11d51517716133fff265e7f5b0615606060603df6e51fbd33fe9f08 | ONLINE |
+--------------+---------------------+-------+------------------------------------------------------------------+--------+

root@testcluster1:~# microcloud cluster list
+--------------+---------------------+-------+------------------------------------------------------------------+--------+
|     NAME     |       ADDRESS       | ROLE  |                           FINGERPRINT                            | STATUS |
+--------------+---------------------+-------+------------------------------------------------------------------+--------+
| testcluster1 | 10.217.240.184:9443 | voter | 3b44c27bbbb5c4125c723299cc6a650399f6b321c3b1ec288fafa0301d4387f0 | ONLINE |
+--------------+---------------------+-------+------------------------------------------------------------------+--------+
| testcluster2 | 10.217.240.106:9443 | voter | b733aa5936573133db95b267b5434490557a91d3ca5b2d3bd019f85274889b0b | ONLINE |
+--------------+---------------------+-------+------------------------------------------------------------------+--------+
| testcluster3 | 10.217.240.193:9443 | voter | f788db96af04c1750c776acafdb4c3c9addfae7228ea8b209c45199ab616346d | ONLINE |
+--------------+---------------------+-------+------------------------------------------------------------------+--------+

root@testcluster1:~# lxc launch ubuntu:22.04 ub22-1
root@testcluster1:~# lxc launch ubuntu:22.04 ub22-2

root@testcluster1:~# lxc list
+--------+---------+----------------------+------+-----------+-----------+--------------+
|  NAME  |  STATE  |         IPV4         | IPV6 |   TYPE    | SNAPSHOTS |   LOCATION   |
+--------+---------+----------------------+------+-----------+-----------+--------------+
| ub22-1 | RUNNING | 240.106.0.140 (eth0) |      | CONTAINER | 0         | testcluster2 |
+--------+---------+----------------------+------+-----------+-----------+--------------+
| ub22-2 | RUNNING | 240.184.0.18 (eth0)  |      | CONTAINER | 0         | testcluster1 |
+--------+---------+----------------------+------+-----------+-----------+--------------+

### ubuntu 16.04 can not work?
```

may not work?? (retry to run ./01_create-nodes.sh ...)

```text
Awaiting cluster formation ...
Error: Peer "testcluster3" failed to join the cluster: Failed to update cluster status of services: Failed to join "MicroCeph" cluster: Failed adding \
new disk: Failed to record disk: Failed to create "disks" entry: UNIQUE constraint failed: disks.osd
```
