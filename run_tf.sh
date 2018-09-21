#!/usr/bin/env bash
(terraform init && terraform apply ) >&/dev/null && \
terraform output | sed 's/^values = //'
