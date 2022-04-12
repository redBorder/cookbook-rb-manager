manager_services = manager_services()
cluster_installed = File.exist?("/etc/cluster-installed.txt")

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

template "/etc/cron.daily/rb_repo_updates.sh" do
  source "rb_repo_updates_cron.erb"
  owner "root"
  group "root"
  mode 0755
  retries 2
  ignore_failure true
end

template "/etc/cron.daily/rb_eventscounter.sh" do
  source "rb_eventscounter_cron.erb"
  owner "root"
  group "root"
  mode 0755
  retries 2
  ignore_failure true
end

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