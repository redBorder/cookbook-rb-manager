# Cookbook:: rb-manager
# Recipe:: harden_secrets
#
# The common hardening (swap, hibernation, kdump, coredumps, Chef client backups/diffs, Chef key modes)
# lives in rb-common; this adds the manager-only parts (chef-server, data bag sources, postfix key).

include_recipe 'rb-common::harden_secrets'

chef_client_settings = { 'file_backup_path' => '"/run/chef-backup"', 'diff_disabled' => 'true' }

# chef-server-ctl reconfigure runs its own Chef (solo.rb from the chef-server package, restored on upgrade)
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

# Plain data bag source files with private keys / S3 keys: once uploaded, the Chef server holds them,
# the copy on disk is only a leftover (certs are generated during Chef runs, after the installer's cleanup)
plain_secret_sources = Dir.glob('/var/chef/data/data_bag/certs/*.json') +
                       %w(/var/chef/data/data_bag/passwords/s3.json /var/chef/data/data_bag/rBglobal/malware-bucket.json)
plain_secret_sources.each do |f|
  execute "Remove uploaded data bag source #{::File.basename(f)}" do
    command "shred -u '#{f}'"
    only_if { ::File.exist?(f) }
  end
end

# The postfix package generates a TLS key at install, but our main.cf does not use TLS (localhost only):
# an unused private key on disk. Removed as long as main.cf does not reference it.
execute 'Remove unused postfix TLS key' do
  command 'shred -u /etc/pki/tls/private/postfix.key'
  only_if { ::File.exist?('/etc/pki/tls/private/postfix.key') }
  not_if 'grep -qE "^\s*smtpd_tls_key_file" /etc/postfix/main.cf'
end
