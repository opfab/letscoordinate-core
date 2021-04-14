#!/bin/bash

jarVersion=$(grep -E '<version>.*</version>' ../../letsco-api/pom.xml | head -1 | sed 's/.*<version>\(.*\)<\/version>/\1/')
if [ -z $1 ]; then
  tag=$jarVersion
else
  tag=$1
fi
echo "The jar version is $jarVersion"
echo "The tag is $tag"

jarFile="letsco-api-${jarVersion}-exec.jar"
mainDir="../../letsco-api/"
dockerTag="letscoordinate/backend"

if [ -z $2 ]; then
  cd $mainDir/.. && mvn clean && mvn package && cd -
fi
cp ${mainDir}/target/${jarFile} ./letsco-api.jar
docker build --tag=${dockerTag}:${tag} .
docker build --tag=${dockerTag}:latest .
docker push ${dockerTag}:${tag}
docker push ${dockerTag}:latest

if [ ! -z $runLocally ]; then
  docker run -d -p 8080:8080 --name letsco-back java-letsco-back
fi

