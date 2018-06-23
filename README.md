# PKS Master Gateway

![image](https://user-images.githubusercontent.com/106908/41807601-f0545490-770b-11e8-8b2e-57950fb9aa30.png)


### Create a `vm_extension` to attach a load balancer to the gateway

GCP
```
om --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
   --skip-ssl-validation \
   --username "${OPS_MGR_USR}" \
   --password "${OPS_MGR_PWD}" \
   create-vm-extension \
   --name pks-master-gateway \
   --cloud-properties '{"tags":["pks-dev", "pks-dev-pks-api", "pks-master-gateway"], "ephemeral_external_ip": true}'
```

AWS
```
om --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
   --skip-ssl-validation \
   --username "${OPS_MGR_USR}" \
   --password "${OPS_MGR_PWD}" \
   create-vm-extension \
   --name pks-master-gateway \
   --cloud-properties '{"elbs":["pks-master-gateway"]}'
```

```
om --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
   --skip-ssl-validation \
   --username "${OPS_MGR_USR}" \
   --password "${OPS_MGR_PWD}" \
   apply-changes \
   --ignore-warnings
```

## Deploy pks gateway

```
PKS_API_DEPLOYMENT=pivotal-container-service-191de86a18e2b8451374
PKS_CLIENT_SECRET=$(om \
    --target "https://${OPSMAN_DOMAIN_OR_IP_ADDRESS}" \
    --username "$OPS_MGR_USR" \
    --password "$OPS_MGR_PWD" \
    --skip-ssl-validation \
    curl \
    --silent \
    --path "/api/v0/deployed/products/${PKS_API_DEPLOYMENT}/credentials/.properties.pks_api_uaa_client" \
    -x GET \
    | jq -r '.credential.value.secret'
)
```

```
bosh -d pks-master-gateway deploy manifest/pks-master-gateway.yml \
  -v pks_api_deployment=${PKS_API_DEPLOYMENT} \
  -v pks_api_url=${PKS_API_URL} \
  -v pks_uaa_url=${UAA_URL} \
  -v pks_uaa_client_id=pks_client \
  -v pks_uaa_client_secret=${PKS_CLIENT_SECRET} \
  -v pks_master_gateway_subdomain=pks.example.com \
  -v gw_vm_type=small \
  -v gw_vm_extension=pks-master-gateway \
  -v gw_az=asia-northeast1-a \
  --no-redact
```

### Development

```
./add-blobs.sh
bosh create-release --name=pks-master-gateway --force --timestamp-version --tarball=/tmp/pks-master-gateway-boshrelease.tgz
bosh upload-release /tmp/pks-master-gateway-boshrelease.tgz
```