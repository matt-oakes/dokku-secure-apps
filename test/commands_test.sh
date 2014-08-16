#!/bin/bash

. test/assert.sh

STUBS=test/stubs
PATH="$STUBS:./:$PATH"
DOKKU_ROOT="test/fixtures/dokku"
dokku="PATH=$PATH DOKKU_ROOT=$DOKKU_ROOT commands"

cleanup() {
    rm -f "$DOKKU_ROOT/unsecure-app/nginx.conf"
    rm -f "$DOKKU_ROOT/unsecure-app/HTPASSWD"
    cp "$DOKKU_ROOT/unsecure-app/nginx.conf.org" "$DOKKU_ROOT/unsecure-app/nginx.conf"

    rm -f "$DOKKU_ROOT/secure-app/nginx.conf"
    echo "HTPSSWD" > "$DOKKU_ROOT/secure-app/HTPASSWD"
    cp "$DOKKU_ROOT/secure-app/nginx.conf.org" "$DOKKU_ROOT/secure-app/nginx.conf"

    rm -f "$DOKKU_ROOT/unsecure-ssl-app/nginx.conf"
    rm -f "$DOKKU_ROOT/unsecure-ssl-app/HTPASSWD"
    cp "$DOKKU_ROOT/unsecure-ssl-app/nginx.conf.org" "$DOKKU_ROOT/unsecure-ssl-app/nginx.conf"

    rm -f "$DOKKU_ROOT/secure-ssl-app/nginx.conf"
    echo "HTPSSWD" > "$DOKKU_ROOT/secure-ssl-app/HTPASSWD"
    cp "$DOKKU_ROOT/secure-ssl-app/nginx.conf.org" "$DOKKU_ROOT/secure-ssl-app/nginx.conf"
}

# `secure:unset` requires an app name
cleanup
assert "$dokku secure:unset" "You must specify an app name"
cleanup
assert_raises "$dokku secure:unset" 1

# `secure:unset` requires an existing app
cleanup
assert "$dokku secure:unset foo" "App foo does not exist"
cleanup
assert_raises "$dokku secure:unset" 1

# `secure:set` requires an app name
cleanup
assert "$dokku secure:set" "You must specify an app name"
cleanup
assert_raises "$dokku secure:set" 1

# `secure:set` requires an existing app
cleanup
assert "$dokku secure:set foo" "App foo does not exist"
cleanup
assert_raises "$dokku secure:set foo" 1

# `secure:set` requires a username and password
cleanup
assert "$dokku secure:set unsecure-app" "Usage: dokku secure:set APP USERNAME PASSWORD\nMust specify a USERNAME and PASSWORD."
cleanup
assert_raises "$dokku secure:set unsecure-app" 1

# `domains:set` should modify create a HTPASSWD file, call pluginhook, and reload nginx
cleanup
assert "$dokku secure:set unsecure-app username password" "[stub: htpasswd -bc $DOKKU_ROOT/unsecure-app/HTPASSWD username password]\n[stub: pluginhook nginx-pre-reload unsecure-app]\n[stub: sudo /etc/init.d/nginx reload]"
expected=$(< "test/expected/unsecure-app-nginx.conf")
assert "cat $DOKKU_ROOT/unsecure-app/nginx.conf" "$expected"

# `domains:set` should not edit the nginx.conf files for an already secure
cleanup
assert "$dokku secure:set secure-app username password" "[stub: htpasswd -bc $DOKKU_ROOT/secure-app/HTPASSWD username password]"
expected=$(< "test/expected/double-secure-app-nginx.conf")
assert "cat $DOKKU_ROOT/secure-app/nginx.conf" "$expected"

# `secure:unset` should remove the HTPASSWD file and reconfigure nginx
cleanup
assert "$dokku secure:unset secure-app" "[stub: sudo /etc/init.d/nginx reload]"
expected=$(< "test/expected/secure-app-nginx.conf")
assert "cat $DOKKU_ROOT/secure-app/nginx.conf" "$expected"
assert "cat $DOKKU_ROOT/secure-app/HTPASSWD" ""

# test against an unsecure app configured with ssl
cleanup
assert "$dokku secure:set unsecure-ssl-app username password" "[stub: htpasswd -bc $DOKKU_ROOT/unsecure-ssl-app/HTPASSWD username password]\n[stub: pluginhook nginx-pre-reload unsecure-ssl-app]\n[stub: sudo /etc/init.d/nginx reload]"
expected=$(< "test/expected/unsecure-ssl-app-nginx.conf")
assert "cat $DOKKU_ROOT/unsecure-ssl-app/nginx.conf" "$expected"

# `domains:set` should not edit the nginx.conf files for an already secure for an ssh app
cleanup
assert "$dokku secure:set secure-ssl-app username password" "[stub: htpasswd -bc $DOKKU_ROOT/secure-ssl-app/HTPASSWD username password]"
expected=$(< "test/expected/double-secure-ssl-app-nginx.conf")
assert "cat $DOKKU_ROOT/secure-ssl-app/nginx.conf" "$expected"

# end of test suite
assert_end examples

cleanup
rm $DOKKU_ROOT/*/nginx.conf

exit 0
