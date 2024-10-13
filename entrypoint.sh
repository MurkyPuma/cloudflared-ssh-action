#!/bin/sh -l

# Ensure .ssh directory exists and has correct permissions
mkdir -p /root/.ssh
chmod 700 /root/.ssh

# Add host to SSH config
echo "Host $1" >> /root/.ssh/config

# Add ProxyCommand depending on presence of $7 and $8
if [ -z "$7" ] && [ -z "$8" ]
then
    echo "ProxyCommand cloudflared access ssh --hostname %h" >> /root/.ssh/config
else
    echo "ProxyCommand cloudflared access ssh --hostname %h --id $7 --secret $8" >> /root/.ssh/config
fi

# Save the SSH private key
echo "$5" > /root/.ssh/$4
chmod 600 /root/.ssh/$4

# Add the host to known_hosts
ssh-keyscan $1 >> /root/.ssh/known_hosts

# Test SSH connection (this doesn't run any commands, just checks the connection)
ssh -T -q -o StrictHostKeyChecking=no $3@$1

# Run the command on the remote server
ssh -i /root/.ssh/$4 $3@$1 -p $2 "$6"
