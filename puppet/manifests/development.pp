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
    ["vim", "puppet","emacs23-nox", "libmysqlclient-dev"]: 
      ensure => latest, require => Exec['apt-update'];
  }
  class { 'mysql::server':
    config_hash => { 'root_password' => 'foo' },
  }
  class { 'mysql::ruby': }
  include installrvm
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
      privileges => ['all'];
  }
  rvm_system_ruby {
    'ruby-1.8.7-p352':
      ensure      => 'present',
      default_use => false;
  }
  rvm_gemset {
    "ruby-1.8.7-p352@notifier-dev":
      ensure  => 'present',
      require => Rvm_system_ruby['ruby-1.8.7-p352'];
  }
  rvm_gemset {
    "ruby-1.8.7-p352@hotline-dev":
      ensure  => 'present',
      require => Rvm_system_ruby['ruby-1.8.7-p352'];
  }
  notifier_gem {
    'abstract':
      version => '1.0.0';
    'actionmailer':
      version => '3.0.9';
    'actionpack':
      version => '3.0.9';
    'activemodel':
      version => '3.0.9';
    'activerecord':
      version => '3.0.9';
    'activeresource':
      version => '3.0.9';
    'activesupport':
      version => '3.0.9';
    'arel':
      version => '2.0.10';
    'builder':
      version => '3.0.0';
    'bundler':
      version => '1.0.21';
    'erubis':
      version => '2.7.0';
    'factory_girl':
      version => '1.3.3'; 
    'factory_girl_rails':
      version => '1.0.1'; 
    'fastercsv':
      version => '1.5.4'; 
    'gcal4ruby':;
    'haml':
      version => '3.1.2'; 
    'haml-rails':
      version => '0.3.4'; 
    'i18n':
      version => '0.6.0';
    'jquery-rails':
      version => '1.0.13'; 
    'jsonschema':
      version => '2.0.1'; 
    'kaminari':
      version => '0.12.4'; 
    'macaddr':
      version => '1.0.0'; 
    'mail':
      version => '2.4.4';
    'mime-types':
      version => '1.19';
    'mocha':
      version => '0.9.12'; 
    'polyglot':
      version => '0.3.3';
    'rack-mount':
      version => '0.6.14';
    'rack-test':
      version => '0.6.1';
    'rack':
      version => '1.4.1';
    'rails':
      version => '3.0.9'; 
    'railties':
      version => '3.0.9';
    'rails3-generators':
      version => '0.17.4'; 
    'rake':
      version => '0.9.2.2';
    'rdoc':
      version => '3.8'; 
    'rest-client':
      version => '1.6.3'; 
    'simple_form':
      version => '1.4.2'; 
    'sqlite3':
      version => '1.3.3';
    'thor':
      version => '0.14.6'; 
    'treetop':
      version => '1.4.10';
    'tzinfo':
      version => '0.3.33';
    'uuid':
      version => '2.3.2';
  }
  rvm_gem {
    'ruby-1.8.7-p352@notifier-dev/mysql2':
      ensure  => '0.2.18',
      require => [
                  Rvm_gemset['ruby-1.8.7-p352@notifier-dev'],
                  Package['libmysqlclient-dev']
                  ];
  }
  hotline_gem {
    'actionmailer': version => '2.3.5';
    'actionpack': version => '2.3.5';
    'activerecord': version => '2.3.5';
    'activeresource': version => '2.3.5';
    'activesupport': version => '2.3.5';
    'builder': version => '2.1.2';
    'bundler':
      version => '1.0.21';
    'fastercsv': version => '1.5.4';
    'i18n': version => '0.5.0';
    'json': version => '1.5.1';
    'mocha': version => '0.9.12';
    'mysql2': version => '< 0.3';
    'rack': version => '1.0.1';
    'rails': version => '2.3.5';
    'rake': version => '0.9.2';
    'rcov': version => '0.9.9';
    'rubygems-update': version => '1.5.3';
    'tzinfo': version => '0.3.29';
  }
    rvm_gem {
    'ruby-1.8.7-p352@hotline-dev/mysql':
      ensure  => 'absent';
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
      privileges => ['all'];
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
  # file { "/home/${username}/apps":
  #   ensure  => directory,
  #   owner   => $username,
  #   group   => $username,
  #   mode    => "0755",
  #   require => User[$username],
  # }
  rvm::system_user { $username:
    require => Class['installrvm']; }
}
define notifier_gem ($gem = $title, $version = 'present') {
  rvm_gem {
    "ruby-1.8.7-p352@notifier-dev/${gem}":
      ensure  => $version,
      require => Rvm_gemset['ruby-1.8.7-p352@notifier-dev'];
  }
}
define hotline_gem ($gem = $title, $version = 'present') {
  rvm_gem {
    "ruby-1.8.7-p352@hotline-dev/${gem}":
      ensure  => $version,
      require => Rvm_gemset['ruby-1.8.7-p352@hotline-dev'];
  }
}

class installrvm {
  include rvm
  rvm::system_user { vagrant:; }

  if $rvm_installed == "true" {
    rvm_system_ruby {
      'ruby-1.9.3-p0':
        ensure => 'present';
    }
  }
}
