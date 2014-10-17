# We can either put monitor hash in here, which is easier to
# define in hiera, or have a separate redis::sentinel::monitor resource
#
# We could try and do both. So the monitor hash here would be given
# to create_resources('redis::sentinel::monitor', $monitor)
#
# Using the separate sentinel::monitor resource option we will probably
# need to use puppet-concat to generate the configs. The coolest option
# would be writing a redis::config provider which accepts a host/port
# pair and runs CONFIG GET, CONFIG SET, CONFIG REWRITE to make the config
# changes.
class redis::sentinel (
  $ensure        = 'present',
  $port          = $::redis::params::sentinel_port,
  $log_level     = $::redis::params::log_level,
  $announce_ip   = $::redis::params::sentinel_announce_ip,
  $announce_port = $::redis::params::sentinel_announce_port,
  $dir           = $::redis::params::sentinel_dir,
  $monitor       = $::redis::params::monitor,
  $user          = $::redis::user,
  $group         = $::redis::group,
) inherits redis::params {

  require redis

  $file_ensure = $ensure ? {
    'absent' => 'absent',
    default  => 'file',
  }

  class { '::redis::sentinel::install': }->
  class { '::redis::sentinel::config': }->
  class { '::redis::sentinel::service': }->
  Class['redis::sentinel']

  if ! empty($monitor) {
    create_resources('::redis::sentinel::monitor', $monitor)
  }
}
