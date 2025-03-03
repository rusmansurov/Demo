#!/bin/bash

docker run -p 80:8978 -v "$(pwd)/var/cloudbeaver/workspace":/opt/cloudbeaver/workspace -d dbeaver/cloudbeaver:latest