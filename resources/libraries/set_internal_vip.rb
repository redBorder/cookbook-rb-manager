module RbManager
  module Helpers
    def find_vip_from_serf
      postgresql_master_node = node['redborder']['managers_per_services']['postgresql'].first
      serf_output = `serf members`

      master_ip = serf_output.lines.find do |line|
        next unless line.include?('alive')

        node_name = line.split[0]
        node_name == postgresql_master_node
      end

      return unless master_ip

      ip_part = master_ip.split[1]
      ip_part&.split(':')&.first
    end

    def update_hosts_file(hosts_file, master_vip, service, vip)
      return false if ::File.readlines(hosts_file).any? { |line| line =~ /#{master_vip}\s+#{service.gsub('.', '\.')}/ }

      hosts_content = ::File.read(hosts_file).lines.reject { |line| line.include?(service) }
      hosts_content << "#{master_vip} #{service}\n"
      ::File.open(hosts_file, 'w') { |file| file.puts hosts_content }

      # there is no vip and you have the master_vip (=leader), you become the leader
      # otherwise you are a follower
      if vip.nil? && system("hostname -I | grep #{master_vip}")
        system('touch /tmp/postgresql.trigger')
        system('sed -i \'/^primary_conninfo/d\' /var/lib/pgsql/data/postgresql.conf')
        system('sed -i \'/^promote_trigger_file/d\' /var/lib/pgsql/data/postgresql.conf')
      elsif vip.nil?
        system("/usr/lib/redborder/bin/rb_sync_from_master.sh #{master_vip}")
      end

      true
    end

    def set_internal_vip(vip, service)
      etc_hosts_updated = false
      master_vip = vip || find_vip_from_serf
      etc_hosts_updated = update_hosts_file('/etc/hosts', master_vip, service, vip) if master_vip
      etc_hosts_updated
    end
  end
end
