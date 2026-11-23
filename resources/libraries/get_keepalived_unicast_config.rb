module RbManager
  module Helpers
    def get_keepalived_unicast_config(virtual_ips_per_ip, cluster_info, managers_per_service, ipmgt, ipsync, current_node_name = nil)
      current_node_name ||= (defined?(node) && node ? node.name : nil)
      unicast_config = {}

      return unicast_config if virtual_ips_per_ip.nil?

      virtual_ips_per_ip.each do |ip, services|
        active_services = services.select { |x| x['enable'] }.map { |x| x['service'] }
        next if active_services.empty?

        is_postgres = active_services.include?('postgresql')
        src_ip = is_postgres ? ipsync : ipmgt
        next if src_ip.to_s.empty?

        peers = []

        if cluster_info && !cluster_info.empty?
          cluster_info.each do |node_name, info|
            next if current_node_name && node_name == current_node_name

            runs_service = active_services.any? do |s|
              (!info['services'].nil? && info['services'].include?(s)) ||
                (!managers_per_service.nil? && !managers_per_service[s].nil? && managers_per_service[s].include?(node_name))
            end

            if runs_service
              peer_ip = is_postgres ? info['ipaddress_sync'] : info['ip']
              peers << peer_ip if !peer_ip.nil? && !peer_ip.empty? && peer_ip != src_ip && !peers.include?(peer_ip)
            end
          end
        end

        unicast_config[ip] = {
          'src_ip' => src_ip,
          'peers' => peers,
        }
      end

      unicast_config
    end
  end
end
