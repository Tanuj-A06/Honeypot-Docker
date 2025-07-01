# Honeypot-Docker
Setting up a Docker environment and simulating communication between two containers. Communication is observed by Wireshark


## Overview

*   2 Ubuntu containers on custom Docker bridge
*   Static IPv4 assignment
*   ICMP(ping) and TCP(nc, curl) communications.
*   Traffic capture by wireshark on Kali-linux VM host.


## Setup

### 1. Create a Docker Bridge Network

```bash
docker network create \
  --driver=bridge \
  --subnet=192.168.100.0/24 \
  --gateway=192.168.100.1 \
  my-net
```

### 2. Container Launch

You can assign any IP you want, just make sure that you do not go out of your subnet.
eg: 192.168.100.X

```bash
docker run -dit --name ubuntu1 --network my-net --ip 192.168.100.10 ubuntu /bin/bash
docker run -dit --name ubuntu2 --network my-net --ip 192.168.100.20 ubuntu /bin/bash
```

### 3. Install tools

```bash
docker exec -it ubuntu1 bash
apt update && apt install -y iputils-ping iproute2 netcat curl

-----------------------------------------

docker exec -it ubuntu2 bash
apt update && apt install -y iputils-ping iproute2 netcat curl
```

Now you are ready to capture some network traffic.