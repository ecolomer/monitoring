#!/bin/bash
wget https://github.com/prometheus/mysqld_exporter/releases/download/v0.12.1/mysqld_exporter-0.12.1.linux-amd64.tar.gz
tar zxf mysqld_exporter-0.12.1.linux-amd64.tar.gz
mv mysqld_exporter-0.12.1.linux-amd64 /opt/mysqld_exporter-0.12.1
ln -s /opt/mysqld_exporter-0.12.1 /opt/mysqld_exporter
cp ../config/mysqld_exporter.service to /etc/systemd/system
useradd -r mysqld_exporter -s /bin/false
chmod 755 /opt/mysqld_exporter/mysqld_exporter
systemctl enable mysqld_exporter.service
systemctl start mysqld_exporter.service
