if [ ! -f setup/deployment-props.json ]; then
  echo "Creating setup/deployment-props.json"
  cp samples/deployment-props-sample.json setup/deployment-props.json
fi

if [ ! -f setup/setup-vault.sh ]; then
  echo "Creating setup/setup-vault.sh"
  cp samples/setup-vault-sample.sh setup/setup-vault.sh
fi

if [ ! -f setup/oss-pipeline-vars.yml ]; then
  echo "Creating setup/oss-pipeline-vars.yml"
  cp samples/oss-pipeline-vars.yml setup/oss-pipeline-vars.yml
fi

if [ ! -f setup/pcf-pipeline-vars.yml ]; then
  echo "Creating setup/pcf-pipeline-vars.yml"
  cp samples/pcf-pipeline-vars-template.yml setup/pcf-pipeline-vars.yml
fi
echo "!!!!!!!!!!!!!      BEFORE PROCEEDING      !!!!!!!!!!!!!!!!!"
echo "PLEASE MODIFY THE VALUES IN THE FILES IN the 'setup' directory TO MATCH YOUR SYSTEM"
echo
echo
echo "to seed vault with your desired values please run:"
echo "./setup/setup-vault.sh"
echo
echo
echo "to upload the oss pipeline please run:"
echo "$> fly -t CF-Concourse set-pipeline -p deploy-oss-cloudfoundry -c ci/opensource-pipeline.yml -l setup/oss-pipeline-vars.yml"
echo 
echo "to upload the pcf pipeline please run:"
echo "$> fly -t CF-Concourse set-pipeline -p deploy-pct-ert -c ci/pcf-pipeline.yml -l setup/pcf-pipeline-vars.yml"
