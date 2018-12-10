#!/usr/bin/env bash

set -e

tar -xzvf *.tar.gz ./

sh ./installer/install.sh

cd ./src
docker-compose up -d
sleep 60
docker-compose logs web

docker-compose exec web  mysql -uroot -e "ALTER USER 'admin'@'%' IDENTIFIED BY 'admin@123';"
