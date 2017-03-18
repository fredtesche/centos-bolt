## Build the image

> docker build -t goneri/bolt-v3.2.9 .

## Start the container

> docker run --privileged --name bolt-v3.2.9 -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 -d goneri/bolt-v3.2.9 /usr/sbin/init

## Connect to the running contain

> docker exec -i -t bolt-v3.2.9 /bin/bash

## If you want to upgrade an existing instance and keep your data

> docker stop bolt-v3.2.1
> docker run --privileged --volumes-from bolt-v3.2.1 --name bolt-v3.2.9 -v /sys/fs/cgroup:/sys/fs/cgroup:ro -p 80:80 -d goneri/bolt-v3.2.9 /usr/sbin/init
