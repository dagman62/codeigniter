["httpd","unzip","git","vim","net-tools"].each do |p|
	package p do
	  action :install
  end
end
	
execute "epel" do
	not_if "rpm -qa | grep -i 'epel'"
	command "rpm -Uvh https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm"
end

execute "webtatic" do
	not_if "rpm -qa | grep -i 'webtatic'"
	command "rpm -Uvh https://mirror.webtatic.com/yum/el7/webtatic-release.rpm"
end

execute "makecache" do
	command 'yum makecache'
end

%w(mod_php71w php71w-cli php71w-common php71w-gd php71w-mbstring php71w-mcrypt php71w-mysqlnd php71w-xml).each do |p|
	package p do
    action :install
	end
end

["httpd"].each do |p|
	service p do
		action [:start,:enable]
	end
end

remote_file '/tmp/codeingiter_source.zip' do
    source 'https://github.com/bcit-ci/CodeIgniter/archive/3.1.8.zip'
end
bash "unzip CodeIgniter" do
  code <<-EOT
  rm -rf /var/www/html/{*,.*}
  unzip /tmp/codeingiter_source.zip -d /var/www/html/
  mv /var/www/html/CodeIgniter-*/{*,.*} /var/www/html/
  chown -R vagrant:vagrant /var/www/html/
  rmdir /var/www/html/CodeIgniter-*
  EOT
end
  
remote_file '/tmp/phpmyadmin.tgz' do
  source 'https://files.phpmyadmin.net/phpMyAdmin/4.8.1/phpMyAdmin-4.8.1-english.tar.gz'
end
bash "Extract phpMyAdmin" do
  code <<-EOT
  mkdir /var/www/html/phpMyAdmin
  tar -zxvf /tmp/phpmyadmin.tgz -C /var/www/html/
  mv /var/www/html/phpMyAdmin-*/{*,.*} /var/www/html/phpMyAdmin/
  chown -R vagrant:vagrant /var/www/html/
  rm -rf /var/www/html/phpMyAdmin-*
  EOT
end
  
search(:codeigniter, "id:code").each do |web|
  template '/var/www/html/application/config/database.php' do
    source 'database.php.erb'
    mode "0644"
    owner "vagrant"
    group "vagrant"
    variables ({
      :login      => web['dbuser'],
      :dbname     => web['dbname'],
      :password   => web['dbuserpasswd'],
      :ipaddress  => node['ipaddress'],
    })
    action :create
  end  
end

template '/var/www/html/application/config/config.php' do
  source 'config.php.erb'
    mode "0644"
    owner "vagrant"
    group "vagrant"
    variables ({
      :webip      => node['ipaddress'],
      :webfqdn    => node['fqdn'],
    })
    action :create
end
    
search(:codeigniter, "id:code").each do |host|
  template '/var/www/html/phpMyAdmin/config.inc.php' do
    source 'config.inc.php.erb'
    mode "0644"
    owner "vagrant"
    group "vagrant"
    variables ({
      :ipaddress => node['ipaddress'],
      :login     => host['dbadmin'],
      :password  => host['dbpasswd'],
      :dbname    => host['dbname'], 
    })
    action :create
  end  
end
  
cookbook_file '/var/www/html/application/views/welcome_message.php' do
    source 'welcome_message.php'
end
  
cookbook_file '/var/www/html/application/config/autoload.php' do
    source 'autoload.php'
end
  
cookbook_file '/var/www/html/application/models/Model_users.php' do
  source 'Model_users.php'
end
  
cookbook_file '/var/www/html/application/controllers/Welcome.php' do
  source 'Welcome.php'
end