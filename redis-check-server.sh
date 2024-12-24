#!/bin/bash

cd /home/master/applications

for A in $(ls | awk '{print $NF}'); do
    echo "Processing application: $A"
    cd /home/master/applications/$A/public_html/ || { echo "Failed to change directory to $A/public_html"; continue; }

    if wp redis info --allow-root; then
        status="Enabled"
        echo "$A: $status"
    else
        status="Failed"
        echo "$A: $status"
    fi

    # Log the result to the API
    curl -X POST -H "Content-Type: application/json" -d '{"ip"::"'"curl ifconfig.me"'",application":"'"$A"'","status":"'"$status"'"}' https://phpstack-1246017-4482242.cloudwaysapps.com/applications

    cd /home/master/applications || { echo "Failed to change back to /home/master/applications"; exit 1; }
done
