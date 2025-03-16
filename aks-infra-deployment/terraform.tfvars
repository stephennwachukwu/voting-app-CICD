# Resource Group
resource_group_name = "stancorp_aks-acr_EUS"
location            = "East US"

# Networking
vnet_name           = "aks-acr-vnet-EUS"
vnet_address_space  = ["10.100.0.0/16"]
subnets = {
  "aks-subnet"    = ["10.100.4.0/24"]
  "acr-pe-subnet" = ["10.100.5.0/24"]  # For ACR private endpoint
}

# AKS
cluster_name               = "my-aks-cluster"
use_managed_identity       = true
kubernetes_version         = "1.27.7"
default_node_pool_vm_size  = "Standard_DS2_v2"

# # Optional: Define additional node pools
# additional_node_pools = {
#   "userpool" = {
#     vm_size = "Standard_DS3_v2"
#     node_count = 1
#     enable_auto_scaling = true
#     min_count = 1
#     max_count = 3
#     vnet_subnet_id = "" # Will be filled by module reference
#     tags = {
#       NodePoolType = "User"
#     }
#   }
# }

# ACR
acr_name          = "mycompanyaksacr"
acr_sku           = "Standard"  # For private link support
acr_admin_enabled = false

# ACR Network Configuration (Premium only)
acr_public_network_access_enabled = false  # For maximum security
acr_network_rule_set = {
  default_action        = "Deny"
  ip_rules              = ["203.0.113.0/24"]  # Corporate IP range
  virtual_network_rules = []
}

# ACR Geo-replication (Premium only)
acr_georeplications = [
  {
    location                = "West US"
    zone_redundancy_enabled = true
    tags                    = { "Replica" = "WestUS" }
  }
]

# Tags
environment = "Production"
project     = "AKS-ACR-Deployment"

