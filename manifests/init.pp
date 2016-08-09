
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
    $users = hiera_hash('nubis_users::user', {})
    create_resources('nubis_users::user', $users, { 'gid' => $users_group })

    # Add users to sudo (Requires saz/sudo module)
    sudo::conf { 'admins':
        priority  => 10,
        content => "%${admin_group} ALL=(ALL) NOPASSWD: ALL",
    }

}
