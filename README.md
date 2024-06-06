# ssh-dynconf



Functions for dynamically generating / modifying ssh config files and availability checks ssh hosts

## Core functions

### Check ssh hosts' availability

#### `ssh_host_available`

<pre class="r-output"><code>ssh_host_available   
   Check whether a host is available via ssh

   Arguments:      
      --host     &lt;str&gt; 
         The ssh host to check
         Default: localhost
      --port     &lt;num&gt; 
         The ssh port to check
         Default: 12345
      --timeout  &lt;num&gt; 
         The timout in seconds
         Default: 2

   Usage:      
      ssh_host_available \
         --host     "localhost" \
         --port     "12345" \
         --timeout  "2"
</code></pre>

#### `ssh_available_hosts`

<pre class="r-output"><code>ssh_available_hosts   
   Check whether a host is available via ssh

   Arguments:      
      --hosts    &lt;str&gt; 
         The ssh host to check
         Default: localhost
      --port     &lt;num&gt; 
         The ssh port to check
         Default: 12345
      --timeout  &lt;num&gt; 
         The timout in seconds
         Default: 2

   Usage:      
      ssh_available_hosts \
         --hosts    "localhost" \
         --port     "12345" \
         --timeout  "2"
</code></pre>

### Modify ssh config file(s)

#### `ssh_config_update`

<pre class="r-output"><code>ssh_config_update   
   Add / replace / delete a ssh config keyword.
   See `man ssh_config` for possible keywords.

   Arguments:      
      --action   &lt;str&gt; 
         The action to perform.
         Either add|replace|delete a ssh config keyword.
         Default: replace
      --file     &lt;str&gt; 
         The ssh config file
         Default: ~/.ssh/example
      --keyword  &lt;str&gt; 
         The ssh config keyword to replace.
         Default: Host
      --value    &lt;str&gt; 
         The value to set for `keyword`
         Default: localhost

   Usage:      
      ssh_config_update \
         --action   "replace" \
         --file     "~/.ssh/example" \
         --keyword  "Host" \
         --value    "localhost"
</code></pre>

## Examples 

The following basic examples how to use `ssh-dynconf` are located in the [`examples/`](examples/) folder:



```data## 1
```

The following command attempts connecting to a host called `examplehost`
on port `50212`:


```bash
ssh -F ssh_config examplehost -p 50212 
```

To dynamically define the 
[`ssh config`](https://man7.org/linux/man-pages/man5/ssh_config.5.html)
for `examplehost`, a [ssh config file](examples/ssh_config) containing

```data
Match originalhost examplehost exec "./make-examplehost-config.sh %p"
	Include examplehost-config

```

can be used.
If the entered host matches 'examplehost',
a script [make-examplehost-config.sh](examples/make-examplehost-config.sh) containing

```data
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

```

is executed to create/modify a file [examplehost-config](examples/examplehost-config)
that contains

```data
hostname 127.0.0.1
	port 50212
	user root
	IdentityFile ${PWD}/example_id_rsa

```

This [examplehost-config](examples/examplehost-config) is then included in the 
[ssh_config](https://man7.org/linux/man-pages/man5/ssh_config.5.html) file
