#!/usr/bin/env bash

docker build \
  --build-arg CONDA_VERSION=py37_4.9.2 \
  --build-arg SHA256SUM_X86_64=79510c6e7bd9e012856e25dcb21b3e093aa4ac8113d9aa7e82a86987eabe1c31 \
  -t naralogics/miniconda3:latest \
  ./miniconda3/debian
