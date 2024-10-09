#!/usr/bin/env bash

SCRIPT_DIR=$( cd -- "$( dirname -- "${BASH_SOURCE[0]}" )" &> /dev/null && pwd )

echo Installing Developer Tools...
#sleep 1

for full_path in "${SCRIPT_DIR}/scripts/"*".sh"; do

    filename=$(basename -- "${full_path}")
    app_name="${filename%.*}"
    
    echo -e "\t > Installing app: ${app_name}";
    sudo ln -s "${full_path}" /usr/local/bin/;

done

echo "Finished!"
