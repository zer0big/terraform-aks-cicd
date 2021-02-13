#!/bin/bash

set -e

export loc=koreacentral
export rgName=terraform-ref-rg
export tfstateSaName=zerotfstate
export tfstateContName=zerotfstatecont
# export akvName=terraform-ref-kv

# Create the storage account
if ( `az storage account check-name --name $tfstateSaName --query 'nameAvailable'` == "true" );
then
    echo "Creating $tfstateSaName storage account..."
    az storage account create -g $rgName -l $loc \
    --name $tfstateSaName \
    --sku Standard_LRS \
    --encryption-services blob
    echo "Storage account $tfstateSaName created."
else
    echo "Storage account $tfstateSaName exists..."
fi

# Retrieve the storage account key
echo "Retrieving storage account key..."
accKey=$(az storage account keys list --resource-group $rgName --account-name $tfstateSaName --query [0].value -o tsv)
echo "Storage account key retrieved."

# Create a storage container (for the Terraform State)
if ( `az storage container exists --name $tfstateContName --account-name $tfstateSaName --account-key $accKey --query exists` == "true" );
then
    echo "Storage container $tfstateContName exists..."
else
    echo "Creating $tfstateContName storage container..."
    az storage container create --name $tfstateContName --account-name $tfstateSaName --account-key $accKey
    echo "Storage container $tfstateContName created."
fi