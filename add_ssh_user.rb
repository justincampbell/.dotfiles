#!/usr/bin/env ruby

CHARACTERS = (('A'..'Z').to_a + ('a'..'z').to_a + (0..9).to_a)
GROUP = 53

def ridiculous_password
  (1..20).map do
    CHARACTERS[rand(CHARACTERS.length)]
  end.join
end

def create_ssh_user(username)
  `dscl . -create /Users/#{username}`
  `dscl . -create /Users/#{username} UserShell /bin/bash`
  `dscl . -create /Users/#{username} RealName "#{username}"`
  `dscl . -create /Users/#{username} UniqueID #{rand(100_000)}`
  `dscl . -create /Users/#{username} NFSHomeDirectory /Users/#{username}`
  `dscl . -create /Users/#{username} PrimaryGroupID #{GROUP}` #console users
  `mkdir -p /Users/#{username}/.ssh`
  `dscl . -passwd /Users/#{username} #{ridiculous_password}`
  `defaults write /Library/Preferences/com.apple.loginwindow HiddenUsersList -array-add #{username}`
end

def setup_pub_key_for(username, args = {})
  pub_key_filepath, user_path = args[:key_path], args[:user_path]
  `cp #{pub_key_filepath} #{user_path}/.ssh/id_rsa.pub`
  `cat #{pub_key_filepath} > #{user_path}/.ssh/authorized_keys`
end

def change_ownership_to(username, args = {})
  user_path = args[:for]
  `chown -R #{username} #{user_path}`
  `chgrp -R #{GROUP} #{user_path}`
end

username = ARGV.shift
pub_key_filepath = ARGV.shift
user_path = "/Users/#{username}"

create_ssh_user username
setup_pub_key_for username, :key_path => pub_key_filepath, :user_path => user_path
change_ownership_to username, :for => user_path
`dseditgroup -o edit -a #{username} -t user com.apple.access_ssh`

