#
# Cookbook:: cookbook-rb-manager
# Recipe:: manage_password_readers
#
# Copyright:: 2025, The Authors, All Rights Reserved.

# Search for all nodes that should have read access.
# This search excludes nodes that are IPS/IDS sensors.
begin
  search_query = 'node "NOT name:rbips-* AND NOT name:rb-intrusion-* AND NOT name:rbipsv2-*" AND chef_environment:_default'
  allowed_nodes = search(:node, search_query).map(&:name)

  # Manage the password_readers group
  group 'password_readers' do
    members allowed_nodes
    action :create
  end

rescue Net::HTTPServerException, Chef::Exceptions::ServiceUnavailable => e
  Chef::Log.warn("Could not connect to Chef Server to manage password_readers group: #{e.message}")
end
