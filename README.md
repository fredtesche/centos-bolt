## Build the image

> docker build -t bolt-v3.6.9 .

## Start the container

> docker run --privileged --name bolt-v3.6.9 -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 -d bolt-v3.6.9 /usr/sbin/init

## Connect to the running contain

> docker exec -i -t bolt-v3.6.9 /bin/bash
