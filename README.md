# concourse-deploy-cloudfoundry

Deploy Cloud Foundry with [omg](https://github.com/enaml-ops) in a Concourse pipeline.

## Prerequisites

1. [Git](https://git-scm.com)
1. [Vault](https://www.vaultproject.io)
1. [Concourse](http://concourse.ci)

## Steps to use this pipeline

1. Clone this repository.

    ```
    git clone https://github.com/enaml-ops/concourse-deploy-cloudfoundry.git
    ```

1. Copy the sample config file `deployment-vars-sample.json`.

    ```
    cd concourse-deploy-cloudfoundry
    cp deployment-vars-sample.json deployment-vars.json
    ```

1. Edit `deployment-vars.json`, adding the appropriate values.

    ```
    $EDITOR deployment-vars.json
    ```

    All available keys can be listed by querying the plugin.  If not specified in `deployment-vars.json`, default values will be used where possible.

    ```
    omg-linux deploy-product cloudfoundry-plugin-linux --help
    ```

1. Load your deployment vars into `vault`.  `VAULT_HASH` here and `vault_hash_vars` in `concourse-vars.yml` below must match.

    ```
    VAULT_ADDR=http://YOUR_VAULT_ADDR:8200
    VAULT_HASH=secret/cf-staging-vars
    vault write ${VAULT_HASH} @deployment-vars.json
    ```

1. Delete or move `deployment-vars.json` to a secure location.
1. Copy the concourse variables template.

    ```
    cp ci/concourse-vars-template.yml concourse-vars.yml
    ```

1. Edit `concourse-vars-template.yml`, adding appropriate values.

    ```
    $EDITOR concourse-vars.yml
    ```

    Note: If you are deploying Pivotal CF (PCF), you must add your `API Token` found at the bottom of your [Pivotal Profile](https://network.pivotal.io/users/dashboard/edit-profile) page.

1. Create or update the pipeline, either opensource or PCF.

    ```
    fly -t TARGET set-pipeline -p deploy-cloudfoundry -c ci/opensource-pipeline.yml -l concourse-vars.yml
    ```

    _or_

    ```
    fly -t TARGET set-pipeline -p deploy-cloudfoundry -c ci/pcf-pipeline.yml -l concourse-vars.yml
    ```

1. Delete or move `concourse-vars.yml` to a secure location.
1. Unpause the pipeline

    ```
    fly -t TARGET unpause-pipeline -p deploy-pcf
    ```

1. Trigger the deployment job and observe the output.

    ```
    fly -t TARGET trigger-job -j deploy-pcf/get-product-version -w
    fly -t TARGET trigger-job -j deploy-pcf/deploy -w
    ```


