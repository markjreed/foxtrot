#!/usr/bin/env bash
(terraform init && terraform apply -auto-approve ) >&/dev/null && \
terraform output | sed /EOT/d
