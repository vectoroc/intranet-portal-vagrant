log "Locale " + ENV["LC_ALL"] + " / lang " + ENV["LANG"]

# setup locale 
execute "locale-gen en_US.UTF-8" 
execute "locale-gen ru_RU.UTF-8" 
execute "dpkg-reconfigure locales" do
  not_if { ENV["LC_ALL"] == "en_US.UTF-8" }
  # :not_if "locale -a | grep -i 'ru_ru.utf-\?8'"
end  
execute "update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LC_CTYPE=C"

include_recipe "apt"
include_recipe "apache2"
include_recipe "apache2::mod_php5"
include_recipe "apache2::mod_rewrite"
include_recipe "postgresql::server"
include_recipe "memcached"
include_recipe "imagemagick"

include_recipe "vagrant_main::php"
include_recipe "vagrant_main::drush"
include_recipe "vagrant_main::mailcatcher"

%w{ vim mc curl }.each do |pkg|
  package pkg
end

node[:hosts].each do |site|
  web_app site do
    template "sites.conf.erb"
    server_name site
    server_aliases ["*.#{site}"]
    docroot "/home/vagrant/www-root/#{site}"
  end

  cron "setup cron for " + site do
    command "wget -O - -q --no-check-certificate -t 1 http://" + site + "/cron.php"
    minute "*/5"
    user "www-data"
  end

  hostsfile_entry '127.0.0.1' do
    hostname site
  end

  #execute "psql -U postgres -c \"CREATE DATABASE " + site + "\""
end

execute "usermod --append -G vagrant www-data"

