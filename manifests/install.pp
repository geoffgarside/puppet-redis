class redis::install {
  case $::redis::ensure {
    'absent', absent: {
      $package_ensure = 'absent'
    }
    default: {
      $package_ensure = $::redis::version
    }
  }

  package { 'redis':
    ensure => $package_ensure,
    name   => $::redis::params::package_name,
  }

  if $::osfamily == 'Debian' {
    # Stop redis after install to allow redis::config to succeed
    exec { 'redis::package':
      command     => '/etc/init.d/redis-server stop ; touch /tmp/._redis_package_installed',
      creates     => '/tmp/._redis_package_installed',
      refreshonly => true,
      subscribe   => Package['redis'],
    }
  }
}
