class redis::sentinel::install {
  if $::redis::params::sentinel_rc {
    file { $::redis::params::sentinel_rc:
      ensure  => $::redis::sentinel::file_ensure,
      content => template($::redis::params::sentinel_rc_erb),
      mode    => '0755',
      owner   => 'root',
      group   => '0',
    }
  }
}
