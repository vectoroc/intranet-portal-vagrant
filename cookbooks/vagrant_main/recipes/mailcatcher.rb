#include_recipe "build-essential"
package "make"
package "g++"
package "libsqlite3-dev"
gem_package "mailcatcher"


template "/etc/init/mailcatcher.conf" do
  source "mailcatcher.upstart.conf.erb"
  mode 0644
  notifies :restart, "service[mailcatcher]", :immediately
end

service "mailcatcher" do
  provider Chef::Provider::Service::Upstart
  supports :restart => true
  action :start
end

template "#{node['php']['ext_conf_dir']}/mailcatcher.ini" do
  source "mailcatcher.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, resources("service[php-fpm]")
  #notifies :restart, resources("service[apache2]")
end