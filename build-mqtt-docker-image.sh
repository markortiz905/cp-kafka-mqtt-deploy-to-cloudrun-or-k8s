#!/bin/sh

echo "--- :rocket: Build and Deploy Mqtt Proxy Image ..."
gcloud auth activate-service-account --key-file="${HOME}/.google-credentials"
gcloud config set project $GCP_PROJECT

docker build -f Dockerfile.buildMqttProxy -t $SCG_CONTAINER_REGISTRY/$BUILDKITE_PIPELINE_SLUG:$BUILDKITE_BUILD_NUMBER .
docker push $SCG_CONTAINER_REGISTRY/$BUILDKITE_PIPELINE_SLUG:$BUILDKITE_BUILD_NUMBER

docker image tag $SCG_CONTAINER_REGISTRY/$BUILDKITE_PIPELINE_SLUG:$BUILDKITE_BUILD_NUMBER $SCG_CONTAINER_REGISTRY/$BUILDKITE_PIPELINE_SLUG:latest
docker push $SCG_CONTAINER_REGISTRY/$BUILDKITE_PIPELINE_SLUG:latest