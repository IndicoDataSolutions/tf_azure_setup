
# To use a static_ip

external_ip = "xxx.yyy.zzz.qqq"

# Connecting

ip_address=$(terraform output cluster_manager_ip)
terraform output private_key
get the text between << EOT >>

Paste into $HOME/.ssh/machine_name.pem
chmod 700 $HOME/.ssh/machine_name.pem

ssh -i $HOME/.ssh/machine_name.pem indico@${ip_address}
sudo bash

# execute the setup script
run all the commands in setup.sh

# setup variables
vi /home/indico/.indico

```
export ARM_CLIENT_ID=xxx
export ARM_SUBSCRIPTION_ID=xxx
export ARM_TENANT_ID=xxx
export ARM_CLIENT_SECRET=xxx

export VAULT_USERNAME=xxx
export VAULT_PASSWORD=xxx
export HARBOR_USERNAME=xxx
export HARBOR_PASSWORD=xxx
export IPA_RELEASE_TAG=6.7-customer-hotfix
```

source /home/indico/.indico

docker login -u $HARBOR_USERNAME -p $HARBOR_PASSWORD https://harbor.devops.indico.io

# login with the SPN
az login --service-principal -u $ARM_CLIENT_ID -p $ARM_CLIENT_SECRET --tenant $ARM_TENANT_ID
az account set --subscription $ARM_SUBSCRIPTION_ID

# Git clone the source
git clone https://github.com/IndicoDataSolutions/tf_cod.git

git checkout 6.7-customer-hotfix-1
cd tf_cod
cd=$(pwd)
docker run \
  --cap-add=CAP_IPC_LOCK \
  -e ARM_CLIENT_ID=${ARM_CLIENT_ID} \
  -e ARM_TENANT_ID=${ARM_TENANT_ID} \
  -e ARM_CLIENT_SECRET=${ARM_CLIENT_SECRET} \
  -e ARM_SUBSCRIPTION_ID=${ARM_SUBSCRIPTION_ID} \
  -e VAULT_USERNAME=${VAULT_USERNAME} \
  -e VAULT_PASSWORD=${VAULT_PASSWORD} \
  -it -v ${cd}:/app -v ${HOME}:/home/indico harbor.devops.indico.io/indico/indico-cod-install-azure:latest
  cd azure
  create overrides.tfvars
  rake -f /src/Rakefile init
  rake -f /src/Rakefile plan
