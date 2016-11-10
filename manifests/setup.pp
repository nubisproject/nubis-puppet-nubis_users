# This class sets up the confd and hiera files required
#
class nubis_users::setup(
  $sudo_users     = [ 'nubis_global_admins '],
  $nubis_users    = [],
){

  file { '/etc/puppet/yaml':
    ensure => directory,
    owner  => root,
    group  => root,
    mode   => '0755',
  }

  file { '/etc/puppet/hiera.yaml':
    ensure => file,
    owner  => root,
    group  => root,
    mode   => '0644',
    source => 'puppet:///modules/nubis_users/hiera.yaml',
  }

  file { '/etc/puppet/yaml/nubis_users':
    ensure  => directory,
    owner   => root,
    group   => root,
    recurse => true,
    source  => 'puppet:///modules/nubis_users/hiera',
  }

  file { '/etc/confd/conf.d/nubis-users.toml':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('nubis_users/confd/nubis-users.toml.erb'),
  }

  file { '/etc/confd/templates/nubis-users.tmpl':
    ensure  => file,
    owner   => root,
    group   => root,
    mode    => '0644',
    content => template('nubis_users/confd/nubis-users.tmpl.erb'),
    require => File['/etc/confd/conf.d/nubis-users.toml'],
  }
}
