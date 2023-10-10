#!/bin/bash

aws ecs run-task \
  --count 2 \
  --launch-type FARGATE \
  --task-definition arn:aws:ecs:us-west-2:956045422469:task-definition/torch-soci:2 \
  --cluster ecs-test --region us-west-2 \
  --network-configuration file://ecs-vpc-config.json


aws ecs run-task \
  --count 2 \
  --launch-type FARGATE \
  --task-definition arn:aws:ecs:us-west-2:956045422469:task-definition/torch:2 \
  --cluster ecs-test --region us-west-2 \
  --network-configuration file://ecs-vpc-config.json