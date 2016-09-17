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

1. Copy the sample config file `deployment-props-sample.json`.

    ```
    cd concourse-deploy-cloudfoundry
    cp deployment-props-sample.json deployment-props.json
    ```

1. Edit `deployment-props.json`, adding the appropriate values.

    This file is used to populate a `vault` hash.  It holds the BOSH credentials for both `omg` (username/password) and the Concourse `bosh-deployment` (UAA client) resource.

    ```
    $EDITOR deployment-props.json
    ```

    `omg` will also read other key/value pairs added here, matching them to command-line arguments.  For example, to add the `omg` plugin parameter `--syslog-address`, you could add `"syslog-address": "10.150.12.10"` here rather than modifying the manifest generation script in `ci/tasks`.

    All available parameters/keys can be listed by querying the plugin.  If not specified in `deployment-props.json`, default values will be used where possible.


    ```
    omg-linux deploy-product cloudfoundry-plugin-linux --help
    ```

1. Load your deployment properties into `vault`.  `VAULT_HASH` you define here and `vault_hash_misc` in `pipeline-vars.yml` below must match.  You may consider using the `vault` hash here to hold common settings, referenced by multiple `omg`-based deployments.  In such a case, you might name the hash something like `secret/nonprod-common-props`.

    ```
    export VAULT_ADDR=http://YOUR_VAULT_ADDR:8200
    export VAULT_HASH=secret/cf-nonprod-props
    vault write $VAULT_HASH @deployment-props.json
    ```

1. Delete or move `deployment-props.json` to a secure location.
1. Copy the pipeline variables template.

    ```
    cp pipeline-vars-template.yml pipeline-vars.yml
    ```

1. Edit `pipeline-vars.yml`, adding appropriate values.

    ```
    $EDITOR pipeline-vars.yml
    ```

    Note: If you are deploying Pivotal CF (PCF), you must add your `API Token` found at the bottom of your [Pivotal Profile](https://network.pivotal.io/users/dashboard/edit-profile) page.

1. Create or update the pipeline, either opensource or PCF.

    ```
    fly -t TARGET set-pipeline -p deploy-cloudfoundry -c ci/opensource-pipeline.yml -l pipeline-vars.yml
    ```

    _or_

    ```
    fly -t TARGET set-pipeline -p deploy-pcf -c ci/pcf-pipeline.yml -l pipeline-vars.yml
    ```

1. Delete or move `pipeline-vars.yml` to a secure location.
1. Unpause the pipeline

    ```
    fly -t TARGET unpause-pipeline -p deploy-pcf
    ```

1. Trigger the deployment job and observe the output.

    ```
    fly -t TARGET trigger-job -j deploy-pcf/get-product-version -w
    fly -t TARGET trigger-job -j deploy-pcf/deploy -w
    ```

