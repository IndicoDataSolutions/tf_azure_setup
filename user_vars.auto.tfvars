

# to set a static external IP address
# external_ip = "xxx.yyy.zzz.qqq"

resource_group_name = "bread-pre-existing"

label               = "breadnetwork" # prefix name on resources
region              = "eastus"     
network_type        = "create"

virtual_network_name  = "breadwt-vnet"
virtual_subnet_name   = "breadwt-subnet"
