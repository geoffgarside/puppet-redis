define redis::sentinel::monitor (
  $monitor                 = $name,
  $masterip,
  $masterport              = $::redis::port,
  $masterauth              = $::redis::auth,
  $quorumsize              = $::redis::params::sentinel_quorumsize,
  $down_after_milliseconds = $::redis::params::sentinel_down_after_milliseconds,
  $parallel_syncs          = $::redis::params::sentinel_parallel_syncs,
  $failover_timeout        = $::redis::params::sentinel_failover_timeout,
  $notification_script     = $::redis::params::sentinel_notification_script,
  $reconfig_script         = $::redis::params::sentinel_reconfig_script,
) {
  concat::fragment { "sentinel-monitor-${monitor}":
    content => template('redis/sentinel-monitor.conf.erb'),
    order   => '10',
  }
}
