Dokku Secure App Plugin [![Build Status](https://travis-ci.org/matto1990/dokku-secure-apps.svg?branch=master)](https://travis-ci.org/matto1990/dokku-secure-apps)
=======================

This is a plugin for [Dokku](https://github.com/progrium/dokku) which secures an individual app with HTTP Basic authentication.

Installation
------------

```bash
git clone https://github.com/matto1990/dokku-secure-apps.git /var/lib/dokku/plugins/secure-apps
dokku plugins-install
```

Commands
--------

```
$ dokku help
    secure:disable <app>                            remove security for this app
    secure:enable <app>                             enable security for this app
    secure:delete <app>                             delete htpasswd file for this app
    secure:set <app> username password              add user to app or update their password
    secure:unset <app> username                     remove user from app
    secure:list <app>                               list users for app
```

Unit Tests
----------

This plugins test were inspired by the tests in [https://github.com/neam/dokku-custom-domains](https://github.com/neam/dokku-custom-domains). It uses [assert.sh 1.0 - bash unit testing framework](http://github.com/lehmannro/assert.sh).

To run the tests:

```
make test
```

TODO
----

- Globally secure all apps (with opt-out for specific apps)

Licence
-------

```
The MIT License (MIT)

Copyright (c) 2014 Matthew Oakes

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
```
