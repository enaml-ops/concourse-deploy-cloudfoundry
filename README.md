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

1. Initialize the repo for your deployment.

    ```
    cd concourse-deploy-cloudfoundry
    ./init.sh
    ```

1. Edit `setup/deployment-props.json`, adding the appropriate values.

    This file is used to populate a `vault` hash.  It holds the BOSH credentials for both `omg` (username/password) and the Concourse `bosh-deployment` (UAA client) resource.

    ```
    $EDITOR deployment-props.json
    ```

    `omg` will also read other key/value pairs added here, matching them to command-line arguments.  For example, to add the `omg` plugin parameter `--syslog-address`, you could add `"syslog-address": "10.150.12.10"` here rather than modifying the manifest generation script in `ci/tasks`.

    All available parameters/keys can be listed by querying the plugin.  If not specified in `deployment-props.json`, default values will be used where possible.


    ```
    omg-linux deploy-product ert-1-8-linux --help
    ```

1. Edit `setup/(oss|pcf)-pipeline-vars.yml`
    These files are the open source and pcf equivalents of each other. Choose
    which type of deployment you would like and complete the values for your
    environment

1. Create or update the pipeline, either opensource or PCF.

    ```
    fly -t CF-Concourse set-pipeline -p deploy-oss-cloudfoundry -c ci/opensource-pipeline.yml -l setup/oss-pipeline-vars.yml --var "vault-json-string=$(cat setup/deployment-props.json)"
    ```

    _or_

    ```
    fly -t CF-Concourse set-pipeline -p deploy-pcf-ert-1.8 -c ci/pcf-pipeline.yml -l setup/pcf-pipeline-vars.yml --var "vault-json-string=$(cat setup/deployment-props.json)"
    fly -t CF-Concourse trigger-job -j deploy-pcf-ert-1.8/load-vault-properties -w
    ```

1. Delete or move `setup/*` to a secure location.
    These files are gitignored, but might contain sensitive information and
    great care should be taken in how/where/if these are kept

1. Trigger the deployment job and observe the output.

    ```
    fly -t TARGET trigger-job -j deploy-pcf/deploy -w
    ```

