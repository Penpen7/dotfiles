#!/bin/bash

if (type "nodebrew" > /dev/null 2>&1); then
  nodebrew setup
  nodebrew install v16.5.0
  nodebrew use v16.5.0
  export PATH="$PATH:$HOME/.nodebrew/current/bin"
fi

if (type "npm" > /dev/null 2>&1); then
  npm install -g yarn
fi
