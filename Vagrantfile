Vagrant.configure("2") do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  config.vm.network :private_network, ip: "172.31.31.40"
  #config.vm.synced_folder "v-root", "/vagrant", ".", :nfs => true

  config.vm.provider :virtualbox do |vb|
    # Don't boot with headless mode
    # vb.gui = true
  
    # Use VBoxManage to customize the VM. For example to change memory:
    vb.customize ["modifyvm", :id, "--memory", "1024"]
  end

  config.vm.provision :chef_solo do |chef|
    chef.cookbooks_path = "cookbooks"
    chef.add_recipe "vagrant_main"
  
    # You may also specify custom JSON attributes:
    chef.json.merge!({
      :timezone => { :zone => 'Europe/Moscow' },
      :postgresql => {
        :password => {
          :postgres => "postgres",
        },
        :config => {
          :listen_addresses => "*",
          :max_connections => 15,
          :lc_messages => "en_US.UTF-8",
          :lc_monetary => "ru_RU.UTF-8",
          :lc_numeric => "ru_RU.UTF-8",
          :lc_time => "ru_RU.UTF-8",
          :standard_conforming_strings => "off",
        },
        :pg_hba => [
          {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'trust'},
          {:type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'trust'},
        ],
      },
      :nginx => {
        :multi_accept => "on",
        :client_max_body_size => "5G",
        :default_site_enabled => false,
      },
      "php-fpm" => {
        :pools => ["www"],
        :pool => {
          :www => {
            :listen => "/var/run/php-fpm-www.sock",
            :allowed_clients => ["127.0.0.1"],
            :user => "www-data",
            :group => "www-data",
            :process_manager => "dynamic",
            :max_children => 10,
            :start_servers => 2,
            :min_spare_servers => 1,
            :max_spare_servers => 3,
            :max_requests => 500,
            :catch_workers_output => "no"
          }
        }
      },
      :hosts => ["ifree-portal.dev"],
    })
  end
end