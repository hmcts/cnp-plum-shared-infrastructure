# cnp-plum-shared-infrastructure

This repository contains the shared the common infra components per Environment (persistent) for Plum

- Application Insights
- Azure Key Vault
- Storage Account
- Traffic Manager
- Application Gateway (legacy)

# cnp-plum-shared-infrastructure-{env}{DT}

This repository contains the shared the common infra components per Deployment Target for Plum

- Application Gateway (DT)
- App Service Plan (DT)
- Storage Account (DT)


## Traffic Manager

This module builds Traffic Manager which points to Application Gateway endpoints which then points to the hostname of the web app.

## Speech Storage networking (sandbox)

The Jenkins subnet lookups use `mgmt_subscription_id` for the PTLsbox subscription,
with `cft-ptlsbox-vnet` in `cft-ptlsbox-network-rg`. The application subnet lookups
remain in `cft-sbox-vnet` in `cft-sbox-network-rg`, using `aks_subscription_id`.