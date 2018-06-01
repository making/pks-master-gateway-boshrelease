
```
./add-blobs.sh
bosh create-release --name=pks-master-gateway --force --timestamp-version --tarball=/tmp/pks-master-gateway-boshrelease.tgz
```

```
bosh -d pks-master-gateway deploy pks-master-gateway.yml \
  -v pks_api_url=${PKS_API_URL} \
  -v pks_uaa_url=${UAA_URL} \
  -v pks_uaa_client_id=pks_client \
  -v pks_uaa_client_secret=${PKS_CLIENT_SECRET} \
  -v pks_master_gateway_subdomain=your-domain.example.com \
  --no-redact
```