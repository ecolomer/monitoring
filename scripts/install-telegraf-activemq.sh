#!/bin/bash
wget https://dl.influxdata.com/telegraf/releases/telegraf_1.11.3-1_amd64.deb
dpkg -i telegraf_1.11.3-1_amd64.deb
rm telegraf_1.11.3-1_amd64.deb
cp ../config/telegraf.conf.activemq to /etc/telegraf/telegraf.conf
systemctl restart telegraf.service