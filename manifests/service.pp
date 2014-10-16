class redis::service {
  case $::redis::ensure {
    'absent', absent: {
      $service_ensure = 'absent'
    }
    default: {
      $service_ensure = 'running'
    }
  }

  service { 'redis':
    ensure     => $service_ensure,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    name       => $::redis::params::service_name,
  }
}
