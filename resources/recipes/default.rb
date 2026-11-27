# Cookbook:: manager
# Recipe:: default
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

# An install from before OpenBao: nothing is configured until rb_openbao_migrate.rb has moved its secrets
openbao_ready = begin
                  data_bag_item('rBglobal', 'openbao')['secrets'] == true
                rescue Net::HTTPClientException => e
                  raise unless e.response.code == '404'
                  false
                end
raise 'OpenBao is not set up on this cluster yet: run rb_openbao_migrate.rb on the leader' unless openbao_ready

include_recipe 'rb-manager::prepare_system'
include_recipe 'rb-manager::openbao'
include_recipe 'rb-manager::harden_secrets'
include_recipe 'rb-manager::configure'
include_recipe 'rb-manager::configure_malware'
include_recipe 'rb-manager::configure_cron_tasks'
include_recipe 'rb-manager::configure_journald'
