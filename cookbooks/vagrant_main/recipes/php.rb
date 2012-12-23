include_recipe "apt"
include_recipe "php"
include_recipe "php::module_gd"
include_recipe "php::module_pgsql"
include_recipe "php::module_ldap"
include_recipe "php::module_memcache"
include_recipe "php::module_curl"

package "php5-mssql"
package "php5-imap"
package "php5-xdebug"
package "php5-xcache"

apt_repository "php5-xhprof" do
  uri "http://ppa.launchpad.net/brianmercer/php5-xhprof/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "8D0DC64F"
  action :add
end
package "php5-xhprof"
package "graphviz"


template "#{node['php']['ext_conf_dir']}/php-extra.ini" do
  source "php-extra.ini.erb"
  owner "root"
  group "root"
  mode "0644"
  action :create
  notifies :restart, resources("service[apache2]"), :delayed
end