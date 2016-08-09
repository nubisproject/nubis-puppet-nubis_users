
class nubis_users(
    $ensure         = present,
    $admin_group    = 'wheel',
    $users_group    = 'users',
){

    group { $users_group:
        ensure => present,
        system => true,
    }

    group { $admin_group:
        ensure => present,
        system => true,
    }

    # Create users here
    $users = hiera_hash('nubis_users::users', {})
    create_resources('nubis_users::users', $users, { 'gid' => $users_group })

}
