[![Build Status](https://travis-ci.org/duse-io/duse.rb.svg?branch=master)](https://travis-ci.org/duse-io/duse.rb)
[![Coverage Status](https://img.shields.io/coveralls/duse-io/duse.rb.svg)](https://coveralls.io/r/duse-io/duse.rb)
[![Code Climate](https://codeclimate.com/github/duse-io/duse.rb/badges/gpa.svg)](https://codeclimate.com/github/duse-io/duse.rb)

Duse Client & Client Library
============================

A duse command line client written in ruby.

This implementation was heavily inspired by [travis-ci/travis.rb](https://github.com/travis-ci/travis.rb)

The Client
==========

To install the client simply install its ruby gem.

	$ gem install duse

Then you can explore the client with its help texts

	$ duse help
	Usage: duse COMMAND ...
	
	Available commands:
	
	  config         Configure the client
	  help           Displays help messages, such as this one
	  login          login to access and save secrets
	  register       Register a new account
	  secret         Save, retrieve and delete secrets
	
	run `duse help COMMAND` for more infos

When you want to see the help texts for subcommands of e.g. secrets

	$ duse help secret
	
	Save, retrieve and delete secrets
	
	Usage: duse secret COMMAND ...
	
	Available commands:
	
	  save           Save a new secret
	  get            Retrieve a secret
	  list           List all secrets you have access to
	  delete         Delete a secret
	
	run `duse help secret COMMAND` for more infos

Generally the cli will tell you if an action on your side is required. For
example when it needs to be configured and you are trying to login.

	$ duse login
	client not configured, run `duse config`

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
