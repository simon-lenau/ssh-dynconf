ssh-dynconf
================

Simple functions for checking ssh hosts and create / modify conditional
ssh config files

### Check ssh hosts’ availability

#### `ssh_host_available`

<pre class="r-output"><code>ssh_host_available   
   Check whether a host is accessivale via ssh
&#10;   Arguments:      
      --host     &lt;str&gt; 
         The ssh host to check
         Default: localhost
      --port     &lt;num&gt; 
         The ssh port to check
         Default: 12345
&#10;   Usage:      
      ssh_host_available \
         --host     "localhost" \
         --port     "12345"
</code></pre>

#### `ssh_available_hosts`

<pre class="r-output"><code>ssh_available_hosts   
   Check whether a host is accessivale via ssh
&#10;   Arguments:      
      --hosts    &lt;str&gt; 
         The ssh host to check
         Default: localhost
      --port     &lt;num&gt; 
         The ssh port to check
         Default: 12345
&#10;   Usage:      
      ssh_available_hosts \
         --hosts    "localhost" \
         --port     "12345"
</code></pre>

### Modify ssh config file(s)

#### `ssh_config_update`

<pre class="r-output"><code>ssh_config_update   
   Add / replace / delete a ssh config keyword.
   See `man ssh_config` for possible keywords.
&#10;   Arguments:      
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
&#10;   Usage:      
      ssh_config_update \
         --action   "replace" \
         --file     "~/.ssh/example" \
         --keyword  "Host" \
         --value    "localhost"
</code></pre>
