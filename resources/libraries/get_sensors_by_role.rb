module RbManager
  module Helpers
    # Every sensor role used by the manager helpers
    def sensor_roles
      %w(vault-sensor flow-sensor mse-sensor scanner-sensor meraki-sensor ale-sensor device-sensor snmp-sensor redfish-sensor ipmi-sensor
         cisco-cloudproxy proxy-sensor arubacentral-sensor cep-sensor
         ips-sensor intrusion-sensor intrusioncp-sensor ipsv2-sensor ipscp-sensor ipsg-sensor http_agent-sensor trap-sensor
         vmware-exsi-sensor vmware-exsi-vm-sensor)
    end

    # Gets all the sensor nodes with a single search and groups them by role.
    # The result is cached in run_state, so the chef server is queried only once per run
    def get_sensors_by_role
      return node.run_state['sensors_by_role'] if node.run_state['sensors_by_role']

      roles = sensor_roles
      sensors_by_role = {}
      sensors_by_id = {}
      roles.each { |role| sensors_by_role[role] = [] }

      search(:node, roles.map { |role| "role:#{role}" }.join(' OR ')).sort.each do |s|
        # role:<name> matches the roles set directly in the run_list of the node
        (s.run_list.role_names & roles).each { |role| sensors_by_role[role] << s }

        sensor_id = s['redborder'] && s['redborder']['sensor_id']
        sensors_by_id[sensor_id.to_s] ||= s if sensor_id
      end

      node.run_state['sensors_by_id'] = sensors_by_id
      node.run_state['sensors_by_role'] = sensors_by_role
    end

    # Sensors of the given role sorted by name
    def get_sensors_with_role(role)
      (get_sensors_by_role[role] || []).dup
    end

    # Gets the parent of a sensor (nil if it has no parent)
    def get_parent_sensor(sensor)
      parent_id = sensor['redborder'] && sensor['redborder']['parent_id']
      return unless parent_id

      get_sensors_by_role
      parents = node.run_state['sensors_by_id']
      key = parent_id.to_s
      # the parent could not be a sensor of the known roles, in that case it is searched only once
      parents[key] = search(:node, "sensor_id:#{parent_id}").first unless parents.key?(key)
      parents[key]
    end

    def child_of_proxy?(sensor)
      parent_sensor = get_parent_sensor(sensor)
      parent_sensor && parent_sensor.to_s.include?('proxy') ? true : false
    end
  end
end
