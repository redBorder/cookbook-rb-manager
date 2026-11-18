# Cookbook:: rb-manager
# Recipe:: harden_secrets
#
# Manager-only parts; the common hardening is in rb-common::harden_secrets.

include_recipe 'rb-common::harden_secrets'

chef_client_settings = { 'file_backup_path' => '"/run/chef-backup"', 'diff_disabled' => 'true' }

# chef-server-ctl reconfigure runs its own Chef with this solo.rb (restored on upgrade)
chef_server_solo = '/opt/opscode/embedded/cookbooks/solo.rb'
ruby_block 'chef-server-ctl: backups in /run, no diffs in logs' do
  block do
    rb = ::File.read(chef_server_solo)
    chef_client_settings.each_key { |k| rb = rb.gsub(/^#{k}\s.*\n/, '') }
    ::File.write(chef_server_solo, rb + chef_client_settings.map { |k, v| "#{k} #{v}\n" }.join)
  end
  only_if { ::File.exist?(chef_server_solo) }
  not_if do
    rb = ::File.read(chef_server_solo)
    chef_client_settings.all? { |k, v| rb.include?("#{k} #{v}\n") }
  end
end

execute 'Wipe chef-server-ctl file backups on disk' do
  command 'find /var/opt/opscode/local-mode-cache/backup -type f -exec shred -u {} + ; find /var/opt/opscode/local-mode-cache/backup -mindepth 1 -type d -empty -delete'
  only_if 'find /var/opt/opscode/local-mode-cache/backup -type f 2>/dev/null | grep -q .'
end

# once uploaded the Chef server holds them; certs are generated after the installer's cleanup
plain_secret_sources = Dir.glob('/var/chef/data/data_bag/certs/*.json') +
                       %w(/var/chef/data/data_bag/passwords/s3.json /var/chef/data/data_bag/rBglobal/malware-bucket.json)
plain_secret_sources.each do |f|
  execute "Remove uploaded data bag source #{::File.basename(f)}" do
    command "shred -u '#{f}'"
    only_if { ::File.exist?(f) }
  end
end

# the postfix package's TLS key is unused (main.cf is localhost only)
execute 'Remove unused postfix TLS key' do
  command 'shred -u /etc/pki/tls/private/postfix.key'
  only_if { ::File.exist?('/etc/pki/tls/private/postfix.key') }
  not_if 'grep -qE "^\s*smtpd_tls_key_file" /etc/postfix/main.cf'
end
