#!/usr/bin/env bash
BASEDIR=$(dirname $0)

function run-command() {
  command=$1
  message=$2
  onFailure=$3
  printf "%s ==>Command: %s\n" "$message" "$command"
  eval $1
  rc=$?
  if [[ $rc != 0 ]] ; then
    printf "...Failed with Exit Code: %s ==>Command: %s\n" "$rc" "$command"
    if [[ $onFailure != 0 ]] ; then
      printf "...Blocked! Cannot Continue!!!!\n"
    exit $rc
    fi
  fi
  if [[ $rc == 0 ]] ; then
  printf "...Success!!!\n"
  fi
  echo "--o--o--o--o--o--o--o--o--o--o--o--o--o--o--"
}

function conditional-install()
  {
  echo '----------------------------'
  echo "Conditional Command >" $1
  echo "Install Command >" $2
  echo '----------------------------'
  eval $1
  OUT=$?
  if [ $OUT -ne "0" ]; then
    run-command $2, "Continuing execution....", 0
    eval $1
    OUT=$?
    if [ $OUT -ne "0" ] && [$1 -ne 'flse']; then
      echo "DEVOPSCODE>>> $1 failed"
      exit -1
    fi
  fi
}

function apt-squid-deb-proxy() {
    echo 'Acquire { Retries "0"; HTTP { Proxy "http://10.29.2.225:8000/"; };};' > /etc/apt/apt.conf
}

apt-squid-deb-proxy

apt-get update
apt-get install git python-yaml python-jinja2 python-pycurl python-pip -y
git clone https://github.com/ansible/ansible.git
cd ansible
source ./hacking/env-setup
pip install setuptools
ansible-galaxy install angstwad.docker_ubuntu