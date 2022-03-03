#!/bin/sh

echo "--- :rocket: Deploy to DEV CloudRun..."

echoerr() { echo "$@" 1>&2; }

gcloud auth activate-service-account --key-file="/.google-credentials"

echo "Apply secrets..."
version=$(cat secret_version_state)
if [ -n "$version" ]; then
    echo "using versioned secret [$version]"
else
    version=latest
    echo "using latest secret [$version]"
fi
echo "secret version is $version"
sed -i -e "s/secret_version_state/$version/g" appconfig.yaml


echo "Apply image... [$IMAGE_PATH]"
sed -i -e "s/docker_image/$IMAGE_PATH/g" appconfig.yaml

echo "Apply SERVICE_NAME... [$SERVICE_NAME]"
sed -i -e "s/SERVICE_NAME/$SERVICE_NAME/g" appconfig.yaml

echo "Apply GCP_REGION..."
sed -i -e "s/GCP_REGION/$GCP_REGION/g" appconfig.yaml

echo "--- :rocket: Deploying Service..."
cat appconfig.yaml
gcloud run services replace appconfig.yaml --project=$GCP_PROJECT

ret=$?
echo "Status is $ret"
if [ $ret -ne 0 ]; then
    echoerr "Failed to Deploy Cloudrun Service..."
    exit 1
fi

echo "--- :rocket: Apply Policy..."
printf 'yes' | gcloud run services --region=$GCP_REGION --project=$GCP_PROJECT set-iam-policy $SERVICE_NAME policy.yaml