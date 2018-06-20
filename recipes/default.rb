#
# Cookbook:: codeigniter
# Recipe:: default
#
# Copyright:: 2018, The Authors, All Rights Reserved.
include_recipe "codeigniter::hosts"
include_recipe "codeigniter::database"
include_recipe "codeigniter::webserver"