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
}
