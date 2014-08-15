Dokku Secure App Plugin
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
    secure:set <app> username password              secure this app with a userame and password
    secure:unset <app>                              remove security for this app
```

TODO
----

- Multiple login details
- Unit tests

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
