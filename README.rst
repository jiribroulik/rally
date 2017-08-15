USAGE
=====

docker run --rm --net=host -it --entrypoint /bin/bash -e TEMPEST_CONF=mcp.conf -e SOURCE_FILE=openrc -v /root/:/home/rally rally_tasks

Then run the following script inside container: /usr/bin/run-tempest
