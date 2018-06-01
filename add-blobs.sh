#!/bin/sh

DIR=`pwd`

mkdir -p .downloads

cd .downloads

if [ ! -f ${DIR}/blobs/java/openjdk-1.8.0_162.tar.gz ];then
    curl -L -O -J https://download.run.pivotal.io/openjdk-jdk/trusty/x86_64/openjdk-1.8.0_162.tar.gz
    bosh add-blob --dir=${DIR} openjdk-1.8.0_162.tar.gz java/openjdk-1.8.0_162.tar.gz
fi

cd -

cd src/pks-master-gateway
./mvnw clean package -DskipTests=true
bosh add-blob --dir=${DIR} target/pks-master-gateway-0.0.1-SNAPSHOT.jar pks-master-gateway/pks-master-gateway.jar
cd -
