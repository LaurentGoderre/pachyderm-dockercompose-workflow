#!/bin/bash
set -e
set -o pipefail

n=1
until [ $n -ge 10 ]
do
  echo "Running query (attempt #${n})"
  (psql -t -AF $'\t' -f /root/script.sql | awk '{close(f);f="/pfs/out/"$1".csv"; print $2","$3 > f}') && echo "Done!" && break
  n=$(($n+1))
  sleep 5
done
