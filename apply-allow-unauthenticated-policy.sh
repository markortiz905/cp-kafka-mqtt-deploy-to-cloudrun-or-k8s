#!/bin/sh

echo "--- :rocket: Apply Policy..."
printf 'yes' | gcloud run services --region=$GCP_REGION --project=$GCP_PROJECT set-iam-policy $SERVICE_NAME policy-allow-no-auth.yaml