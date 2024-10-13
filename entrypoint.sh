#!/bin/sh -l

echo "Host $1" >> ~/.ssh/config

if [ -z $7 ] && [ -z $8 ]
then
    echo "ProxyCommand cloudflared access ssh --hostname %h" >> ~/.ssh/config
else
    echo "ProxyCommand cloudflared access ssh --hostname %h --id $7 --secret $8" >> ~/.ssh/config
fi

echo "$5" > ~/.ssh/$4
chmod 600 ~/.ssh/$4

ssh-keyscan $1 >> ~/.ssh/known_hosts

ssh -T -q -o StrictHostKeyChecking=no $3@$1

ssh -i ~/.ssh/$4 $3@$1 -p $2 "$6"
