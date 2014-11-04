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
    # Disable redis-server startup after the package has been installed
    # NOTE: I hate you Debian

    exec { 'redis::package::apt_policy':
      cwd     => '/tmp',
      command => "echo \"#!/bin/sh\nexit 101\n\" > /usr/sbin/policy-rc.d ; chmod +x /usr/sbin/policy-rc.d",
    }

    exec { 'redis::package::remove_apt_policy':
      command     => 'rm -f /usr/sbin/policy-rc.d',
      refreshonly => true,
    }

    Exec['redis::package::apt_policy'] ->
    Package['redis'] ~>
    Exec['redis::package::remove_apt_policy']
  }
}
