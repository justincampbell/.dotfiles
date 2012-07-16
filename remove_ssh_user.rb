#!/usr/bin/env ruby

def delete_ssh_user(username)
  `rm -rf /Users/#{username}`
  `dseditgroup -o edit -d #{username} -t user com.apple.access_ssh`
  `dscl . -delete /Users/#{username}`
end

username = ARGV.shift
delete_ssh_user username
