class redis::config {
  require stdlib

  if ! has_ip_address($::redis::slaveof_ip) {
    $slaveof = "${::redis::slaveof_ip} ${::redis::slaveof_port}"
  } else {
    $slaveof = undef
  }

  $dbdir                             = $::redis::params::dbdir
  $pidfile                           = $::redis::params::pidfile
  $logfile                           = $::redis::params::logfile

  $port                              = pick($::redis::port, $::redis::params::port)
  $bind                              = join($::redis::bind, " ")
  $socket                            = $::redis::socket
  $socketperm                        = $::redis::socketperm
  $timeout                           = $::redis::timeout
  $databases                         = $::redis::databases
  $save                              = $::redis::save
  $auth                              = $::redis::auth
  $rename_command                    = $::redis::rename_command
  $tcp_backlog                       = $::redis::tcp_backlog
  $tcp_keepalive                     = $::redis::tcp_keepalive
  $log_level                         = $::redis::log_level
  $syslog                            = $::redis::syslog
  $syslog_ident                      = $::redis::syslog_ident
  $syslog_facility                   = $::redis::syslog_facility
  $stop_writes_on_bgsave_error       = $::redis::stop_writes_on_bgsave_error
  $rdbcompression                    = $::redis::rdbcompression
  $rdbchecksum                       = $::redis::rdbchecksum
  $dbfilename                        = $::redis::dbfilename
  $slave_serve_stale_data            = $::redis::slave_serve_stale_data
  $slave_read_only                   = $::redis::slave_read_only
  $repl_ping_slave_period            = $::redis::repl_ping_slave_period
  $repl_timeout                      = $::redis::repl_timeout
  $repl_disable_tcp_nodelay          = $::redis::repl_disable_tcp_nodelay
  $repl_backlog_size                 = $::redis::repl_backlog_size
  $repl_backlog_ttl                  = $::redis::repl_backlog_ttl
  $slave_priority                    = $::redis::slave_priority
  $min_slaves_to_write               = $::redis::min_slaves_to_write
  $min_slaves_max_lag                = $::redis::min_slaves_max_lag
  $maxclients                        = $::redis::maxclients
  $maxmemory                         = $::redis::maxmemory
  $maxmemory_policy                  = $::redis::maxmemory_policy
  $maxmemory_samples                 = $::redis::maxmemory_samples
  $appendonly                        = $::redis::appendonly
  $appendfilename                    = $::redis::appendfilename
  $appendfsync                       = $::redis::appendfsync
  $no_appendfsync_on_rewrite         = $::redis::no_appendfsync_on_rewrite
  $auto_aof_rewrite_percentage       = $::redis::auto_aof_rewrite_percentage
  $auto_aof_rewrite_min_size         = $::redis::auto_aof_rewrite_min_size
  $lua_time_limit                    = $::redis::lua_time_limit
  $slowlog_log_slower_than           = $::redis::slowlog_log_slower_than
  $slowlog_max_len                   = $::redis::slowlog_max_len
  $latency_monitor_threshold         = $::redis::latency_monitor_threshold
  $notify_keyspace_events            = $::redis::notify_keyspace_events
  $hash_max_ziplist_entries          = $::redis::hash_max_ziplist_entries
  $hash_max_ziplist_value            = $::redis::hash_max_ziplist_value
  $list_max_ziplist_entries          = $::redis::list_max_ziplist_entries
  $list_max_ziplist_value            = $::redis::list_max_ziplist_value
  $set_max_intset_entries            = $::redis::set_max_intset_entries
  $zset_max_ziplist_entries          = $::redis::zset_max_ziplist_entries
  $zset_max_ziplist_value            = $::redis::zset_max_ziplist_value
  $hll_sparse_max_bytes              = $::redis::hll_sparse_max_bytes
  $activerehashing                   = $::redis::activerehashing
  $client_output_buffer_limit_normal = $::redis::client_output_buffer_limit_normal
  $client_output_buffer_limit_slave  = $::redis::client_output_buffer_limit_slave
  $client_output_buffer_limit_pubsub = $::redis::client_output_buffer_limit_pubsub
  $hz                                = $::redis::hz
  $aof_rewrite_incremental_fsync     = $::redis::aof_rewrite_incremental_fsync

  $tcp_backlog_supported     = $::redis::params::tcp_backlog_supported
  $latency_monitor_supported = $::redis::params::latency_monitor_supported
  $hyperloglog_supported     = $::redis::params::hyperloglog_supported

  user { $::redis::user:
    ensure  => $::redis::ensure,
    comment => 'redis server',
    gid     => $::redis::group,
    home    => $::redis::dbdir,
    shell   => $::redis::params::shell,
  }

  group { $::redis::group:
    ensure => $::redis::ensure,
  }

  file { $::redis::params::redis_conf:
    ensure  => $::redis::file_ensure,
    content => template('redis/redis.conf.erb'),
    mode    => '0644',
    owner   => 'root',
    group   => '0',
  }

  $piddir     = dirname($pidfile)
  $logdir     = dirname($logfile)
  $dir_ensure = $redis::ensure ? {
    'absent'  => 'absent',
    default   => 'directory',
  }

  if $piddir != "/var/run" {
    file { $piddir:
      ensure => $dir_ensure,
      mode   => '0755',
      owner  => $::redis::user,
      group  => $::redis::group,
    }
  }

  if $logdir != "/var/log" {
    file { $logdir:
      ensure => $dir_ensure,
      mode   => '0755',
      owner  => $::redis::user,
      group  => $::redis::group,
      before => File[$logfile],
    }
  }

  file { $logfile:
    ensure => $::redis::file_ensure,
    mode   => '0660',
    owner  => $::redis::user,
    group  => $::redis::group,
  }

  case $::operatingsystem {
    'Ubuntu': {
      class { '::redis::config::ubuntu': }
    }
  }
}
