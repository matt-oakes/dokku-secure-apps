# Dokku Secure App Plugin [![Build Status](https://travis-ci.org/matto1990/dokku-secure-apps.svg?branch=master)](https://travis-ci.org/matto1990/dokku-secure-apps)

This is a plugin for [Dokku](https://github.com/progrium/dokku) which secures an individual app with HTTP Basic authentication.

## installation

```shell
# on 0.3.x
cd /var/lib/dokku/plugins
git clone https://github.com/matto1990/dokku-secure-apps.git secure-apps
dokku plugins-install

# on 0.4.x
dokku plugin:install https://github.com/matto1990/dokku-secure-apps.git secure-apps
```

## commands

```shell
$ dokku help
    secure:disable <app>                            remove security for this app
    secure:enable <app>                             enable security for this app
    secure:delete <app>                             delete htpasswd file for this app
    secure:set <app> username password              add user to app or update their password
    secure:unset <app> username                     remove user from app
    secure:list <app>                               list users for app
```

## Unit Tests

This plugins test were inspired by the tests in [https://github.com/neam/dokku-custom-domains](https://github.com/neam/dokku-custom-domains). It uses [assert.sh 1.0 - bash unit testing framework](http://github.com/lehmannro/assert.sh).

To run the tests:

```
make test
```

## TODO

- Globally secure all apps (with opt-out for specific apps)
