include_recipe "vagrant_main::locale"
include_recipe "chef-timezone"

include_recipe "apt"
include_recipe "nginx"
include_recipe "postgresql::server"
include_recipe "memcached"
include_recipe "imagemagick"

include_recipe "vagrant_main::php"
include_recipe "vagrant_main::drush"
include_recipe "vagrant_main::mailcatcher"

%w{ vim mc curl tmux }.each do |pkg|
  package pkg
end

node[:hosts].each do |site|

  docroot = "/home/vagrant/www-root/#{site}"

  template "#{node['nginx']['dir']}/sites-available/#{site}" do
    source "nginx/site.erb"
    owner "root"
    group node['nginx']['group']
    mode 00644
    variables(
      :server_name => site,
      :server_aliases => ["*.#{site}"],
      :docroot => docroot,
      :fast_cgi_pass => "unix:#{node['php-fpm']['pool']['www']['listen']}"
    )
    notifies :restart, "service[nginx]"
  end

  nginx_site site

  cron "setup cron for " + site do
    command "wget -O - -q --no-check-certificate -t 1 http://" + site + "/cron.php"
    minute "*/5"
    user "www-data"
  end

  cron "setup cron for " + site + " [ivideo]" do
    command "flock -n /tmp/ivideo-convert.lock drush ivideo-convert -r " + docroot
    user "www-data"
  end

  hostsfile_entry '127.0.0.1' do
    hostname site
  end

  #execute "psql -U postgres -c \"CREATE DATABASE " + site + "\""
end

execute "usermod --append -G vagrant www-data"

#TODO:  database init

package "ffmpeg"
package "libavcodec-extra-53"
# на дебиане вместо ffmpeg ставили libav-tools
# package "libav-tools"
# package "gpac"
# package "libavcodec-extra-53"


