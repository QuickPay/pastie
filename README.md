# pastie

Simple pastebin-server. Stores documents in the filesystem, and is entirely
static on the GET-side of things.

Much is borrowed from https://github.com/seejohnrun/haste-server

Deploy with capistrano: `server=pastie.url cap deploy`

Deploy with docker-compose: `DOCKER_HOST=ssh://pastie.url docker-compose -f docker-compose-production.yml up -d`

## Server setup

Docroot pointing to public/. If possible, send /index.html instead of a 404 on
GET requests, and only proxy POST-requests to the app.

nginx sample:

    # Upstream Unicorn app-server
    upstream @pastie {
      server unix:/usr/local/www/pastie/shared/system/unicorn.sock fail_timeout=0;
    }

    # HTTP->HTTPS redirect
    server {
      listen [::]:80;
      listen 80;
      access_log off;
      server_name pastie.url;
      rewrite ^(.*)$ https://pastie.url/ permanent;
    }

    server {
      listen [::]:443 ssl;
      listen 443 ssl;
      server_name pastie.url;

      ssl_certificate /usr/local/etc/ssl/crt/pastie.crt;
      ssl_certificate_key /usr/local/etc/ssl/key/pastie.key;

      keepalive_timeout 5;

      access_log /usr/local/www/pastie/logs/nginx-access_log combined;
      error_log /usr/local/www/pastie/logs/nginx-error_log;

      # path for static files
      root /usr/local/www/pastie/current/public;

      location / {
        try_files $uri /index.html =404;
      }

      location = /documents {
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header Host $http_host;
        proxy_set_header X-Forwarded-Proto https;
        proxy_redirect http:// https://;

        auth_basic "Restricted";
        auth_basic_user_file pastie-htpasswd;

        if ($request_method = POST) {
          proxy_pass http://@pastie;
          break;
        }
      }
    }

Create a cronjob to delete stuff in public/documents/ whenever you think it is
old enough to be deleted. eg:

    0 0 * * * find /usr/local/www/pastie/shared/documents/ -ctime +4w -delete

And perhaps one to start the app

    @reboot cd /usr/local/www/pastie/current/ && /usr/local/bin/bundle exec unicorn -c config/unicorn.rb -E production -D

## Clients

### Cli

    #!/bin/sh
    # Pipe STDOUT to pastie.
    if [ -z "$1" ]; then
      _key=$( curl -H "Content-Type: application/octet-stream" -H "Authorization: Basic $REPLACE-ME-WITH-AUTH" -sk --data-binary @- https://pastie.url/documents )
      echo https://pastie.url/${_key}
    else
      _key=$( curl -H "Content-Type: application/octet-stream" -H "Authorization: Basic $REPLACE-ME-WITH-AUTH" -sk --data-binary @- "https://pastie.url/documents?type=$1" )
      echo https://pastie.url/documents/${_key}
    fi

### Hotkeys for X

    xclip -o | pastie | xargs firefox

### OS X workflow
    
Use the follwing with `Run Shell Script`:

    _type=${1:-txt}
    _key=$(cat | curl -H "Content-Type: application/octet-stream" -s -X POST "https://$user:$passwd@pastie.url/documents" --data-binary @-)
    open https://pastie.url/${_key}.${_type}
