search(:codeigniter, "id:code").each do |host|
    template '/etc/hosts' do
      source 'hosts.erb'
      mode "0644"
      owner "root"
      group "root"
      variables ({
        :chefip       => host['chefip'],
        :cheffqdn     => host['cheffqdn'],
        :chefhost     => host['chefhost'],
      })
      action :create
    end  
  end