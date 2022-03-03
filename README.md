[![Build status](https://badge.buildkite.com/b5e100ec73a04a809861da57daba7834e7cc6a29f34ed1181c.svg)](https://buildkite.com/scentregroup/sg-cp-kafka-mqtt)

## 🍀 Kafka Mqtt Proof of Solution

This pos provides basic solution to ingest data into mqtt as proxy to kafka confluent using an existing docker image.This is best used with IOT cases.

### Stack
![Docker](https://img.shields.io/badge/docker-%2357A143.svg?style=for-the-badge&logo=docker&logoColor=white) ![kafka](https://img.shields.io/badge/kafka-%2357A143.svg?style=for-the-badge&logo=kafka&logoColor=white) ![MQTT](https://img.shields.io/badge/mqtt-%2357A143.svg?style=for-the-badge&logo=mqtt&logoColor=white) ![Shell](https://img.shields.io/badge/shell-%2357A143.svg?style=for-the-badge&logo=shell&logoColor=white) 

### Configs
```
KAFKA_MQTT_BOOTSTRAP_SERVERS: pkc-4vndj.australia-southeast1.gcp.confluent.cloud:9092
KAFKA_MQTT_TOPIC_REGEX_LIST: nextgen.poc.hvac_sensor_data.event.hip:nextgen
KAFKA_MQTT_KEY_DESERIALIZER: org.apache.kafka.common.serialization.StringDeserializer
KAFKA_MQTT_VALUE_DESERIALIZER: org.apache.kafka.common.serialization.StringDeserializer
KAFKA_MQTT_LISTENERS: 0.0.0.0:1883
KAFKA_MQTT_PRODUCER_CLIENT_ID: nextgen.cnd
KAFKA_MQTT_PRODUCER_GROUP_ID: scg
KAFKA_MQTT_PRODUCER_SECURITY_PROTOCOL: SASL_SSL
KAFKA_MQTT_PRODUCER_SASL_MECHANISM: PLAIN
KAFKA_MQTT_PRODUCER_SASL_JAAS_CONFIG: org.apache.kafka.common.security.plain.PlainLoginModule required username="**" password="**";
```

### Secrets Manager and Vault
- Just like GKE that uses configs and secrets, Cloudrun uses Secrets Manager of GCP
- Pipeline will pull secret values from Vault and use that value to create revision in secret manager
- Once revision is available then we can refer that revision as "key" in yaml file, you can refer to "KAFKA_MQTT_PRODUCER_SASL_JAAS_CONFIG" env variable from appconfig.yaml file
- For best practices we should always tie up specific secret revision number to specific docker image tag (should not use :latest tag if possible to avoid headaches )

### Service Account
- buildkite uses buildkite-sa provided by infra team (roles and permission already provided), this SA is used to deploy resource to GCP, create secrets and add revisions.
- cloudrun by default uses the default compute service account (roles and permission to pull secrets from secret manager already provided)
- use - cloudrun-mqtt-proxy-user@scg-hip-dev.iam.gserviceaccount.com - to authenticate your request to mqtt-proxy service.

### Deployments
- This can be deployed to Cloudrun using preconfigured buildkite scripts, by default policy apllied will require authentication but theres an option in buildkite to allow unauthenticated if needed.
- can also be deployed to gke using provided k8s.yaml files.

