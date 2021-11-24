#!/bin/bash

OPERATION=$1

if [ -z "${OPERATION}" ]; then
  echo -e "No operation specified, please pass argument 'install' or 'remove'; exiting."
  exit 1
fi


helm ${OPERATION} kafka bitnami/kafka
helm ${OPERATION} zookeeper bitnami/zookeeper

exit 0
