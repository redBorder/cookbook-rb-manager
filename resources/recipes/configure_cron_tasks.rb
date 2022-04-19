manager_services = manager_services()
cluster_installed = File.exist?("/etc/cluster-installed.txt")

#--------------------------Druid-------------------------#
if (manager_services["druid_coordinator"] or manager_services["druid_historical"]) and cluster_installed
  template "/etc/cron.daily/rb_clean_segments.sh" do
    source "rb_clean_segments_cron.erb"
    owner "root"
    group "root"
    mode 0755
    retries 2
    ignore_failure true
  end
elsif File.exists?("/etc/cron.daily/rb_clean_segments.sh")
  file "/etc/cron.daily/rb_clean_segments.sh" do
    action :delete
  end
end

template "/etc/cron.daily/create_druid_metadata.sh" do
  source "create_druid_metadata_cron.erb"
  owner "root"
  group "root"
  mode 0755
  retries 2
end

#--------------------------REPOS-------------------------#
template "/etc/cron.daily/rb_repo_updates.sh" do
  source "rb_repo_updates_cron.erb"
  owner "root"
  group "root"
  mode 0755
  retries 2
  ignore_failure true
end

#--------------------------AWS-------------------------#
if !node["redborder"].nil? and !node["redborder"]["dmidecode"].nil? and !node["redborder"]["dmidecode"]["manufacturer"].nil? and node["redborder"]["iscloud"] and manager_services["awslogs"]
  template "/etc/cron.d/awsmon" do
    source "awsmon_cron.erb"
    owner "root"
    group "root"
    mode 0644
    retries 2
  end
elsif File.exist?"/etc/cron.d/awsmon"
  file "/etc/cron.d/awsmon" do
    action :delete
  end
end

#--------------------------Rabbitmq-------------------------#
if manager_services["rabbitmq"] and cluster_installed
  template "/etc/cron.daily/rabbitmq" do
    source "rabbitmq_cron.erb"
    owner "root"
    group "root"
    mode 0755
    retries 2
  end
else
  if File.exists?("/etc/cron.daily/rabbitmq")
    file "/etc/cron.daily/rabbitmq" do
      action :delete
    end
  end
end

#--------------------------Events-counter-------------------------#
template "/etc/cron.daily/rb_eventscounter.sh" do
  source "rb_eventscounter_cron.erb"
  owner "root"
  group "root"
  mode 0755
  retries 2
  ignore_failure true
end

#--------------------------Licenses-------------------------#
template "/etc/cron.daily/check_licenses_daily.sh" do
  source "check_licenses_daily_cron.erb"
  owner "root"
  group "root"
  mode 0755
  retries 2
  ignore_failure true
end

template "/etc/cron.weekly/check_licenses_weekly.sh" do
  source "check_licenses_weekly_cron.erb"
  owner "root"
  group "root"
  mode 0755
  retries 2
  ignore_failure true
end

#--------------------------Darklist-------------------------#
# TODO Only the master node should have these cron jobs
# if (manager_mode == "master")
template "/etc/cron.weekly/rb_update_darklist.sh" do
  source "rb_update_darklist_cron.erb"
  owner "root"
  group "root"
  mode 0755
  retries 2
  ignore_failure true
  notifies :run, 'execute[update_darklist]', :delayed
end

execute "update_darklist" do
  ignore_failure true
  command "/etc/cron.weekly/rb_update_darklist.sh"
  action :nothing
end

template "/etc/cron.hourly/rb_refresh_darklist_memcached_keys.sh" do
  source "rb_refresh_darklist_memcached_keys_cron.erb"
  owner "root"
  group "root"
  mode 0755
  retries 2
  ignore_failure true
end
