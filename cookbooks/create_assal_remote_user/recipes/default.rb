#
# Cookbook Name:: create_assal_remote_user
# Recipe:: default
#
# variables
username = "assal"
ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDbkokv8g3UeJzInAW+1vo7IUQ0NTnhGDk6e9Uta+nqxG30m7WL6wfsKgb/QkTtsBdnyoPM2Fk5g9FHZCuE3orGsmE89Q9S9UuBN21JLYcCPYFz7p30pEBKFchUWLigD4gGAxhVEm1z9Y+v3qxegxTrDCuIwkgsKEQFLH5otmiEQ6fsf7TGH/DDCC7TTarXzO8XLvoOjSn18xK3VqWFfyODrFCvCM0qjtTo6QWOy0HxCTzgFnWpqwZ3aImCKV34U2/rJtUBbQPqQkZRZzatUzob75OsR33kjtb2E+ck+mpPnH+LhzVTTfY/RMYiEnuLKd8eTi9P2eNOtB9ikW1dmMUP jakeWorkMBP"

verb_username = "verbessern"
verb_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQC7MTW1qsPnyeEEtwGOVIcBsRzDzBYyqVUCiRpJ4iWVHnxptMKKtxdh19sNef7MFQCLW10KQB6dgf5nadlZR/E/qOzfURsMPNVfysq4xj9K5AWq8x4Lyfn4JCDVqo/7p2NRif0hfaGTQNXtHOfMGxQdXcuwGgBNoksGgcYtlrtNj6+4H0TihAC/IY2mexI/8MSsGbG2PAliUfCgyHSurJewENkfW9THnl2eenvyOOgkdq5yLpUD1HsWXcUfoTFud2hWnfLPU/BrbJZqQ2KiQITQ1P9pf5QDcZiOPGEBt8gujgDQciN3An/mO3OpHrRFKdArIecxZ0EzWMraiyWNwuJ5 verbessern"

#verb_ssh_key = "ssh-rsa AAAAB3NzaC1yc2EAAAABJQAAAQEA1nNPfmN5rUJPF1jNUWjuHyrj9mBHTFfqS5I8ozjObZ1VrP/3NV4krRS66iqHBiQv6BsCWQVDZbgHZ/YIJmrSHeaWiLBj5yOkTHpcX8Z4tpi1nccsUlROwuvBO+pn23nTXkOiphW/YmLZ5q1a1WOwsKR6HY+WxwFfTlBkwq5ZZpG4VQ6G4SZ91b+iNA2Put+otsIHK8zj4bXap0Y2NH3Br2bKTuf5z5SOOxaGG5MZuRSKxA2Z7ygt8Z1vBeO+fxA70Oyyjc5QQRzK55JLh64X5fInxu2UlURMdKqPlNNJRWVPFJ6ejPB0ktoeIQ8dUEqKd/XmKwXPpYMDxBI4qum4NQ== verbessern"
# home directory
home_dir = File.join('/home', username)
verb_home_dir = File.join('/home', verb_username)

# create the user
user username do
  action :create
  home home_dir
  supports manage_home: true
end

user verb_username do
	action :create
	home verb_home_dir
	supports manage_home: true
end

# add ssh key
ssh_dir = File.join(home_dir, '.ssh')
keys_file = File.join(ssh_dir, 'authorized_keys')

verb_ssh_dir = File.join(verb_home_dir, '.ssh')
verb_keys_file = File.join(verb_ssh_dir, 'authorized_keys')

directory ssh_dir do
	mode '0775'
  action :create
end

directory verb_ssh_dir do
	mode '0775'
	action :create
end


file keys_file do
  mode "0775"
  action :touch
end

file verb_keys_file do
	mode "0775"
	action :touch
end

execute "append key" do
  command "echo '#{ssh_key}' >> #{keys_file}"
  not_if "grep '#{ssh_key}' #{keys_file}"
end

execute "append verb key" do
	command "echo '#{verb_ssh_key}' >> #{verb_keys_file}"
	not_if "grep '#{verb_ssh_key}' #{verb_keys_file}"
end

file keys_file do
	mode "0644"
	action :touch
end

file verb_keys_file do
	mode "0644"
	action :touch
end

directory ssh_dir do
	mode '0700'
end

directory verb_ssh_dir do
	mode '0700'
end


service "sshd" do
	action [ :restart ]
end