class redis::params {
  $version      = 'present'

  $port                              = 6379
  $bind                              = ['127.0.0.1', '::1']
  $socket                            = undef
  $socketperm                        = '755'
  $timeout                           = 0
  $databases                         = 16
  $save                              = ['900 1', '300 10', '60 10000']
  $auth                              = undef
  $rename_command                    = {}
  $tcp_backlog                       = 511
  $tcp_keepalive                     = 0
  $log_level                         = 'notice'
  $syslog                            = false
  $syslog_ident                      = 'redis'
  $syslog_facility                   = 'local0'
  $stop_writes_on_bgsave_error       = true
  $rdbcompression                    = true
  $rdbchecksum                       = true
  $dbfilename                        = 'dump.db'
  $slaveof_ip                        = undef
  $slaveof_port                      = $port
  $slave_serve_stale_data            = true
  $slave_read_only                   = true
  $repl_ping_slave_period            = 10
  $repl_timeout                      = 60 # TODO: Add check to ensure this is > than repl_ping_slave_period
  $repl_disable_tcp_nodelay          = false
  $repl_backlog_size                 = '1mb'
  $repl_backlog_ttl                  = 3600
  $slave_priority                    = 100
  $min_slaves_to_write               = 0
  $min_slaves_max_lag                = 10
  $maxclients                        = 10000
  $maxmemory                         = undef
  $maxmemory_policy                  = 'volatile-lru'
  $maxmemory_samples                 = 3
  $appendonly                        = false
  $appendfilename                    = 'appendonly.aof'
  $appendfsync                       = 'everysec' # 'always', 'everysec', 'no', false
  $no_appendfsync_on_rewrite         = false
  $auto_aof_rewrite_percentage       = 100
  $auto_aof_rewrite_min_size         = '64mb'
  $lua_time_limit                    = 5000
  $slowlog_log_slower_than           = 10000
  $slowlog_max_len                   = 128
  $latency_monitor_threshold         = 0
  $notify_keyspace_events            = ''
  $hash_max_ziplist_entries          = 512
  $hash_max_ziplist_value            = 64
  $list_max_ziplist_entries          = 512
  $list_max_ziplist_value            = 64
  $set_max_intset_entries            = 512
  $zset_max_ziplist_entries          = 128
  $zset_max_ziplist_value            = 64
  $hll_sparse_max_bytes              = 3000
  $activerehashing                   = true
  $client_output_buffer_limit_normal = '0 0 0'
  $client_output_buffer_limit_slave  = '256mb 64mb 60'
  $client_output_buffer_limit_pubsub = '32mb 8mb 60'
  $hz                                = 10
  $aof_rewrite_incremental_fsync     = yes

  $sentinel_port                    = 26379
  $sentinel_announce_ip             = undef
  $sentinel_announce_port           = undef
  $sentinel_dir                     = '/tmp'
  $monitor                          = {}
  $sentinel_quorumsize              = 2
  $sentinel_down_after_milliseconds = 30000
  $sentinel_parallel_syncs          = 1
  $sentinel_failover_timeout        = 180000
  $sentinel_notification_script     = undef
  $sentinel_reconfig_script         = undef

  $user  = 'redis'
  $group = 'redis'

  $ulimit = 10032

  case $::operatingsystem {
    Ubuntu: {
      $tcp_backlog_supported     = false
      $latency_monitor_supported = false
      $hyperloglog_supported     = false
    }
    default: {
      $tcp_backlog_supported     = true
      $latency_monitor_supported = true
      $hyperloglog_supported     = true
    }
  }

  case $::osfamily {
    FreeBSD: {
      $package_name     = 'redis'
      $service_name     = 'redis'
      $redis_conf       = '/usr/local/etc/redis.conf'
      $pidfile          = '/var/run/redis/redis.pid'
      $logfile          = '/var/log/redis/redis.log'
      $dbdir            = '/var/db/redis/'
      $shell            = '/usr/sbin/nologin'
      $binary           = '/usr/local/bin/redis-server'

      $sentinel_rc      = '/usr/local/etc/rc.d/sentinel'
      $sentinel_rc_erb  = 'redis/rc.d-sentinel.sh.erb'
      $sentinel_conf    = '/usr/local/etc/sentinel.conf'
      $sentinel_pidfile = '/var/run/redis/sentinel.pid'
      $sentinel_logfile = '/var/log/redis/sentinel.log'
      $sentinel_service = 'sentinel'
    }
    Debian: {
      $package_name     = 'redis-server'
      $service_name     = 'redis-server'
      $redis_conf       = '/etc/redis/redis.conf'
      $pidfile          = '/var/run/redis/redis-server.pid'
      $logfile          = '/var/log/redis/redis-server.log'
      $dbdir            = '/var/lib/redis/'
      $shell            = '/bin/false'
      $binary           = '/usr/bin/redis-server'

      $sentinel_rc      = '/etc/init.d/redis-sentinel'
      $sentinel_rc_erb  = 'redis/init.d-redis-sentinel.sh.erb'
      $sentinel_conf    = '/etc/redis/sentinel.conf'
      $sentinel_pidfile = '/var/run/redis/redis-sentinel.pid'
      $sentinel_logfile = '/var/log/redis/redis-sentinel.log'
      $sentinel_service = 'redis-sentinel'
    }
    Darwin: {
      $package_name     = 'redis'
      $service_name     = 'homebrew.mxcl.redis'
      $redis_conf       = '/usr/local/etc/redis.conf'
      $pidfile          = '/usr/local/var/run/redis.pid'
      $logfile          = undef
      $dbdir            = '/usr/local/var/db/redis/'
      $shell            = undef
      $binary           = '/usr/local/bin/redis-server'

      $sentinel_rc      = undef
      $sentinel_rc_erb  = undef
      $sentinel_conf    = '/usr/local/etc/sentinel.conf'
      $sentinel_pidfile = '/usr/local/var/run/sentinel.pid'
      $sentinel_logfile = ''
      $sentinel_service = 'homebrew.mxcl.sentinel'
    }
    default: {
      fail("Your osfamily ${::osfamily} is not currently supported.")
    }
  }

  $sentinel_conf_local = "${sentinel_conf}.local"
}
