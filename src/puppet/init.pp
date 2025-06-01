class mephi_stack {
  package { ['yum-utils', 'device-mapper-persistent-data', 'lvm2']:
    ensure => installed,
  }

  exec { 'add-docker-repo':
    command => '/usr/bin/dnf config-manager --add-repo=https://download.docker.com/linux/centos/docker-ce.repo',
    unless  => '/usr/bin/test -f /etc/yum.repos.d/docker-ce.repo',
    require => Package['yum-utils'],
  }

  package { ['docker-ce', 'docker-ce-cli', 'containerd.io']:
    ensure  => installed,
    require => Exec['add-docker-repo'],
  }

  service { 'docker':
    ensure  => running,
    enable  => true,
    require => Package['docker-ce'],
  }

  file { '/usr/local/bin/docker-compose':
    ensure => present,
    source => "https://github.com/docker/compose/releases/latest/download/docker-compose-${facts['kernel']}-${facts['architecture']}",
    mode   => '0755',
  }

  file { ['/opt/mephi', '/opt/mephi/html']:
    ensure => directory,
  }

  file { '/opt/mephi/docker-compose.yml':
    ensure  => present,
    source  => 'puppet:///modules/mephi_stack/docker-compose.yml',
    require => File['/opt/mephi'],
  }

  file { '/opt/mephi/html/index.html':
    ensure  => present,
    source  => 'puppet:///modules/mephi_stack/index.html',
    require => File['/opt/mephi/html'],
  }

  exec { 'run-docker-compose':
    command     => 'docker-compose up -d',
    cwd         => '/opt/mephi',
    path        => '/usr/bin:/usr/local/bin',
    environment => ['COMPOSE_PROJECT_NAME=mephi'],
    require     => [File['/opt/mephi/docker-compose.yml'], Service['docker']],
    unless      => 'docker ps --format "{{.Names}}" | grep mephi',
  }
}
