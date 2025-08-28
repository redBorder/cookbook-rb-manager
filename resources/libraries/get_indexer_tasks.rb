module RbManager
  module Helpers
    def get_indexer_tasks
      base_tasks = [
        { task_name: 'rb_monitor', feed: 'rb_monitor' },
        { task_name: 'rb_state', feed: 'rb_state_post' },
        { task_name: 'rb_flow', feed: 'rb_flow_post' },
        { task_name: 'rb_event', feed: 'rb_event_post' },
        { task_name: 'rb_vault', feed: 'rb_vault_post' },
        { task_name: 'rb_scanner', feed: 'rb_scanner_post' },
        { task_name: 'rb_location', feed: 'rb_loc_post' },
        { task_name: 'rb_wireless', feed: 'rb_wireless' },
        { task_name: 'rb_host_discovery', feed: 'rb_host_discovery' },
      ]

      kafka_brokers = node['redborder']['managers_per_services']['kafka']
      kafka_brokers = kafka_brokers.map { |broker| "#{broker}.node:9092" }
      namespaces = node.run_state['namespaces']

      # Process all tasks EXCEPT rb_monitor
      other_tasks = base_tasks.select { |t| t[:task_name] != 'rb_monitor' }.flat_map do |task|
        default_task = { spec: task[:task_name], task_name: task[:task_name], namespace: '', feed: task[:feed], kafka_brokers: kafka_brokers }
        namespace_tasks = namespaces.map do |namespace|
          taskHash = { spec: task[:task_name], task_name: task[:task_name] + '_' + namespace, namespace: namespace, kafka_brokers: kafka_brokers }
          taskHash[:feed] = task[:feed] + '_' + namespace
          taskHash
        end
        [default_task] + namespace_tasks
      end

      # Process rb_monitor task separately
      monitor_task = { task_name: 'rb_monitor', feed: 'rb_monitor' }
      monitor_tasks = []
      if !namespaces.empty?
        # Namespaces exist: use rb_monitor_post
        # Default task
        monitor_tasks << { spec: monitor_task[:task_name], task_name: monitor_task[:task_name], namespace: '', feed: 'rb_monitor_post', kafka_brokers: kafka_brokers }
        # Namespace tasks
        namespaces.each do |namespace|
          monitor_tasks << { spec: monitor_task[:task_name], task_name: monitor_task[:task_name] + '_' + namespace, namespace: namespace, feed: 'rb_monitor_post_' + namespace, kafka_brokers: kafka_brokers }
        end
      else
        # No namespaces: use rb_monitor
        monitor_tasks << { spec: monitor_task[:task_name], task_name: monitor_task[:task_name], namespace: '', feed: 'rb_monitor', kafka_brokers: kafka_brokers }
      end

      other_tasks + monitor_tasks
    end
  end
end
