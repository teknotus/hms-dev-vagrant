#/etc/puppet/manifests/development.pp
class common_node{
  host { 'localhost':
    ensure => 'present',
    ip     => '127.0.0.1',
    target => '/etc/hosts',
  }
  host { 'notifier.example.com':
    host_aliases => 'notifier',
    ensure       => 'present',
    ip           => '192.168.2.10',
    target       => '/etc/hosts',
  }
  host { 'hub.example.com':
    host_aliases => 'hub',
    ensure       => 'present',
    ip           => '192.168.2.11',
    target       => '/etc/hosts',
  }
  exec { "apt-update":
    command => "/usr/bin/apt-get -y update"
  }
  package {
    ["vim", "puppet","emacs23-nox"]: 
      ensure => latest, require => Exec['apt-update'];
  }
  class { 'mysql::server':
    config_hash => { 'root_password' => 'foo' },
  }
  class { 'mysql::ruby': } 
}

class notifier_node{
  appuser { ["notifier","hotline"]: }
  database {
    ['hms_notifier','hotline']:
      ensure   => 'present',
      require => Service[mysqld];
  }
  database_user {
    'myuser@localhost':
      password_hash => mysql_password('mypass');
  }
  database_grant {
    ['myuser@localhost/hms_notifier','myuser@localhost/hotline']:
      privileges => ['all'] ;
  }
}

class hub_node{
  appuser { "hub": }
  
  database {
    'hms_hub':
      ensure   => 'present',
      require => Service[mysqld];
  }
  database_user {
    'myuser@localhost':
      password_hash => mysql_password('mypass');
  }
  database_grant {
    'myuser@localhost/hms_hub':
      privileges => ['all'] ;
  }
}

node 'notifier' {
  include common_node
  include notifier_node
}

node 'hub' {
  include common_node
  include hub_node
}

define appuser ($username = $title) {
  user { $username:
    ensure     => "present",
    managehome => true,
  }
  file { "/home/${username}/apps":
    ensure  => directory,
    owner   => $username,
    group   => $username,
    mode    => "0750",
    require => User[$username],
  }
}
