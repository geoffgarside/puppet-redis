class redis (
  $ensure                            = 'present',
  $version                           = $::redis::params::version,
  $package_name                      = $::redis::params::package_name,
  $port                              = $::redis::params::port,
  $bind                              = $::redis::params::bind,
  $socket                            = $::redis::params::socket,
  $socketperm                        = $::redis::params::socketperm,
  $timeout                           = $::redis::params::timeout,
  $databases                         = $::redis::params::databases,
  $save                              = $::redis::params::save,
  $auth                              = $::redis::params::auth,
  $rename_command                    = $::redis::params::rename_command,
  $tcp_backlog                       = $::redis::params::tcp_backlog,
  $tcp_keepalive                     = $::redis::params::tcp_keepalive,
  $loglevel                          = $::redis::params::loglevel,
  $syslog                            = $::redis::params::syslog,
  $syslog_ident                      = $::redis::params::syslog_ident,
  $syslog_facility                   = $::redis::params::syslog_facility,
  $stop_writes_on_bgsave_error       = $::redis::params::stop_writes_on_bgsave_error,
  $rdbcompression                    = $::redis::params::rdbcompression,
  $rdbchecksum                       = $::redis::params::rdbchecksum,
  $dbfilename                        = $::redis::params::dbfilename,
  $slaveof_ip                        = $::redis::params::slaveof_ip,
  $slaveof_port                      = $::redis::params::slaveof_port,
  $slave_serve_stale_data            = $::redis::params::slave_serve_stale_data,
  $slave_read_only                   = $::redis::params::slave_read_only,
  $repl_ping_slave_period            = $::redis::params::repl_ping_slave_period,
  $repl_timeout                      = $::redis::params::repl_timeout,
  $repl_disable_tcp_nodelay          = $::redis::params::repl_disable_tcp_nodelay,
  $repl_backlog_size                 = $::redis::params::repl_backlog_size,
  $repl_backlog_ttl                  = $::redis::params::repl_backlog_ttl,
  $slave_priority                    = $::redis::params::slave_priority,
  $min_slaves_to_write               = $::redis::params::min_slaves_to_write,
  $min_slaves_max_lag                = $::redis::params::min_slaves_max_lag,
  $maxclients                        = $::redis::params::maxclients,
  $maxmemory                         = $::redis::params::maxmemory,
  $maxmemory_policy                  = $::redis::params::maxmemory_policy,
  $maxmemory_samples                 = $::redis::params::maxmemory_samples,
  $appendonly                        = $::redis::params::appendonly,
  $appendfilename                    = $::redis::params::appendfilename,
  $appendfsync                       = $::redis::params::appendfsync,
  $no_appendfsync_on_rewrite         = $::redis::params::no_appendfsync_on_rewrite,
  $auto_aof_rewrite_percentage       = $::redis::params::auto_aof_rewrite_percentage,
  $auto_aof_rewrite_min_size         = $::redis::params::auto_aof_rewrite_min_size,
  $lua_time_limit                    = $::redis::params::lua_time_limit,
  $slowlog_log_slower_than           = $::redis::params::slowlog_log_slower_than,
  $slowlog_max_len                   = $::redis::params::slowlog_max_len,
  $latency_monitor_threshold         = $::redis::params::latency_monitor_threshold,
  $notify_keyspace_events            = $::redis::params::notify_keyspace_events,
  $hash_max_ziplist_entries          = $::redis::params::hash_max_ziplist_entries,
  $hash_max_ziplist_value            = $::redis::params::hash_max_ziplist_value,
  $list_max_ziplist_entries          = $::redis::params::list_max_ziplist_entries,
  $list_max_ziplist_value            = $::redis::params::list_max_ziplist_value,
  $set_max_intset_entries            = $::redis::params::set_max_intset_entries,
  $zset_max_ziplist_entries          = $::redis::params::zset_max_ziplist_entries,
  $zset_max_ziplist_value            = $::redis::params::zset_max_ziplist_value,
  $hll_sparse_max_bytes              = $::redis::params::hll_sparse_max_bytes,
  $activerehashing                   = $::redis::params::activerehashing,
  $client_output_buffer_limit_normal = $::redis::params::client_output_buffer_limit_normal,
  $client_output_buffer_limit_slave  = $::redis::params::client_output_buffer_limit_slave,
  $client_output_buffer_limit_pubsub = $::redis::params::client_output_buffer_limit_pubsub,
  $hz                                = $::redis::params::hz,
  $aof_rewrite_incremental_fsync     = $::redis::params::aof_rewrite_incremental_fsync,
  $user                              = $::redis::params::user,
  $group                             = $::redis::params::group,
) inherits redis::params {
  class { '::redis::install': } ->
  class { '::redis::config': } ->
  class { '::redis::service': } ->
  Class['redis']
}
