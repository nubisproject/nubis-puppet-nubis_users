### nubis-puppet-nubis_users

Puppet module to create unix users


### Usage

This module uses hiera parameter lookups.

Complete example:

```
# hiera.yaml
---
:backends:
  - yaml
:yaml:
    :datadir: '/etc/puppet/yaml'

:hierarchy:
    - common
```

```
# common.yaml
---
nubis_users::users:
    elim:
        groups:
            - wheel
            - users
        ssh_keys:
            - < ssh key 1 >
            - < ssh key 2 >

```

In order to invoke puppet you can run the following command:

```
# puppet apply --hiera_config /etc/puppet/hiera.yaml --modulepath /etc/puppet/modules -e 'include nubis_users'
```
