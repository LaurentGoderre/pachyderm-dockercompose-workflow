#!/bin/sh
set -e
set -o pipefail

repo="low-inventory-postgres"

waitFor () {
  command=${1};
  shift
  test=${1};
  shift

  n=1
  until [ $n -ge 10 ]
  do
    result=$(pachctl ${command} | grep ${test})
    [ ! -z "$result" ] && echo $result && return
    sleep 5
    n=$((n+1))
  done
}

test () {
  test_message=${1}
  shift
  actual=${1}
  shift
  expected=${1}

  if [ "${actual}" = "${expected}" ]; then
    echo -e "\e[38;5;82m✓ ${test_message}"
  else
    echo -e "\e[31m✗ ${test_message}"
    echo -e "\e[31mActual: ${actual}\n\e[38;5;82mExpected: ${expected}"
  fi
}

pipeline_job=$(waitFor "list-job" ${repo} | awk '{print $1}')
job="$(pachctl inspect-job -b ${pipeline_job})"
state=$(echo "${job}" | grep -i 'state')
commit=$(echo "${job}" | grep -i 'output commit' | awk '{print $3}')
pachctl flush-commit "${repo}/${commit}" > /dev/null
test_results=
if [ "${state}" = "State: success" ]; then
  #pachctl list-file $repo master
  test_results="${test_results}\n$(test "it should add the safe stock level and inventory count to the file" "$(pachctl get-file ${repo} master 1.csv)" "1000,353")"

  echo -e "${test_results}"
  echo "Test finished!"

  [ ! -z "$(echo "${test_results}" | grep '✗')" ] && exit 2
  exit 0
else
  echo "\e[31mPipeline Failed"
  exit 1
fi
