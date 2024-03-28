#!/bin/bash

REPOSITORY_PATH=$(
  cd $(dirname $0)
  git rev-parse --show-toplevel
)

rm -rf $REPOSITORY_PATH/config/powerline/venv
mkdir -p $REPOSITORY_PATH/config/powerline/venv
python3 -m venv $REPOSITORY_PATH/config/powerline/venv
source $REPOSITORY_PATH/config/powerline/venv/bin/activate
which pip3
pip3 install powerline-status
pip3 install powerline-mem-segment
deactivate

