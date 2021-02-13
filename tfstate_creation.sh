#!/bin/bash

set -e

export LOCATION=koreacentral
export RESOURCE_GROUP_NAME=terraform-ref-rg
export STORAGE_ACCOUNT_NAME=zerotfstate
export CONTAINER_NAME=zerotfstatecont
# export AKV_NAME=terraform-ref-kv

# Create resource group
az group create --name $RESOURCE_GROUP_NAME --location $LOCATION

# Create the storage account
if ( `az storage account check-name --name $STORAGE_ACCOUNT_NAME --query 'nameAvailable'` == "true" );
then
    echo "Creating $STORAGE_ACCOUNT_NAME storage account..."
    az storage account create -g $RESOURCE_GROUP_NAME -l $LOCATION \
    --name $STORAGE_ACCOUNT_NAME \
    --sku Standard_LRS \
    --encryption-services blob
    echo "Storage account $STORAGE_ACCOUNT_NAME created."
else
    echo "Storage account $STORAGE_ACCOUNT_NAME exists..."
fi

# Retrieve the storage account key
echo "Retrieving storage account key..."
ACCOUNT_KEY=$(az storage account keys list --resource-group $RESOURCE_GROUP_NAME --account-name $STORAGE_ACCOUNT_NAME --query [0].value -o tsv)
echo "Storage account key retrieved."

# Create a storage container (for the Terraform State)
if ( `az storage container exists --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY --query exists` == "true" );
then
    echo "Storage container $CONTAINER_NAME exists..."
else
    echo "Creating $CONTAINER_NAME storage container..."
    az storage container create --name $CONTAINER_NAME --account-name $STORAGE_ACCOUNT_NAME --account-key $ACCOUNT_KEY
    echo "Storage container $CONTAINER_NAME created."
fi

echo "storage_account_name: $STORAGE_ACCOUNT_NAME"
echo "container_name: $CONTAINER_NAME"
echo "access_key: $ACCOUNT_KEY"