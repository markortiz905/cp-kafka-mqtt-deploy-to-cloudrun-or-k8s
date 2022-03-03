#!/bin/sh

echo "--- :rocket: Update/Create Secrets ..."

addRevisionTo() {
    printenv | grep $1 | sed -En "s/$1=//p" |  \
        gcloud secrets versions add $1 \
        --project=$2  --data-file=-

    revisions_total=$(gcloud secrets describe $1/versions --format="value(totalSize)")
    echo "Total revisions [$revisions_total] for secret name [$1]"
    echo $revisions_total >> secret_version_state
}

gcloud auth activate-service-account --key-file="/.google-credentials"
gcloud config set project $GCP_PROJECT
gcloud config list

gcloud secrets describe projects/$GCP_PROJECT/secrets/$SECRET_NAME
ret=$?

#we can also loop over list of secret names here, in the future.
if [ $ret -ne 0 ]; then
    gcloud secrets create $SECRET_NAME --replication-policy="user-managed" --locations=$GCP_REGION --project=$GCP_PROJECT #create new secret
fi

addRevisionTo $SECRET_NAME $GCP_PROJECT