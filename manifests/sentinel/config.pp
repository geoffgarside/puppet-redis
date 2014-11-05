class redis::sentinel::config {
  require stdlib

  $pidfile       = $::redis::params::sentinel_pidfile
  $logfile       = $::redis::params::sentinel_logfile

  $log_level     = $::redis::sentinel::log_level
  $port          = $::redis::sentinel::port
  $announce_ip   = $::redis::sentinel::announce_ip
  $announce_port = $::redis::sentinel::announce_port
  $dir           = $::redis::sentinel::dir
  $conf_local    = $::redis::params::sentinel_conf_local

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

  concat { $conf_local:
    ensure => $::redis::sentinel::ensure,
    mode   => '0444',
    owner  => 'root',
    group  => '0',
  }

  concat::fragment { 'sentinel.conf.local':
    target  => $conf_local,
    content => template('redis/sentinel.conf.local.erb'),
    order   => '01',
  }

  $piddir     = dirname($pidfile)
  $logdir     = dirname($logfile)
  $dir_ensure = $redis::ensure ? {
    'absent'  => 'absent',
    default   => 'directory',
  }

  if $dir != "/tmp" and !defined_with_params(File[$dir], {'ensure' => $dir_ensure}) {
    file { $dir:
      ensure => $dir_ensure,
      mode   => '0755',
      owner  => $::redis::user,
      group  => $::redis::group,
    }
  }

  if $piddir != "/var/run" and !defined_with_params(File[$piddir], {'ensure' => $dir_ensure}) {
    file { $piddir:
      ensure => $dir_ensure,
      mode   => '0755',
      owner  => $::redis::user,
      group  => $::redis::group,
    }
  }

  if $logdir != "/var/log" {
    if !defined_with_params(File[$logdir], {'ensure' => $dir_ensure}) {
      file { $logdir:
        ensure => $dir_ensure,
        mode   => '0755',
        owner  => $::redis::user,
        group  => $::redis::group,
      }
    }

    File[$logdir] -> File[$logfile]
  }

  file { $logfile:
    ensure => $::redis::file_ensure,
    mode   => '0660',
    owner  => $::redis::user,
    group  => $::redis::group,
  }

}
