# Cookbook:: manager
# Recipe:: databag_acl
# Copyright:: 2025, redborder
# License:: Affero General Public License, Version 3

begin
  # Get all nodes except ips and intrusion
  all_nodes = search(:node, '*')
  excluded_patterns = ['^rbips-', '^rbipscp-', '^rbipsv2-', '^rbintrusion-']
  allowed_nodes = all_nodes.reject do |node|
    excluded_patterns.any? { |pattern| node.name.match?(pattern) }
  end.map(&:name).uniq.sort

  rest = Chef::ServerAPI.new()
  group_exists = true

  # Get group or create if not exists
  begin
    password_group = rest.get("groups/password_readers")
  rescue Net::HTTPServerException => e
    if e.response.code == "404"
      group_exists = false
      password_group = {
        "name" => "password_readers",
        "groupname" => "password_readers",
        "orgname" => "redborder",
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

  # Enforce the ACLs for the passwords data bag directly via the API
  acl_path = "data/passwords/_acl"
  begin
    acl = rest.get(acl_path)
    read_ace = acl['read']

    # Remove 'clients' group from the read ACE, otherwise all nodes will have read access
    read_ace['groups'].delete('clients')

    # Add 'password_readers' group to the read ACE
    unless read_ace['groups'].include?('password_readers')
      read_ace['groups'] << 'password_readers'
    end

    # PUT the updated 'read' ACE back to the server at the specific 'read' endpoint
    rest.put("#{acl_path}/read", { "read" => read_ace })
    Chef::Log.info("Successfully enforced ACLs for passwords data bag via API.")

  rescue Net::HTTPServerException => e
    Chef::Log.warn("Could not manage ACLs for passwords data bag via API: #{e.message}")
  end

rescue StandardError => e
  Chef::Log.warn("Failed to manage password_readers group: #{e.message}")
  Chef::Log.warn(e.backtrace.join("\n"))
end
