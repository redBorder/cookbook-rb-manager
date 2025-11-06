# Cookbook:: manager
# Recipe:: default
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

include_recipe 'rb-manager::prepare_system'
include_recipe 'rb-manager::configure'
include_recipe 'rb-manager::configure_malware'
include_recipe 'rb-manager::configure_cron_tasks'
include_recipe 'rb-manager::configure_journald'
include_recipe 'rb-manager::databag_acl'
