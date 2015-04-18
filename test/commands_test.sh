#!/bin/bash

. test/assert.sh

STUBS=test/stubs
PATH="$STUBS:./:$PATH"
DOKKU_ROOT="test/fixtures/dokku"
dokku="PATH=$PATH DOKKU_ROOT=$DOKKU_ROOT commands"

cleanup() {
    rm -f "$DOKKU_ROOT/unsecure-app/nginx.conf.d/secure.conf"
    rm -f "$DOKKU_ROOT/unsecure-app/HTPASSWD"

    echo -e "user1:pass1\nuser2:pass2" > "$DOKKU_ROOT/secure-app/HTPASSWD"
    touch "$DOKKU_ROOT/secure-app/nginx.conf.d/secure.conf"

    rm -rf "$DOKKU_ROOT/disabled-secure-app/nginx.conf.d"
    echo "user1:pass1" > "$DOKKU_ROOT/disabled-secure-app/HTPASSWD"
}

###
## secure:delete
###

# `secure:delete` requires an app name
cleanup
assert "$dokku secure:delete" "You must specify an app name"
cleanup
assert_raises "$dokku secure:delete" 1

# `secure:delete` requires an existing app
#Disabled because error output is on stderr, which framework does not check
# cleanup
# assert "$dokku secure:delete foo" "App foo does not exist"
cleanup
assert_raises "$dokku secure:delete foo" 1

# `secure:delete` requires secure to be disabled
cleanup
assert "$dokku secure:delete secure-app" "Error: can't delete htpasswd for app secure-app\nPlease run dokku secure:disable first"
cleanup
assert_raises "$dokku secure:delete secure-app" 1

# `secure:delete` no htpasswd
cleanup
assert "$dokku secure:delete unsecure-app" "No htpasswd file for app unsecure-app"

# `secure:delete` removes htpasswd
cleanup
assert "$dokku secure:delete disabled-secure-app" "Removed htpasswd file for app disabled-secure-app"
assert "[ ! -f \"$DOKKU_ROOT/disabled-secure-app/HTPASSWD\" ]"

###
## secure:disable
###

# `secure:disable` requires an app name
cleanup
assert "$dokku secure:disable" "You must specify an app name"
cleanup
assert_raises "$dokku secure:disable" 1

# `secure:disable` requires an existing app
#Disabled because error output is on stderr, which framework does not check
# cleanup
# assert "$dokku secure:disable foo" "App foo does not exist"
cleanup
assert_raises "$dokku secure:disable foo" 1

# `secure:disable` removes nginx config, doesn't touch htpasswd
cleanup
assert "$dokku secure:disable secure-app" "[stub: sudo /etc/init.d/nginx reload]\nhtpasswd disabled for app secure-app"
assert "[ ! -f \"$DOKKU_ROOT/secure-app/nginx.conf.d/secure.conf\" ]"
assert "[ -f \"$DOKKU_ROOT/secure-app/HTPASSWD\" ]"

# `secure:disable` already disabled
cleanup
assert "$dokku secure:disable disabled-secure-app" "htpasswd already disabled for app disabled-secure-app"

###
## secure:enable
###

# `secure:enable` requires an app name
cleanup
assert "$dokku secure:enable" "You must specify an app name"
cleanup
assert_raises "$dokku secure:enable" 1

# `secure:enable` requires an existing app
#Disabled because error output is on stderr, which framework does not check
# cleanup
# assert "$dokku secure:enable foo" "App foo does not exist"
cleanup
assert_raises "$dokku secure:enable foo" 1

# `secure:enable` requires an htpasswd file
cleanup
assert "$dokku secure:enable unsecure-app" "Error: no htpasswd file\nAdd users with dokku secure:add before enabling"
cleanup
assert_raises "$dokku secure:enable unsecure-app" 1

# `secure:enable` already enabled
cleanup
assert "$dokku secure:enable secure-app" "htpasswd already enabled for app secure-app"

# `secure:enable` creates nginx config
cleanup
assert "$dokku secure:enable disabled-secure-app" "[stub: sudo /etc/init.d/nginx reload]\nhtpasswd enabled for app disabled-secure-app"
assert "cat \"$DOKKU_ROOT/disabled-secure-app/nginx.conf.d/secure.conf\"" "auth_basic \"Restricted\";\nauth_basic_user_file test/fixtures/dokku/disabled-secure-app/HTPASSWD;"

###
## secure:set
###

# `secure:set` requires an app name
cleanup
assert "$dokku secure:set" "You must specify an app name"
cleanup
assert_raises "$dokku secure:set" 1

# `secure:set` requires an existing app
#Disabled because error output is on stderr, which framework does not check
# cleanup
# assert "$dokku secure:set foo" "App foo does not exist"
cleanup
assert_raises "$dokku secure:set foo" 1

# `secure:set` requires a username and password
cleanup
assert "$dokku secure:set unsecure-app" "Usage: dokku secure:set APP USERNAME PASSWORD\nMust specify a USERNAME and PASSWORD."
cleanup
assert_raises "$dokku secure:set unsecure-app" 1

# `secure:set` should create a HTPASSWD file and add a user
cleanup
assert "$dokku secure:set unsecure-app username password" "[stub: htpasswd -b $DOKKU_ROOT/unsecure-app/HTPASSWD username password]\nUser 'username' added for app unsecure-app"
assert "[ -f $DOKKU_ROOT/unsecure-app/HTPASSWD ]"

# `secure:set` should update password for existing user
cleanup
assert "$dokku secure:set secure-app user1 password" "[stub: htpasswd -b test/fixtures/dokku/secure-app/HTPASSWD user1 password]\nPassword for user 'user1' updated for app secure-app"

###
## secure:unset
###

# `secure:unset` requires an app name
cleanup
assert "$dokku secure:unset" "You must specify an app name"
cleanup
assert_raises "$dokku secure:unset" 1

# `secure:unset` requires an existing app
#Disabled because error output is on stderr, which framework does not check
# cleanup
# assert "$dokku secure:unset foo" "App foo does not exist"
cleanup
assert_raises "$dokku secure:unset foo" 1

# `secure:unset` requires a username
cleanup
assert "$dokku secure:unset unsecure-app" "Usage: dokku secure:unset APP USERNAME\nMust specify a USERNAME."
cleanup
assert_raises "$dokku secure:unset unsecure-app" 1

# `secure:unset` requires an existing username
cleanup
assert "$dokku secure:unset secure-app nonexistent" "User 'nonexistent' doesn't exist for app secure-app"
cleanup
assert_raises "$dokku secure:unset secure-app nonexistent" 1

# `secure:unset` doesn't delete the last user
cleanup
assert "$dokku secure:unset disabled-secure-app user1" "Error: can't delete last user for app disabled-secure-app"
cleanup
assert_raises "$dokku secure:unset disabled-secure-app user1" 1

###
## secure:list
###

# `secure:list` requires an app name
cleanup
assert "$dokku secure:list" "You must specify an app name"
cleanup
assert_raises "$dokku secure:list" 1

# `secure:list` requires an existing app
#Disabled because error output is on stderr, which framework does not check
# cleanup
# assert "$dokku secure:list foo" "App foo does not exist"
cleanup
assert_raises "$dokku secure:list foo" 1

# `secure:list` lists users
cleanup
assert "$dokku secure:list secure-app" "Users for app secure-app (Total: 2)\nuser1\nuser2"
cleanup

# end of test suite
assert_end examples

cleanup

exit 0
