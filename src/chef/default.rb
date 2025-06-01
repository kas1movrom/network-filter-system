package 'yum-utils'
package 'device-mapper-persistent-data'
package 'lvm2'

execute 'add-docker-repo' do
  command 'dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo'
end

%w(docker-ce docker-ce-cli containerd.io).each do |pkg|
  package pkg
end

service 'docker' do
  action [:start, :enable]
end

remote_file '/usr/local/bin/docker-compose' do
  source "https://github.com/docker/compose/releases/latest/download/docker-compose-#{node['kernel']['name']}-#{node['kernel']['machine']}"
  mode '0755'
end

directory '/opt/mephi' do
  recursive true
end

directory '/opt/mephi/html' do
  recursive true
end

cookbook_file '/opt/mephi/docker-compose.yml' do
  source 'docker-compose.yml'
end

cookbook_file '/opt/mephi/html/index.html' do
  source 'index.html'
end

# Запуск контейнеров
execute 'run-docker-compose' do
  command 'docker-compose up -d'
  cwd '/opt/mephi'
end