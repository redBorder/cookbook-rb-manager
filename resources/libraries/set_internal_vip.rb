module RbManager
  module Helpers
    def find_ip_of_master_node
      postgres_ips = node['redborder']['cluster_info']
        .select { |m, _| node['redborder']['managers_per_services']['postgresql'].include?(m) }
        .map    { |_, v| v['ipaddress_sync'] }

      postgres_ips.first
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
      master_vip = vip || find_ip_of_master_node
      etc_hosts_updated = update_hosts_file('/etc/hosts', master_vip, service, vip) if master_vip
      etc_hosts_updated
    end
  end
end
