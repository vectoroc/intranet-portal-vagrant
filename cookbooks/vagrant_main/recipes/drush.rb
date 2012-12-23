# php_pear "Console_Getopt" do
#   action :upgrade
# end

# php_pear "pear" do
#   action :upgrade
# end

# php_pear_channel "pear.drush.org" do
#   action :discover
# end

# php_pear "drush" do
#   channel "drush"
#   action :install
# end

# it works on ubuntu 12.04
apt_repository "drush" do
  uri "http://ppa.launchpad.net/brianmercer/drush/ubuntu"
  distribution node['lsb']['codename']
  components ["main"]
  keyserver "keyserver.ubuntu.com"
  key "8D0DC64F"
  action :add
end
package "drush"
