[![Build Status](https://travis-ci.org/duse-io/duse.rb.svg?branch=master)](https://travis-ci.org/duse-io/duse.rb)
[![Coverage Status](https://coveralls.io/repos/duse-io/duse.rb/badge.svg?branch=master)](https://coveralls.io/r/duse-io/duse.rb?branch=master)
[![Code Climate](https://codeclimate.com/github/duse-io/duse.rb/badges/gpa.svg)](https://codeclimate.com/github/duse-io/duse.rb)

Duse Client & Client Library
============================

Duse is a cryptographic server client application created to securely share
secrets among signed up users. It is meant to be used for secrets such as
passwords and ssh-keys, but it can very well be used to encrypt and share
anything.

This is a CLI for consuming the [duse api](https://github.com/duse-io/api),
written in ruby.

This implementation was heavily inspired by [travis-ci/travis.rb](https://github.com/travis-ci/travis.rb)

CLI
===

To install the client simply install its ruby gem.

	$ gem install duse

* [help](#help)
* [config](#config)
* [login](#login)
* [register](#register)
* [secret](#secret)
  * [add](#add)
  * [list](#list)
  * [get](#get)
  * [remove](#remove)
* [account](#account)

help
----

Explore the CLI via its help texts

	$ duse
	
	Usage: duse COMMAND ...
	
	Available commands:
	
	  account        Manage your account
	  config         Configure the client
	  help           Displays help messages, such as this one
	  login          login to access and save secrets
	  register       Register a new account
	  secret         Save, retrieve and delete secrets
	  version        print the client version
	
	run `duse help COMMAND` for more infos

When you want to see the help texts for subcommands of e.g. secret

	$ duse secret
	
	Save, retrieve and delete secrets
	
	Usage: duse secret COMMAND ...
	
	Available commands:
	
	  add            Save a new secret
	  get            Retrieve a secret
	  list           List all secrets you have access to
	  remove         Delete a secret
	  update         Save a new secret
	
	run `duse help secret COMMAND` for more infos

For any command the `-h` flag can be added to receive the help description.

	$ duse secret add -h 
	Interactively create a new secret, or set values via options.
	
	Usage: duse secret add [OPTIONS]
	    -h, --help                       Display help
	    -t, --title [TITLE]              The title for the secret to save
	    -s, --secret [SECRET]            The secret to save
	    -g, --generate-secret            Automatically generate the secret
	    -f, --file [FILE]                Read the secret to save from this file

config
------

The CLI tells you when it needs to be configured

	$ duse login
	client not configured, run `duse config`

So configure it

	$ duse config
	Uri to the duse instance you want to use: https://myserver.com/

login
-----

When it works

	$ duse login
	Username: flower-pot
	Password: xxxxxxxx
	Successfully logged in!

When it fails

	$ duse login
	Username: flower-pot
	Password: xxxxxxxx
	Wrong username or password!

register
--------

Let's register

	$ duse register
	Username: flower-pot
	Email: fbranczyk@gmail.com
	Password: xxxxxxxx
	Confirm password: xxxxxxxx
	1. /Users/fredericbranczyk/.ssh/id_rsa
	2. Generate a new one
	3. Let me choose it myself
	Which private ssh-key do you want to use?
	2
	Successfully created your account! An email to confirm it has been sent. Once confirmed you can login with "duse login"

secret
------

###add

Now that the client is configured and you're logged in the first secret can be
created

	$ duse secret save
	What do you want to call this secret? First Secret
	Secret to save: test-secret
	Do you want to share this secret?[Y/n] n
	Secret successfully created!

###list

List your secrets

	$ duse secret list
	1: First Secret

###get

Retrieve a secret interactively

	$ duse secret get
	1: First secret
	
	Select the id of the secret to retrieve: 1
	
	Name:   First secret
	Secret: test-secret
	Access: flower-pot

Retrieve a secret

	$ duse secret get 1
	
	Name:   First Secret
	Secret: test-secret
	Access: flower-pot

Or plain

	$ duse secret get 1 --plain
	test-secret

###remove

Delete a secret

	$ duse secret remove 1
	Successfully deleted

Or interactively

	$ duse secret remove
	Secret to delete: 1
	Successfully deleted

account
-------

###confirm

Confirm the account

	$ duse account confirm <token>
	Account successfully confirmed.

The Library
===========

Installation
------------

Add this line to your application's Gemfile:

	gem 'duse'

And then execute:

	$ bundle

Or install it yourself as:

	$ gem install duse

Usage
-----

	require 'duse'
	Duse.uri = 'https://example.org/'
	Duse.token = 'token'
	user = Duse::User.get 'me'
	p user
	 => #<Duse::Client::User:0x0000000140acd0 @attributes={"id"=>2, "username"=>"flower-pot", "public_key"=>"-----BEGIN PUBLIC KEY-----\nMIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQCtaAORZpFJ037AN1Drm88TLYyZ\ny+vLyVZr9XKPfMUF/KCHEsT1gJfQYFRI7t/gHjL3VouKM10671f/g8s5t1hWHF6Y\nOvaFTd3yDXAkf86x5jrPBrIH6M3M5WOwwqwW9aRF22CFzlBoCoV4GQt4KhRzqrG2\nkRJULsBuT9TiHCKEPwIDAQAB\n-----END PUBLIC KEY-----\n"}, @curry=#<Duse::Client::Namespace::Curry:0x0000000149fbf0>>
