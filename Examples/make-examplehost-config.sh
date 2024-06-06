#!/usr/bin/env bash

source ssh-dynconf-init

# Get port from the ssh command
ssh_port="${1}"

example_config_file="examplehost-config"

# List of addresses to check
addresses=(
    "127.0.0.1"
    "some-host-name"
    "some-other-host-name"
)

# Determine the hosts where a ssh server is available
available_hosts=(
    $(
        ssh_available_hosts \
            --hosts ${addresses[@]} \
            --port "${ssh_port}" \
            --timeout 2
    )
)

if [ "${#available_hosts[@]}" -eq 0 ]; then
    echo "Host not found!">&2
    exit 1
fi

# Use the first available host
hostname="$(
    ssh_host_name \
        --host "${available_hosts[0]}"
)"
# Username for the ssh connection
username="root"

# Set hostname in example_config_file
ssh_config_update \
    --action add \
    --keyword hostname \
    --value "${hostname}" \
    --file "${example_config_file}"

# Set port in example_config_file
ssh_config_update \
    --action add \
    --keyword port \
    --value "${ssh_port}" \
    --file "${example_config_file}"

# Set username in example_config_file
ssh_config_update \
    --action add \
    --keyword user \
    --value "${username}" \
    --file "${example_config_file}"

# Set identityfile in example_config_file
ssh_config_update \
    --action add \
    --keyword IdentityFile \
    --value "\${PWD}/example_id_rsa" \
    --file "${example_config_file}"

# Copy example_config_file to ~/.ssh
# (OpenSSH does not allow variable expansion or paths relative to ./ in include statements)
# see https://man7.org/linux/man-pages/man5/ssh_config.5.html
cp "${example_config_file}" "${HOME}/.ssh/"

exit 0
