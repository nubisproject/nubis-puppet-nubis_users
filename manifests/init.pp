
class nubis_users(
    $ensure         = present,
    $admin_group    = 'wheel',
    $users_group    = 'users',
){

    if !($ensure in ['present', 'absent']) {
        fail("[fail] ${ensure} is not a valid parameter")
    }

    if $ensure == 'present' {
        $group_ensure   = 'present'
    }
    else {
        $group_ensure   = 'absent'
    }

    group { $users_group:
        ensure => $group_ensure,
        system => true,
    }

    group { $admin_group:
        ensure => $group_ensure,
        system => true,
    }

    # For users that are just required on the instance
    require nubis_users::managed

    # Create users here
    $users = hiera_hash('nubis_users::user', {})
    create_resources('nubis_users::user', $users, { 'groups' => $users_group })

    # This needs to be here becuase this module purges configs
    # we don't want it purging default user sudo access
    class { 'sudo':
      purge               => false,
      config_file_replace => false,
    } ->
    # Add users to sudo (Requires saz/sudo module)
    sudo::conf { 'admins':
        priority  => 10,
        content => "%${admin_group} ALL=(ALL) NOPASSWD: ALL",
    }

}
