#!/bin/bash

function canary_deploy {

  kubectl apply -f green.yml
  # Check deployment rollout status every 1 second until complete.
  ATTEMPTS=0
  ROLLOUT_STATUS_CMD="kubectl rollout status deployment/green -n udacity"
  until $ROLLOUT_STATUS_CMD || [ $ATTEMPTS -eq 60 ]; do
    $ROLLOUT_STATUS_CMD
    ATTEMPTS=$((attempts + 1))
    sleep 1
  done
  echo "Green deployment successful!"
}

# Initialize canary-v2 deployment
kubectl apply -f canary-v2.yml

sleep 1
# Begin canary deployment
while [ $(kubectl get pods -n udacity | grep -c canary-v1) -gt 0 ]
do
  canary_deploy
  manual_verification
done

echo "Canary deployment of v2 successful"


