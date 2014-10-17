class redis::sentinel::config {
  require concat

  $pidfile       = $::redis::params::sentinel_pidfile
  $logfile       = $::redis::params::sentinel_logfile

  $log_level     = $::redis::sentinel::log_level
  $port          = $::redis::sentinel::port
  $announce_ip   = $::redis::sentinel::announce_ip
  $announce_port = $::redis::sentinel::announce_port
  $dir           = $::redis::sentinel::dir

  $sentinel_conf_local = $::redis::params::sentinel_conf_local

  # Create sentinel.conf which includes sentinel.conf.local
  # Only initialise the file, we will manage the local one.
  file { $::redis::params::sentinel_conf:
    ensure  => $::redis::sentinel::file_ensure,
    content => template('redis/sentinel.conf.erb'),
    mode    => '0644',
    owner   => $::redis::sentinel::user,
    group   => $::redis::sentinel::group,
    replace => false,
  }

  concat { $sentinel_conf_local:
    ensure => $::redis::sentinel::ensure,
    mode   => '0444',
    owner  => 'root',
    group  => '0',
  }

  concat::fragment { 'sentinel.conf.local':
    target  => $sentinel_conf_local,
    content => template('redis/sentinel.conf.local.erb'),
    order   => '01',
  }
}
