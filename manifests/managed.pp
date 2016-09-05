class nubis_users::managed(
  $ensure     = 'present',
  $managehome = false,
  $shell    = '/sbin/nologin',
){

  # anyone who doesn't belong gets purged
  resources { 'user':
    purge => true,
  }

  # we want to make sure that these few users are actually
  # not purged so we just make sure they exist
  $managed = hiera_hash('nubis_users::managed::user', {})
  create_resources(user, $managed, { 'managehome' => $managehome, 'shell' =>  $shell })

}
