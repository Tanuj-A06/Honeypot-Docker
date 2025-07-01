Check if your docker is up and running in the background:

```bash
sudo systemctl status docker 
```

![image](./img/Screenshot%202025-07-01%20162311.png)

Bingo, now let's set up a private network for them to communicate.

```bash
docker network create \
  --driver=bridge \
  --subnet=192.168.100.0/24 \
  --gateway=192.168.100.1 \
  my-net
```

![image](./img/Screenshot%202025-07-01%20162700.png)

Our network is ready, let's set up our 2 containers.

```bash
docker run -dit \
  --name ubuntu1 \
  --network my-net \
  --ip 192.168.100.10 \
  ubuntu /bin/bash


docker run -dit \
  --name ubuntu2 \
  --network my-net \
  --ip 192.168.100.20 \
  ubuntu /bin/bash
```

![image](./img/Screenshot%202025-07-01%20162941.png)

Both of our containers are up and running, now let's get the neccessary tools in them.

Update both the containers with ``apt update``

To install nessacary tools:

```bash
apt install -y iputils-ping iproute2 netcat-openbsd curl
```

This will allow the containers to interract with each other.

Checking their IPv4:

![image](./img/Screenshot%202025-07-01%20163843.png)

![image](./img/Screenshot%202025-07-01%20163856.png)

Now let's see the communications with wireshark:

Boot up wireshark and now let's ping ubuntu2 from ubuntu1

This will be ICMP(ping) requests.

![image](./img/Screenshot%202025-07-01%20164150.png)

The request keeps on going until we stop the ping requests.

Now lest stimulate TCP requests through 'netcat'

On ubuntu2:
```bash
nc -lnvp 8080
```

Ubuntu2 is listening on port 8080.

On ubuntu1:

```bash
nc 192.168.100.20 8080
```

Sending messages through nc

![image](./img/Screenshot%202025-07-01%20164745.png)

Wireshark captures:

![image](./img/Screenshot%202025-07-01%20164835.png)


Setting up a simple pyton based http server on a specific port:

```bash
python3 -m http.server 8080
```

curl it to see the webserver HTML page, and if somethign is saved in the same directory the http server is set up we can exfiltrate it too. This is demonstrated in the wireshark capture files attached in the traffic folder.

[pcap files](../traffic/)

To clean up the containers:

```bash
docker stop ubuntu1 ubuntu2

docker rm ubuntu1 ubuntu2

docker network rm my-net
```

Thus we have successfully establish connections between 2 containers, assigned them unique IPv4 addresses, and interracted with them.

Now this can be used for settign up honeypot services, such as ssh, nginx-server, ftp on diffrent docker containers.