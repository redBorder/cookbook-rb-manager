module RbManager
  module Helpers
    def enables_celery_worker?
      services = %w[
        airflow-scheduler
        airflow-webserver
        airflow-dag-processor
        airflow-triggerer
      ]

      all_hosts = services.flat_map { |svc|
        node['redborder']['managers_per_services'][svc] || []
      }.uniq

      all_hosts.size > 1
    end
  end
end
