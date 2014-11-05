class redis::sentinel::install {
  if $::redis::params::sentinel_rc {
    
    $sentinel_conf    = $::redis::params::sentinel_conf
    $sentinel_pidfile = $::redis::params::sentinel_pidfile
    $sentinel_piddir  = dirname($sentinel_pidfile)
    $sentinel_redis   = $::redis::params::binary
    $sentinel_service = $::redis::params::sentinel_service
    
    $redis_service    = $::redis::params::service_name
    
    $user  = $::redis::user
    $group = $::redis::group
    
    file { $::redis::params::sentinel_rc:
      ensure  => $::redis::sentinel::file_ensure,
      content => template($::redis::params::sentinel_rc_erb),
      mode    => '0755',
      owner   => 'root',
      group   => '0',
    }
  }
}
