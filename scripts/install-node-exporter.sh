#!/bin/bash
wget https://github.com/prometheus/node_exporter/releases/download/v0.18.1/node_exporter-0.18.1.linux-amd64.tar.gz
tar zxf node_exporter-0.18.1.linux-amd64.tar.gz
mv node_exporter-0.18.1.linux-amd64 /opt/node_exporter-0.18.1
ln -s /opt/node_exporter-0.14.0 /opt/node_exporter
cp ../config/node_exporter.service to /etc/systemd/system
useradd -r node_exporter -s /bin/false
chmod 755 /opt/node_exporter/node_exporter
systemctl enable node_exporter.service
systemctl start node_exporter.service