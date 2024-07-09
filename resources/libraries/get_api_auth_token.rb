module RbManager
  module Helpers
    # TODO: find a good way of doing this
    # Gets the first user api token
    def get_api_auth_token
      `echo "SELECT authentication_token FROM users WHERE id = 1;" | rb_psql redborder | awk 'NR==3 {print $1}' | tr -d '\n'`
    end
  end
end
