#!/bin/bash -xe

source /home/rally/$SOURCE_FILE

rally-manage db recreate
rally deployment create --fromenv --name=rally

rally task start /opt/rally/samples/tasks/scenarios/nova/boot-and-live-migrate.json
rally task start /opt/rally/samples/tasks/scenarios/nova/boot-from-volume-and-delete.json
rally task start /opt/rally/samples/tasks/scenarios/cinder/create-and-attach-volume.json
rally task start /opt/rally/samples/tasks/scenarios/neutron/create-and-delete-networks.json
rally task start /opt/rally/samples/tasks/scenarios/neutron/create-and-delete-routers.json
rally task start /opt/rally/samples/tasks/scenarios/keystone/create-user-update-password.json

tasks=`rally task list | awk '{print $2}' | grep -v uuid`
rally task report --tasks $tasks --junit --out report.xml

# count errors as rally does not generate it
error_count=0
for task in $tasks; do err=`rally task detailed $task | grep error\(s\) | awk '{print $4}'`; for e in $err; do error_count=$[error_count+e]; done ; done
sed -i 's/errors="0"/errors="'$error_count'"/g' report.xml

# print all output into a file for debug purposes
for task in $tasks; do rally task detailed $task >> detailed_output; done
