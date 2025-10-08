# Cookbook:: manager
# Recipe:: configure_cron_tasks
# Copyright:: 2024, redborder
# License:: Affero General Public License, Version 3

# Services configuration
manager_services = manager_services()

# Druid
cron_d 'clean_segments_daily' do
  if (manager_services['druid-coordinator'] || manager_services['druid-historical']) && node.run_state['cluster_installed']
    action :create
  else
    action :delete
  end
  minute '00'
  hour   '01'
  weekday '*'
  retries 2
  ignore_failure true
  command '/usr/lib/redborder/bin/rb_clean_segments.sh'
end

cron_d 'create_druid_metadata_daily' do
  action :create
  minute '00'
  hour   '00'
  weekday '*'
  retries 2
  ignore_failure true
  command '/usr/lib/redborder/bin/rb_create_druid_metadata.sh'
end

# Repos
cron_d 'repo_updates_daily' do
  action :create
  minute '00'
  hour   '00'
  weekday '*'
  retries 2
  ignore_failure true
  command '/usr/lib/redborder/bin/rb_repo_updates.sh'
end

# AWS Cloudwatch needs to be integrated
cron_d 'awsmon_hourly' do
  if node['redborder'] && node['redborder']['dmidecode'] && node['redborder']['dmidecode']['manufacturer'] && node['redborder']['iscloud'] && manager_services['awslogs']
    action :create
  else
    action :delete
  end
  minute '5'
  hour   '*'
  weekday '*'
  retries 2
  ignore_failure true
  environment({ 'MEM': node['filesystem'].select { |k, _v| k.start_with?('/dev/mapper/') }.map { |_k, v| "--disk-path=#{v['mount']}" }.join(' ') })
  command '/usr/lib/redborder/bin/rb_awsmon.sh --mem-util $MEM --disk-space-util --from-cron --auto-scaling'
end

# Events counter
cron_d 'eventscounter_daily' do
  action :create
  minute '00'
  hour   '00'
  weekday '*'
  retries 2
  ignore_failure true
  command 'systemctl restart redborder-events-counter &>/dev/null; exit 0;'
end

# Licenses
cron_d 'check_licences_daily' do
  action :create
  minute '00'
  hour   '00'
  weekday '*'
  retries 2
  ignore_failure true
  command '/usr/lib/redborder/bin/rb_check_licenses_daily.sh'
end

cron_d 'check_licences_weekly' do
  action :create
  minute '00'
  hour   '01'
  weekday '1'
  retries 2
  ignore_failure true
  command '/usr/lib/redborder/bin/rb_check_licenses_weekly.sh'
end

# Create aerospike secondary indexes
cron_d 'create_aerospike_secondary_indexes_daily' do
  if manager_services['aerospike']
    action :create
  else
    action :delete
  end
  minute '00'
  hour   '01'
  weekday '*'
  retries 2
  ignore_failure true
  command '/usr/lib/redborder/bin/rb_create_aerospike_indexes.sh'
end

# Manage password_readers group
cron_d 'manage_password_readers_group' do
  action :create
  minute '*/30'
  hour   '*'
  weekday '*'
  retries 2
  ignore_failure true
  command "/usr/bin/chef-client -o 'recipe[rb-manager::manage_password_readers]'"
end
