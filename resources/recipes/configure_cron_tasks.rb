#
# Cookbook Name:: manager
# Recipe:: configure_cron_tasks
#
# Copyright 2024, redborder
#
# AFFERO GENERAL PUBLIC LICENSE V3
#

# Services configuration
manager_services = manager_services()

cluster_installed = File.exist?("/etc/cluster-installed.txt")

#--------------------------Druid-------------------------#
cron_d 'clean_segments_daily' do
  action ((manager_services["druid-coordinator"] or manager_services["druid-historical"]) and cluster_installed) ? :create : :delete
  minute '00'
  hour   '01'
  weekday '*'
  retries 2
  ignore_failure true
  command "/usr/lib/redborder/bin/rb_clean_segments.sh"
end


cron_d 'create_druid_metadata_daily' do
  action :create
  minute '00'
  hour   '00'
  weekday '*'
  retries 2
  ignore_failure true
  command "/usr/lib/redborder/bin/rb_create_druid_metadata.sh"
end

#--------------------------REPOS-------------------------#
cron_d 'repo_updates_daily' do
  action :create
  minute '00'
  hour   '00'
  weekday '*'
  retries 2
  ignore_failure true
  command "/usr/lib/redborder/bin/rb_repo_updates.sh"
end

#--------------------------AWS-------------------------#
# AWS Cloudwatch needs to be integrated
cron_d 'awsmon_hourly' do
  action (!node["redborder"].nil? and !node["redborder"]["dmidecode"].nil? and !node["redborder"]["dmidecode"]["manufacturer"].nil? and node["redborder"]["iscloud"] and manager_services["awslogs"]) ? :create : :delete
  minute '5'
  hour   '*'
  weekday '*'
  retries 2
  ignore_failure true
  environment({'MEM' => node["filesystem"].select {|k,v| k.start_with?"/dev/mapper/"}.map{|k,v| "--disk-path=#{v["mount"]}"}.join(" ") })
  command '/usr/lib/redborder/bin/rb_awsmon.sh --mem-util $MEM --disk-space-util --from-cron --auto-scaling'
end

#--------------------------Events-counter-------------------------#
cron_d 'eventscounter_daily' do
  action :create
  minute '00'
  hour   '00'
  weekday '*'
  retries 2
  ignore_failure true
  command 'systemctl restart redborder-events-counter &>/dev/null; exit 0;'
end

#--------------------------Licenses-------------------------#
cron_d 'check_licences_daily' do
  action :create
  minute '00'
  hour   '00'
  weekday '*'
  retries 2
  ignore_failure true
  command "/usr/lib/redborder/bin/rb_check_licenses_daily.sh"
end

cron_d 'check_licences_weekly' do
  action :create
  minute '00'
  hour   '01'
  weekday '1'
  retries 2
  ignore_failure true
  command "/usr/lib/redborder/bin/rb_check_licenses_weekly.sh"
end


#--------------------------Darklist-------------------------#
# TODO Only the master node should have these cron jobs
# if (manager_mode == "master")
cron_d 'rb_update_darklist_weekly' do
  action :create
  minute '00'
  hour   '00'
  weekday '1'
  retries 2
  ignore_failure true
  command "/usr/lib/redborder/bin/rb_update_darklist.sh"
  notifies :run, 'execute[populate_darklist]', :delayed
end

cron_d 'refresh_darklist_memcached_keys_hourly' do
  action :create
  minute '00'
  hour   '*'
  weekday '*'
  retries 2
  ignore_failure true
  command "/usr/lib/redborder/bin/rb_refresh_darklist_memcached_keys.sh"
end

execute 'populate_darklist' do
  command '/usr/lib/redborder/bin/rb_update_darklist.sh -f'
  action :nothing
end
