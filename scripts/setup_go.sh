#!/bin/bash

if (type "go" > /dev/null 2>&1); then
  go install github.com/nametake/golangci-lint-langserver@latest
  go install golang.org/x/tools/cmd/goimports@latest
fi
