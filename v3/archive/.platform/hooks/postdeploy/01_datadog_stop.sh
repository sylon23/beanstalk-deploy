#!/bin/bash
export AWS_REGION=eu-west-1
SSM_PARAM_NAME="datadog_started"
LOG_FILE="/var/log/datadog_status.log"

date | tee -a $LOG_FILE
echo "Evaluating intended state of datadog..."
DATADOG_START=$(aws ssm get-parameter --name "$SSM_PARAM_NAME" --region $AWS_REGION  --query "Parameter.Value" --output text)
echo "DATADOG_START is: $DATADOG_START"

if [ "$DATADOG_START" == "true" ]; then
  echo "$(date) - SSM Parameter is true. Starting Datadog agent..." | tee -a "$LOG_FILE"
  sudo docker start current-datadog-agent-1

elif [ "$DATADOG_START" == "false" ]; then
  echo "$(date) - SSM Parameter is false. Stopping Datadog agent..." | tee -a "$LOG_FILE"
  sudo docker stop current-datadog-agent-1

else
  echo "$(date) - SSM Parameter is not recognized: $DATADOG_START" | tee -a "$LOG_FILE"
fi
