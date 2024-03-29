
# To use a static_ip

external_ip = "xxx.yyy.zzz.qqq"

# Connecting

ip_address=$(terraform output cluster_manager_ip)
terraform output private_key
get the text between << EOT >>

Paste into $HOME/.ssh/machine_name.pem

ssh -i $HOME/.ssh/machine_name.pem indico@${ip_address}

# execute the setup script
source setup.sh

# Git clone the source
git clone https://github.com/IndicoDataSolutions/tf_cod.git
chmod 777 -R tf_cod
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
