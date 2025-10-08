#
# Cookbook:: cookbook-rb-manager
# Recipe:: manage_password_readers
#
# Copyright:: 2025, The Authors, All Rights Reserved.

begin
  # Search for all nodes and filter in Ruby.
  all_nodes = search(:node, '*_*')
  excluded_patterns = ['^rbips-', '^rbintrusion-', '^rbipsv2-']
  allowed_nodes = all_nodes.reject do |node|
    excluded_patterns.any? { |pattern| node.name.match?(pattern) }
  end.map(&:name).uniq.sort

  Chef::Log.info("Found nodes for password_readers group: #{allowed_nodes.inspect}")

  rest = Chef::ServerAPI.new()
  group_exists = true

  begin
    password_group = rest.get("groups/password_readers")
  rescue Net::HTTPServerException => e
    if e.response.code == "404"
      group_exists = false
      password_group = {
        "name" => "password_readers",
        "groupname" => "password_readers",
        "orgname" => "default",
      }
    else
      raise e
    end
  end

  password_group["clients"] = allowed_nodes
  password_group["actors"] = { "users" => (password_group["users"] || []), "clients" => allowed_nodes }

  if group_exists
    rest.put("groups/password_readers", password_group)
    Chef::Log.info("Successfully updated members of password_readers group.")
  else
    rest.post("groups", password_group)
    Chef::Log.info("Successfully created password_readers group.")
  end

  execute 'ensure_clients_group_cannot_read_passwords_databag' do
    command 'knife acl remove group clients data passwords read'
    ignore_failure true
  end

  execute 'ensure_password_readers_group_can_read_passwords_databag' do
    command 'knife acl add group password_readers data passwords read'
  end

rescue StandardError => e
  Chef::Log.warn("Failed to manage password_readers group: #{e.message}")
  Chef::Log.warn(e.backtrace.join("\n"))
end
