#!/bin/bash
# curl -O https://raw.githubusercontent.com/pytorch/serve/master/docs/images/kitten_small.jpg

# PRIVATE_IPs FROM INSIDE VPC
# export EXTERNAL_IP=172.31.28.173
# export EXTERNAL_IP_SOCI=172.31.4.11

response=$(curl --write-out %{http_code} --silent --output /dev/null --retry 5 -X POST "http://${EXTERNAL_IP_SOCI}:8081/models?url=https://torchserve.s3.amazonaws.com/mar_files/resnet-18.mar&initial_workers=1&synchronous=true")
if [ ! "$response" == 200 ]
then
    echo "failed to register model with torchserve"
else
    echo "successfully registered model with torchserve"
fi
curl -X GET http://${EXTERNAL_IP_SOCI}:8081/models/
curl -X POST http://${EXTERNAL_IP_SOCI}:8080/predictions/resnet-18 -T kitten_small.jpg


response=$(curl --write-out %{http_code} --silent --output /dev/null --retry 5 -X POST "http://${EXTERNAL_IP}:8081/models?url=https://torchserve.s3.amazonaws.com/mar_files/resnet-18.mar&initial_workers=1&synchronous=true")
if [ ! "$response" == 200 ]
then
    echo "failed to register model with torchserve"
else
    echo "successfully registered model with torchserve"
fi
curl -X GET http://${EXTERNAL_IP}:8081/models/
curl -X POST http:///${EXTERNAL_IP}:8080/predictions/resnet-18 -T kitten_small.jpg


