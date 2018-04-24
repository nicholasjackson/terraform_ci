# DigitalOcean Tide 2018, Collaborating with Terraform
Example code for creating basic resources in Digital Ocean using workspaces, with multiple environments using Terraform workspaces and CircleCI to build and deploy the infrastructure.

## Configuration
In order to run Terraform it requires certain environment variables to be set to interact with the Digital Ocean APIs.  In addition to the main API key this example uses Digital Ocean spaces to store the terraform state.  State is what terraform uses to manage the difference from the infrastructure which currently exists and that which will be created as defined in the configuration.  Normally Terraform will store state files on the disk where `terraform apply` is run.  When collaborating on infrastructure as code with a Team the state needs to be accessible to all users of the configuration.  Remote state enables this by transparently storing the state files in Digital Ocean Spaces rather than using the local disk.

```bash
# Digital Ocean Spaces Variables, uses S3 Backend# Digital Ocean Spaces Variables, uses S3 Backend# Digital Ocean Spaces Variables, uses S3 Backend
export AWS_ACCESS_KEY_ID=xxxxxxxxxxxxx
export AWS_SECRET_ACCESS_KEY=xxxxxxxxxxxxxxx

# Digital Ocean Token for Proviver
export DIGITALOCEAN_TOKEN=xxxxxxxxxxxxxxxxxxxxxx
```

## Branches
The example takes the approach of a branch per environment, the following branches are defined in this configuration.

* dev - Development Environment
* staging - Staging Environment
* production - Production Environment

## Workspaces
In order to use multiple branches with our Remote State we can leverage the Terraform Workspaces features.  Workspaces allow you to create separate state files for each branch.  To create a new workspace we can use the command `terraform workspace new workspace_name`.  This will bootstrap our workspace and ensure that the state for our different environments is kept separate.  You can run the `workspace new` command once for each of your environments.

To see a list of current workspaces you can also use `terraform workspace list`

```bash
$ terraform workspace list
  default
* dev
  master
  staging
```

## CI
The CircleCI configuration file can be found at [.circleci/config.yml](.circleci/config.yml)

The workflow for the CI build is split into three steps:

* plan (generate a plan of changes to make)
* approve (manual approval of plan)
* apply (apply the plan and change the infrastructure)

### Plan
The following example is from the CircleCI configuration for the plan step:

```yaml
  plan:
    docker:
      - image: nicholasjackson/hashicorp-ci:latest
    steps:
      - checkout
      - run:
          command: mkdir plan
      - run:
          name: Terraform plan
          command: |
            mkdir -p plan
            terraform version
            terraform init
            terraform workspace select ${CIRCLE_BRANCH} 
            terraform plan -out=plan/${CIRCLE_BRANCH}.out
      - persist_to_workspace:
          root: ./
          paths:
            - plan/
            - .terraform
```

The step is using a custom docker image which has the Terraform command line tool installed.  The run step executes `terraform init`, this will download the various plugins that Terraform requires.  
We then select the workspace to ensure we are using the correct state, the workspaces are named the same as the branches in the GitHub repository.  
Then we can run a plan, the plan file is saved to the output folder for use later on in the apply step.  
All of the plugins and the plan are temporarily persisted to CircleCI's workspaces, this allows us to load them in the apply step.

### Apply

```yaml
  apply-manual:
    docker:
      - image: nicholasjackson/hashicorp-ci:latest
    steps:
      - checkout
      - attach_workspace:
          at: /tmp/workspace
      - run:
          name: Terraform apply
          command: |
            cp -R /tmp/workspace/.terraform .
            terraform apply /tmp/workspace/plan/${CIRCLE_BRANCH}.out
```

The apply job, first loads the workspace which was previously saved in the plan step.  
We then copy the terraform plugins so that they do not need to be downloaded again.  
Finally we can run `terraform apply`, we are loading the plan which was output in the previous apply job, this ensures that the changes we are making are exactly those calculated by the previous job, and approved with the approve step.
