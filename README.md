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
