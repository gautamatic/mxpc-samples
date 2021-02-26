# Mendix MXPC Reference: Basic Setup

## Run mxpc basic setup script against your Azure subscription

1. Get the git repo

    > 
        git clone 'https://myrepo.git.com'
        cd /my/dir`
        mv terraform.tfvars.example terraform.tfvars
 
2. Edit the `terraform.tfvars` file to enter your credentials and tweak the variables, as needed.

3. With terraform installed on your machine, plan and apply the script.
    > 
        terraform init
        terraform apply

3. Copy the output section. These pieces of information will be needed while running the MXPC cluster installation script. 


## Expected Result
1. The script will create MSSQL database, storage account, container registry, vnet, subnet and other resources within your Azure subscription

2. Names of the resources will be derived from the `prefix` variable set in the `terraform.tfvars` file

3. For resources that need to have a unique name, a short random string will be appended to the name

4. All relevant URIs, credentials and commands will be available in the output section. 

5. The tag `mxpc = <prefix variable>` can be used to find all the resources that were generated by this script


## Cleanup
> terraform destroy



## TODO manual steps within AKS
- creating minio. mapping it to the storage
- creating ingress
- pointing DNS record to public IP of ingress. This DNS name is needed while running the Mendix cluster installation script
- creating cert manager 



## TODO manual steps within MXPC Mendix cluster installation script
- entering database info
- entering storage info (needs to point to minio)
- entering ingress info