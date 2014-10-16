class redis::sentinel::service {
  $service_ensure = $::redis::sentinel::ensure ? {
    'absent' => 'absent',
    default  => 'running',
  }

  service { 'redis-sentinel':
    ensure     => $service_ensure,
    enable     => true,
    hasstatus  => true,
    hasrestart => true,
    name       => $::redis::params::sentinel_service,
  }
}
