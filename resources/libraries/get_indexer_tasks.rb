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

      base_tasks.flat_map do |task|
        monitor_base_feed = !namespaces.empty? ? 'rb_monitor_post' : 'rb_monitor'
        default_feed = task[:task_name] == 'rb_monitor' ? monitor_base_feed : task[:feed]
        default_task = { spec: task[:task_name], task_name: task[:task_name], namespace: '', feed: default_feed, kafka_brokers: kafka_brokers }

        namespace_tasks = namespaces.map do |namespace|
          ns_feed = if task[:task_name] == 'rb_monitor'
                      monitor_base_feed + '_' + namespace
                    else
                      task[:feed] + '_' + namespace
                    end
          { spec: task[:task_name], task_name: task[:task_name] + '_' + namespace, namespace: namespace, feed: ns_feed, kafka_brokers: kafka_brokers }
        end

        [default_task] + namespace_tasks
      end
    end
  end
end
