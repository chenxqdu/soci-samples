#!/bin/bash

CLUSTER="ecs-test"
REGION="us-west-2"
TASKDEF="torch"
TASKDEF_SOCI="torch-soci"

TASKS=$(aws ecs list-tasks \
    --cluster $CLUSTER \
    --family $TASKDEF \
    --region $REGION \
    --query 'taskArns[*]' \
    --output text)

aws ecs describe-tasks \
    --tasks $TASKS \
    --region $REGION \
    --cluster $CLUSTER \
    --query "tasks[] | reverse(sort_by(@, &createdAt)) | [].[{startedAt: startedAt, pullStartedAt:pullStartedAt, pullStoppedAt:pullStoppedAt, createdAt: createdAt, taskArn: taskArn}]" \
    --output table

TASKS_SOCI=$(aws ecs list-tasks \
    --cluster $CLUSTER \
    --family $TASKDEF_SOCI \
    --region $REGION \
    --query 'taskArns[*]' \
    --output text)

aws ecs describe-tasks \
    --tasks $TASKS_SOCI \
    --region $REGION \
    --cluster $CLUSTER \
    --query "tasks[] | reverse(sort_by(@, &createdAt)) | [].[{startedAt: startedAt, pullStartedAt:pullStartedAt, pullStoppedAt:pullStoppedAt, createdAt: createdAt, taskArn: taskArn}]" \
    --output table