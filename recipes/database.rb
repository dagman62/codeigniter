package "mariadb-server" do
    action :install
end
  
service "mariadb" do
  action [:start,:enable]
end
  
search(:codeigniter, "id:code").each do |db|
  template '/tmp/dbroot.sh' do
    source 'dbroot.sh.erb'
    mode "0755"
    owner "root"
    group "root"
    variables ({
      :dbpasswd => db['password'],
    })
    action :create
  end  
end
  
execute 'configure db root' do
  command '/tmp/dbroot.sh'
  not_if "[ -f '/tmp/dbroot.sh' ]"
end
  
search(:codeigniter, "id:code").each do |web|
  template '/tmp/codeigniter.sql' do
    source 'codeigniter.sql.erb'
    owner "root"
    group "root"
    mode "0755"
    variables ({
      :dbname     => web['dbname'],
      :user       => web['dbuser'],
      :password   => web['dbuserpasswd'],
      :rootpasswd => web['dbpasswd'],
    })
  end
end
  
execute "configure codeigniter" do
  command 'mysql -u root < /tmp/codeigniter.sql | tee -a /tmp/done.log'
  not_if {File.exists?("/tmp/done.log")}
end
  
service 'mariadb' do
  action :restart
end
  
execute "allow http connect" do
    command 'setsebool -P httpd_can_network_connect_db 1'
end
  
execute 'allow mysql connect' do
    command 'setsebool -P allow_user_mysql_connect 1'
end