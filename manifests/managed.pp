class nubis_users::managed{

  resources { 'user':
    purge => true,
  }

  # we want to make sure that these few users are actually
  # not purged so we just make sure they exist
  $managed = hiera_hash('nubis_users::managed', {})
  create_resources('nubis_users::user', $managed)

}
