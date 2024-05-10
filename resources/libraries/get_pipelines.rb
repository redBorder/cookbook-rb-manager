module Rb_manager
  module Helpers

    def get_pipelines()
      logstash_pipelines = []
      sensors = node["redborder"]["sensors_info_all"]
      namespaces = get_namespaces()
      main_logstash = determine_main_logstash_node()

      if manager_services["logstash"]
        logstash_pipelines.push("rbwindow-pipeline") if main_logstash == node.name
        logstash_pipelines.push("apstate-pipeline")
        logstash_pipelines.push("scanner-pipeline") unless sensors["scanner-sensor"].empty?
        logstash_pipelines.push("nmsp-pipeline") if main_logstash == node.name and !sensors["flow-sensor"].empty?
        logstash_pipelines.push("radius-pipeline") if main_logstash == node.name
        logstash_pipelines.push("vault-pipeline") unless sensors["vault-sensor"].empty?
        logstash_pipelines.push("netflow-pipeline") unless sensors["flow-sensor"].empty?
        logstash_pipelines.push("sflow-pipeline") unless sensors["flow-sensor"].empty?
        logstash_pipelines.push("meraki-pipeline") unless sensors["meraki-sensor"].empty?
        logstash_pipelines.push("monitor-pipeline") unless namespaces.empty?
        logstash_pipelines.push("location-pipeline") unless sensors["ale-sensor"].empty? or sensors["mse-sensor"].empty? or sensors["flow-sensor"].empty? or sensors["arubacentral-sensor"].empty?
        logstash_pipelines.push("mobility-pipeline")
        logstash_pipelines.push("redfish-pipeline") unless sensors["device-sensor"].empty?
        logstash_pipelines.push("bulkstats-pipeline") unless sensors["device-sensor"].empty?
      end
      logstash_pipelines
    end

    # The main logstash is a node where both memcached and logstash are running or the first logstash node (order by name).
    # This main logasths node is gonna run the pipelines  rbwindow, location, mobility, nmsp, meraki and radius
    # Those pipelines should only run in one node (the main_logstash node) for now..
    def determine_main_logstash_node()
      memcached_nodes = managers_per_service["memcached"].sort.uniq
      logstash_nodes = managers_per_service["logstash"].sort.uniq
      main_logstash_nodes = memcached_nodes & logstash_nodes
      main_logstash_nodes.first || logstash_nodes.first
    end
  end
end
