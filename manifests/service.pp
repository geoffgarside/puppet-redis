class redis::service {
  case $::redis::ensure {
    'absent', absent: {
      $file_ensure    = 'absent'
      $service_ensure = 'absent'
    }
    default: {
      $file_ensure    = 'file'
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

  if $::osfamily == 'Darwin' and $::has_brew {
    # ln -sfv /usr/local/opt/redis/*.plist ~/Library/LaunchAgents
    file { "/Library/LaunchDaemons/${::redis::params::service_name}.plist":
      ensure => $file_ensure,
      owner  => 'root',
      group  => '0',
      mode   => '0644',
      source => "/usr/local/opt/redis/${::redis::params::service_name}.plist",
      before => Service['redis'],
      notify => Service['redis'],
    }
  }
}
