Role Name
=========

This role allow to define unit files in yml (similar to docker compose) and generate systemd unit on remote hosts.
This could be taken as a very simple and light but powerfull orchestration system.

[![Build Status](https://travis-ci.org/kibatic/docker-systemd.svg?branch=master)](https://travis-ci.org/kibatic/docker-systemd)

Requirements
------------

* Docker daemon installed on host system

Installation
------------

```bash
$ ansible-galaxy install kibatic.docker-systemd
```

Role Variables
--------------

```yaml
# Default docker volumes mounted on each container
# /etc/localtime is required to share host timezone to containers
default_volumes:
  - /etc/localtime:/etc/localtime:ro
# Directory where all container data will be stored: volumes, uploaded config files, ...
container_data_home: '/home/cloud/containers'
```

Example Playbook
----------------

Including an example of how to use your role (for instance, with variables passed in as parameters) is always nice for users too:

```
- hosts:      my.awsome.host.example.com
  roles:      [ kibatic.docker-systemd ]
  vars_files: [ vars/units/my-awsome-service/units.yml ]
  tags:
    - my-awsome-service
```

License
-------

MIT
