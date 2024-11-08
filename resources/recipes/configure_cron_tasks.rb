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

# Darklist
# TODO: Only the master node should have these cron jobs
# if (manager_mode == 'master')
cron_d 'rb_update_darklist_weekly' do
  action :create
  minute '00'
  hour   '00'
  weekday '1'
  retries 2
  ignore_failure true
  command '/usr/lib/redborder/bin/rb_update_darklist.sh'
  notifies :run, 'execute[populate_darklist]', :delayed
end

cron_d 'refresh_darklist_memcached_keys_hourly' do
  action :create
  minute '00'
  hour   '*'
  weekday '*'
  retries 2
  ignore_failure true
  command '/usr/lib/redborder/bin/rb_refresh_darklist_memcached_keys.sh'
end

execute 'populate_darklist' do
  command '/usr/lib/redborder/bin/rb_update_darklist.sh -f'
  action :nothing
end
