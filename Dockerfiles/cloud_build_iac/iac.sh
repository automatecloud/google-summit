#!/bin/sh
echo "Converting kubernetes.yaml file to kubernetes.json"
kubectl convert -f kubernetes.yaml -o json > kubernetes.json
echo "Running IAC Scan via the Prisma Public Cloud IAC Scan API"
curl -d @kubernetes.json  -X POST https://scanapi.redlock.io/v1/iac
