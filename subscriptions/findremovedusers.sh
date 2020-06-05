# This script will locate users that have been removed from AAD but still have permissions on subscriptions (Typically shows up as "Identity not found.")

subscriptions=$(az account list --output tsv --query "[?state=='Enabled'].id")

for subscription in $subscriptions; do
    az account set --subscription $subscription
    subscriptionName=$(az account show --output tsv --query name)

    lines=$(az role assignment list -o tsv --query "[?principalName==''].{principalName:principalName}" | wc -l)
    if (($lines > 0)); then
        echo "#################   $subscriptionName needs cleaning"
    else
        echo "Nothing to do: $subscriptionName"
    fi
done
