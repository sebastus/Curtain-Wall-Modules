# Azure DevOps Build Agent - Helm Chart

This chart deploys all the necessary resources for a pool of self hosted build agents on Kubernetes.

The chart has the following values that can be modified at install/upgrade time.

| Parameter | Description |
|-|-|
| **image.repository** | The full image name (including the hosting repository) |
| **image.pullPolicy** | The pullPolicy used to get the image (defaults to IfNotPresent) |
| **image.tag** | The tag of the image to use |
| **azdo.url** | The url of the Azure DevOps Organisation |
| **azdo.agentManagementToken** | A Personal Access Token (PAT) from Azure DevOps with permissions to manage Agent Pools |
| **azdo.pool.name** | The name of the agent pool to add the agents to |
| **scaledJob.pollingInterval** | How frequently will the scaler check to see if new agents are required (in seconds) |
| **scaledJob.maxReplicaCount** | The maximum number of replicas/agents that the scaler will scale to |
| **scaledJob.ttlSecondsAfterFinished** | The number of seconds the job will stay around in a Completed state before being removed (defaults to 60)|
| **imageCredentials.registry** | The container repository to fetch the images from |
| **imageCredentials.username** | The username to authenticate with the container repository |
| **imageCredentials.password** | The password to authenticate with the container repository |
| **agentPoolNodeSelector** | Which Node Pool should these agents run on (defaults to the "default" pool)? |


The Agents use the KEDA Scaler [see here for more details](https://keda.sh/docs/2.8/scalers/azure-pipelines/).
The scaler can either be deployed as a Deployment or a Job.  We are using Jobs because the agents are cleaned up after a single use.  The helm chart deploys a single pod agent that is set to disabled, this is to overcome a limitation with Azure DevOps where it cannot schedule pipelines if there are no agents in the pool.  [For more information see here](https://keda.sh/blog/2021-05-27-azure-pipelines-scaler/).  The placeholder agent should never run pipelines and if deleted will need to be reinstated by running the Deploy Agents pipeline.


