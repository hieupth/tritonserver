#!/bin/bash

set -ex;

git clone https://github.com/triton-inference-server/server.git
cd server
git checkout r${TRITON_VERSION}
pip install distro requests
python3 build.py \
  --enable-gpu \
  --enable-logging \
  --enable-stats \
  --enable-tracing \
  --endpoint=grpc \
  --endpoint=http \
  --backend identity \
  --backend repeat \
  --backend ensemble \
  --backend python \
  --backend onnxruntime \
  --backend tensorrt \
  --backend fil