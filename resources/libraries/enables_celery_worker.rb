module RbManager
  module Helpers
    def enables_celery_worker?
      scheduler_hosts = node['redborder']['managers_per_services']['airflow-scheduler']
      webserver_hosts = node['redborder']['managers_per_services']['airflow-webserver']
      return false if scheduler_hosts.nil? || webserver_hosts.nil?

      all_hosts = (scheduler_hosts + webserver_hosts).uniq
      all_hosts.size > 1
    end
  end
end
