#!/bin/bash

echo "executing mvn build"
mvn clean package 2>&1 > build.log

echo "getting project name"
PROJECT_NAME=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.name}' \
    --non-recursive \
    exec:exec)

echo "getting project version"
PROJECT_VERSION=$(mvn -q \
    -Dexec.executable=echo \
    -Dexec.args='${project.version}' \
    --non-recursive \
    exec:exec)

PROJECT="${PROJECT_NAME}-${PROJECT_VERSION}"

echo PROJECT="${PROJECT}"

if [ ! -f target/${PROJECT}.jar ]
then
  echo "failed to find project jar: target/${PROJECT}.jar"
  exit 1
fi

echo "building docker image"
docker build -f docker/Dockerfile --build-arg PROJECT_JAR=${PROJECT}.jar -t ${PROJECT_NAME,,}:${PROJECT_VERSION,,} .