docker run -dit --name ubuntu1 --network my-net --ip 192.168.100.10 ubuntu /bin/bash

docker run -dit --name ubuntu2 --network my-net --ip 192.168.100.20 ubuntu /bin/bash

docker exec -it ubuntu1 bash

apt update && apt install -y iputils-ping iproute2 netcat curl

exit

docker exec -it ubuntu2 bash

apt update && apt install -y iputils-ping iproute2 netcat curl

exit