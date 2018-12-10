#!/usr/bin/env bash

set -e

tar -xzvf *.tar.gz ./

sh ./installer/install.sh

cd ./src
docker-compose up -d
sleep 60
docker-compose logs web
