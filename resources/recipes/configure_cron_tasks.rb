manager_services = manager_services()
cluster_installed = File.exist?("/etc/cluster-installed.txt")
hadoop_resourcemanager_external = nil
zk_hosts = "zookeeper.service:2181"
overlords = "druid-overlord.service"
#overlords = managers_per_service["druid_overlord"]

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

#--------------------------Hadoop-------------------------#

if !node["redborder"]["manager"]["externals"].nil? and !node["redborder"]["manager"]["externals"]["hadoop_resourcemanager"].nil? and !node["redborder"]["manager"]["externals"]["hadoop_resourcemanager"].nil?
  hadoop_resourcemanager_external=node["redborder"]["manager"]["externals"]["hadoop_resourcemanager"] if node["redborder"]["manager"]["externals"]["hadoop_resourcemanager"]["enabled"] == true
end

if ((manager_services["hadoop_namenode"] and managers_per_service["hadoop_namenode"].size>0 and managers_per_service["hadoop_namenode"].first.name == node.name) or !hadoop_namenode_external.nil?) and (!managers_per_service["druid_middleManager"].nil? and managers_per_service["druid_middleManager"].size>0) and cluster_installed
  template "/etc/cron.daily/druid-dumbo" do
    source "druid-dumbo_cron.erb"
    owner "root"
    group "root"
    mode 0755
    retries 2
    variables(:zk_hosts => zk_hosts, :overlords => overlords)
  end
else
  if File.exists?("/etc/cron.daily/druid-dumbo")
    file "/etc/cron.daily/druid-dumbo" do
      action :delete
    end
  end
end

if (managers_per_service["hadoop_resourcemanager"].size>0 or !hadoop_resourcemanager_external.nil?) and managers_per_service["kafka"].size>0 and cluster_installed and manager_index==0 and (managers_per_service["hadoop_namenode"].size>0 or !hadoop_namenode_external.nil?)
  [ "rb_event", "rb_flow", "rb_monitor", "rb_state", "rb_vault" ].each do |topic|
    if (!node["redborder"]["manager"]["topics"].nil? and node["redborder"]["manager"]["topics"][topic]=="none")
      if File.exists?("/etc/cron.hourly/camus_#{topic}")
        file "/etc/cron.hourly/camus_#{topic}" do
          action :delete
        end
      end
    else
      template "/etc/cron.hourly/camus_#{topic}" do
        source "camus_cron.erb"
        owner "root"
        group "root"
        mode 0755
        retries 2
        variables(:topic => topic)
      end
    end
  end
else
  [ "rb_event", "rb_flow", "rb_monitor", "rb_state", "rb_vault" ].each do |topic|
    if File.exists?("/etc/cron.hourly/camus_#{topic}")
      file "/etc/cron.hourly/camus_#{topic}" do
        action :delete
      end
    end
  end
end