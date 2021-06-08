#!/bin/bash

collector_download_link="https://collectors.us2.sumologic.com/rest/download/tar"
collector_file_name="SumoCollector.tar.gz"
tanuki_wrapper_download_link="https://download.tanukisoftware.com/wrapper/3.5.45/wrapper-linux-armhf-64-3.5.45.tar.gz"

err_report() {
    echo "Error on line $1"
    exit 1
}

trap 'err_report $LINENO' ERR

[ ! -f agent.config ] && err_report "$LINENO : not found agent.config"
source agent.config

if [ ! -d /opt ];then
    mkdir /opt
fi

cd /opt

wget -L $collector_download_link -O $collector_file_name
tar -zxvf SumoCollector.tar.gz -C /opt/

cd /opt/sumocollector/

version=$(grep wrapper.java.classpath.1 config/wrapper.conf | cut -d= -f2 | cut -d/ -f2)
if [ -z $version ];then
    echo "not found version information"
    exit 1
fi

wget $tanuki_wrapper_download_link
tar -zxpf wrapper-linux-armhf-64-3.5.45.tar.gz
cp wrapper-linux-armhf-64-3.5.45/bin/wrapper .
cp wrapper-linux-armhf-64-3.5.45/lib/libwrapper.so 19.338-5/bin/native/lib/

[[ $(rpm -qa java-*-openjdk) ]] || yum install java-1.8.0-openjdk -y

cat > /opt/sumocollector/config/user.properties <<EOF
accessid=$accessid
accesskey=$accesskey
name=$name
wrapper.java.command=java
EOF

mv ./$version/lib/wrapper-3.5.33.jar{,.bak}
mv ./$version/bin/native/lib/wrapper.jar{,.bak}
cp ./wrapper-linux-armhf-64-3.5.45/lib/wrapper.jar ./$version/lib/wrapper-3.5.33.jar
cp ./wrapper-linux-armhf-64-3.5.45/lib/libwrapper.so ./$version/bin/native/lib/

chmod 755 collector
chmod 755 wrapper

./collector install
systemctl daemon-reload
systemctl enable collector.service
systemctl start collector.service
