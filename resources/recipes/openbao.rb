# Cookbook:: manager
# Recipe:: openbao
# Copyright:: 2026, redborder
# License:: Affero General Public License, Version 3

# Also run alone ('chef-client -o recipe[rb-manager::openbao]') by rb_openbao_migrate.rb before the rest is migrated
include_recipe 'rb-manager::prepare_system'

manager_services = node.run_state['manager_services']

openbao_config 'Configure OpenBao' do
  if manager_services['openbao']
    ipaddress node['ipaddress_sync']
    is_server true
    peers node['redborder']['cluster_info'].reject { |name, _| name == node.name }.map { |_, m| m['ipaddress_sync'] }.compact
    bootstrap ::File.exist?('/var/lock/leader-configuring.lock')
    action [:add, :register]
  else
    action [:remove, :deregister]
  end
end

# raft and API between the managers; rb-firewall keeps these ports in its list on a full run
%w(8200 8201).each do |port|
  execute "Open OpenBao port #{port}/tcp on the sync network" do
    command "firewall-cmd --zone=home --add-port=#{port}/tcp && firewall-cmd --permanent --zone=home --add-port=#{port}/tcp"
    only_if { manager_services['openbao'] && system('firewall-cmd --state >/dev/null 2>&1') }
    not_if "firewall-cmd --zone=home --query-port=#{port}/tcp"
  end
end
