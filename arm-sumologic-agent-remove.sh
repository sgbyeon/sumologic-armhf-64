#!/bin/bash

systemctl stop collector.service
systemctl disable collector.service
rm -rf /opt/[sS]umo[cC]ollector*
rm -f /etc/systemd/system/collector.service
