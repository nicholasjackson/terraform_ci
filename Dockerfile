FROM debian:stretch

RUN apt-get update; \
    apt-get install -y wget unzip openssh-client; \
    wget https://releases.hashicorp.com/vault/1.1.3/vault_1.1.3_linux_amd64.zip; \
    wget https://releases.hashicorp.com/vault/1.1.3/vault_1.1.3_linux_amd64.zip; \
    wget https://releases.hashicorp.com/envconsul/0.8.0/envconsul_0.8.0_linux_amd64.zip; \
    wget https://releases.hashicorp.com/terraform/0.12.2/terraform_0.12.2_linux_amd64.zip; \
    unzip vault_1.1.3_linux_amd64.zip; \
    unzip terraform_0.12.2_linux_amd64.zip; \
    unzip envconsul_0.8.0_linux_amd64.zip; \
    rm vault_1.1.3_linux_amd64.zip; \
    rm terraform_0.12.2_linux_amd64.zip; \
    rm envconsul_0.8.0_linux_amd64.zip; \
    mv ./terraform /bin; \
    mv ./envconsul /bin; \
    mv ./vault /bin

