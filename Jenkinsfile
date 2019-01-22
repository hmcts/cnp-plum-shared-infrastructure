#!groovy
import groovy.json.JsonSlurper

@Library('Infrastructure') _

properties([
    parameters([
        string(name: 'PRODUCT_NAME', defaultValue: 'plum', description: ''),
        string(name: 'ENVIRONMENT', defaultValue: 'sandbox-v2', description: 'Suffix for resources created'),
        choice(name: 'SUBSCRIPTION', choices: 'sandbox\nnonprod\nprod', description: 'Azure subscriptions available to build in'),
        booleanParam(name: 'PLAN_ONLY', defaultValue: false, description: 'set to true for skipping terraform apply')
    ])
])


productName = params.PRODUCT_NAME
subscription = params.SUBSCRIPTION
environment = params.ENVIRONMENT
planOnly = params.PLAN_ONLY

echo "Building '${productName}' in '${environment}'"

node {
  env.PATH = "$env.PATH:/usr/local/bin"
  def az = { cmd -> return sh(script: "env AZURE_CONFIG_DIR=/opt/jenkins/.azure-$subscription az $cmd", returnStdout: true).trim() }

  stageCheckout('git@github.com:hmcts/cnp-plum-shared-infrastructure.git')

withSubscription(subscription) {
    spinInfra(productName, environment, planOnly, subscription)

  }
}
