#!/bin/sh
root_repo="inventory-postgres"
pachctl \
  create-repo "${root_repo}" \
&& echo "test" | pachctl \
  put-file "${root_repo}" master test \
&& pachctl \
  create-pipeline -f ./run/pipeline-spec.json \
&& tail -f /dev/null
