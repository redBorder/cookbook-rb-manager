#
# Cookbook Name:: manager
# Recipe:: configure_journald
#
# Copyright 2024, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#

storage = node["redborder"]["manager"]["journald"]["storage"] rescue nil
template "/etc/systemd/journald.conf" do
    source "systemd-journald_journald.conf.erb"
    owner "root"
    group "root"
    mode 0440
    retries 2
    notifies :restart, 'service[systemd-journald]', :delayed
    variables(:storage => storage)
end

service 'systemd-journald' do
    supports :status => true, :start => true, :restart => true, :reload => true
    action :nothing
end
