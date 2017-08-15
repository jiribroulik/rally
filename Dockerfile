FROM rallyforge/rally:0.9.1
MAINTAINER Jiri Broulik <jbroulik@mirantis.com>

WORKDIR /var/lib
USER root
RUN git clone https://git.openstack.org/openstack/tempest -b 16.1.0 && \
    pip install tempest==16.1.0
    
WORKDIR /home/rally

COPY scripts/boot-and-live-migrate.json /opt/rally/samples/tasks/scenarios/nova/boot-and-live-migrate.json
COPY scripts/boot-from-volume-and-delete.json /opt/rally/samples/tasks/scenarios/nova/boot-from-volume-and-delete.json 
COPY scripts/create-and-attach-volume.json /opt/rally/samples/tasks/scenarios/cinder/create-and-attach-volume.json
COPY scripts/create-and-delete-networks.json /opt/rally/samples/tasks/scenarios/neutron/create-and-delete-networks.json
COPY scripts/create-and-delete-routers.json /opt/rally/samples/tasks/scenarios/neutron/create-and-delete-routers.json
COPY scripts/create-user-update-password.json /opt/rally/samples/tasks/scenarios/keystone/create-user-update-password.json

COPY tempest_conf /var/lib/tempest_conf
COPY run_tempest.sh /usr/bin/run-tempest

ENTRYPOINT ["/usr/bin/run-tempest"]
