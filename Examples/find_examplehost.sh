#!/usr/bin/env bash

source ssh-dynconf-init

ssh_port="$(
    echo "$(id -u)12345" |
        cut -c1-5
)"

# echo "\${PWD}"

# exit 0
nodes=(
    "127.0.0.1"
    "some-host-name"
    "some-other-host-name"
)

available_hosts=(
    $(
        ssh_available_hosts \
            --hosts ${nodes[@]} \
            --port "${ssh_port}" \
            --timeout 2
    )
)

if [ "${#available_hosts[@]}" -eq 0 ]; then
    echo "Host not found!">&2
    exit 0
fi

hostname="$(
    ssh_host_name \
        --host "${available_hosts[0]}"
)"
username="root"

# Set hostname in ./examplehost-config
ssh_config_update \
    --action add \
    --keyword hostname \
    --value "${hostname}" \
    --file "./examplehost-config"

# Set port in ./examplehost-config
ssh_config_update \
    --action add \
    --keyword port \
    --value "${ssh_port}" \
    --file "./examplehost-config"

# Set username in ./examplehost-config
ssh_config_update \
    --action add \
    --keyword user \
    --value "${username}" \
    --file "./examplehost-config"

# Set identityfile in ./examplehost-config
ssh_config_update \
    --action add \
    --keyword IdentityFile \
    --value "\${PWD}/id_rsa" \
    --file "./examplehost-config"

exit 0
