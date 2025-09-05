module RbManager
  module Helpers
    def get_indexer_tasks
      kafka_brokers = node['redborder']['managers_per_services']['kafka']
      kafka_brokers = kafka_brokers.map { |broker| "#{broker}.node:9092" }
      namespaces = node.run_state['namespaces']

      base_tasks = [
        { task_name: 'rb_state', feed: 'rb_state_post' },
        { task_name: 'rb_flow', feed: 'rb_flow_post' },
        { task_name: 'rb_event', feed: 'rb_event_post' },
        { task_name: 'rb_vault', feed: 'rb_vault_post' },
        { task_name: 'rb_scanner', feed: 'rb_scanner_post' },
        { task_name: 'rb_location', feed: 'rb_loc_post' },
        { task_name: 'rb_wireless', feed: 'rb_wireless' },
        { task_name: 'rb_malware', feed: 'rb_malware_post' },
        { task_name: 'rb_host_discovery', feed: 'rb_host_discovery' },
      ]

      # This is an optimization: if there are no namespaces, monitor pipeline is not active in Logstash.
      # In that case, we should read from the topic rb_monitor instead of rb_monitor_post.
      rb_monitor_feed = namespaces.empty? ? 'rb_monitor' : 'rb_monitor_post'
      base_tasks.push({ task_name: 'rb_monitor', feed: rb_monitor_feed })

      base_tasks.flat_map do |task|
        default_task = { spec: task[:task_name], task_name: task[:task_name], namespace: '', feed: task[:feed], kafka_brokers: kafka_brokers }

        namespace_tasks = namespaces.map do |namespace|
          { spec: task[:task_name], task_name: task[:task_name] + '_' + namespace, namespace: namespace, feed: task[:feed] + '_' + namespace, kafka_brokers: kafka_brokers }
        end

        [default_task] + namespace_tasks
      end
    end
  end
end
