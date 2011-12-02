# pastie.pil.dk

Simple pastebin-server. Stores documents in the filesystem, and is entirely
static on the GET-side of things.

Much is stolen from https://github.com/seejohnrun/haste-server


## Server setup

Docroot pointing to public/. If possible, send /index.html instead of a 404 on
GET requests, and only proxy POST-requests to the app.

Create a cronjob to delete stuff in public/documents/ whenever you think it is
old enough to be deleted.
