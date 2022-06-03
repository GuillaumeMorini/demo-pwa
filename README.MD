# Commands

## Deploy

export GOOGLE_APPLICATION_CREDENTIALS="./sa.json"
gcloud auth activate-service-account --key-file=$GOOGLE_APPLICATION_CREDENTIALS --project=$PROJECT
helm upgrade --install "demo" ./helm/website --set application.deploymentVersion="$(date +'%s')" -f ./global.yaml -f ./pwa.yaml --namespace="default" --disable-openapi-validation --atomic
kubectl -n default rollout status deployment.apps/demo-website-pwa-deployment

## Test

1. Launch ```while [ true ]; do echo "$(date) - $(curl -sI http://130.211.11.19 | head -1)"; sleep 0.5; done```
2. Create new deployment (cf helm upgrade)
3. Observe errors 502