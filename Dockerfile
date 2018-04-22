FROM debian:stretch

RUN apt-get update; \
    apt-get install -y wget unzip openssh-client; \
    wget https://releases.hashicorp.com/vault/0.9.3/vault_0.9.3_linux_amd64.zip; \
    wget https://releases.hashicorp.com/vault/0.9.3/vault_0.9.3_linux_amd64.zip; \
    wget https://releases.hashicorp.com/envconsul/0.7.3/envconsul_0.7.3_linux_amd64.zip; \
    wget https://releases.hashicorp.com/terraform/0.11.7/terraform_0.11.7_linux_amd64.zip; \
    unzip vault_0.9.3_linux_amd64.zip; \
    unzip terraform_0.11.7_linux_amd64.zip; \
    unzip envconsul_0.7.3_linux_amd64.zip; \
    rm vault_0.9.3_linux_amd64.zip; \
    rm terraform_0.11.3_linux_amd64.zip; \
    rm envconsul_0.7.3_linux_amd64.zip; \
    mv ./terraform /bin; \
    mv ./envconsul /bin; \
    mv ./vault /bin

