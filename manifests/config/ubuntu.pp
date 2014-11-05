class redis::config::ubuntu {
  $ulimit = $::redis::params::ulimit # TODO: Move to init.pp, needs to support other platforms though

  file { '/etc/default/redis-server':
    ensure  => $::redis::file_ensure,
    content => template('redis/default_redis-server.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => '0',
  }

  augeas { '/etc/sysctl.conf vm.overcommit_memory = 1':
    context => "/files/etc/sysctl.conf",
    changes => "set vm.overcommit_memory 1",
  }

  exec { 'sysctl-set-vm.overcommit_memory=1':
    command => "sysctl -w vm.overcommit_memory=1",
    unless  => "sysctl vm.overcommit_memory | grep 'vm.overcommit_memory = 1'",
  }
}
