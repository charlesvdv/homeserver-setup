# homeserver-setup

Configuration/setup for my personal home server.

For now, my home server is used as:

- A reverse proxy for my [_blog_](charlesvdv.be) hosted on Github Pages.
- A nextcloud instance.
- Probably more to come...

The services are deployed using `docker`.

## Requirements

For the complete setup:

- A Debian box.
- A domain name.

---

If you want to just run the services, you only need a `docker` and `docker-compose` client.

## Note

The scripts are currently heavily dependent of my setup. The more interesting part is
the `docker-compose` script which currently run the nextcloud and the reverse proxy.
The rest is only install, setup and configuration for the host server.

The *nextcloud* docker config is highly inspired from the
[docker nextcloud repository examples](https://github.com/nextcloud/docker).
