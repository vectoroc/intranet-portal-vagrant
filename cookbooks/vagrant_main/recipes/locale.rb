bash "setup locale" do
  user "root"
  code <<-EOH
  locale-gen en_US.UTF-8
  locale-gen ru_RU.UTF-8
  dpkg-reconfigure locales
  update-locale LC_ALL=en_US.UTF-8 LANG=en_US.UTF-8 LC_CTYPE=C
  EOH
  not_if "locale -a | grep -i 'ru_ru.utf-\\?8'"
end

unless ENV['LC_ALL'] == "en_US.UTF-8"
  ENV['LANG'] = ENV['LC_ALL'] = "en_US.UTF-8"
end
