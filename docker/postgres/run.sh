#!/bin/bash

docker run --name pg -p 5432:5432 -e POSTGRES_PASSWORD=password -v "$(pwd)/scripts":/docker-entrypoint-initdb.d  -d postgres:12