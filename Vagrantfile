Vagrant::Config.run do |config|
  config.vm.box = "precise32"
  config.vm.box_url = "http://files.vagrantup.com/precise32.box"

  #config.vm.boot_mode = :gui

  config.vm.network :hostonly, "172.31.31.40"
  #config.vm.share_folder "v-root", "/vagrant", ".", :nfs => true

  config.vm.customize ["modifyvm", :id, "--memory", 1024] 

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
        },
        :pg_hba => [
          {:type => 'local', :db => 'all', :user => 'postgres', :addr => nil, :method => 'trust'},
          {:type => 'host', :db => 'all', :user => 'all', :addr => '0.0.0.0/0', :method => 'trust'},
        ],
      },
      :apache => {
        :prefork => {
          :startservers => 1,
          :minspareservers => 1,
          :maxspareservers => 1,
          :serverlimit => 3,
          :maxclients => 3,
        },
      },
      :hosts => ["ifree-portal.dev"],
    })
  end
end