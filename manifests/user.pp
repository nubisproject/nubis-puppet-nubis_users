
define nubis_users::user(
    $ensure     = 'present',
    $username   = $name,
    $groups     = [],
    $managehome = true,
    $shell      = '/bin/bash',
    $ssh_keys   = undef,
){

    if !($ensure in ['present', 'absent']) {
        fail("[fail] ${ensure} is not a valid parameter")
    }

    if $ensure == 'present' {
        $file_ensure        = 'file'
        $directory_ensure   = 'directory'
        $user_ensure        = 'present'
    }
    else {
        $file_ensure        = 'absent'
        $directory_ensure   = 'absent'
        $user_ensure        = 'absent'

    }

    # Bunch of validations
    validate_array($groups)
    validate_string($ssh_keys)

    user { $username:
        ensure     => $user_ensure,
        groups     => $groups,
        managehome => $managehome,
        shell      => $shell,
    }

    # create home directory and generate ssh keys
    file { "/home/${username}":
        ensure => $directory_ensure,
        owner  => $name,
        group  => $name,
        mode   => '0700',
    }
    file { "/home/${username}/.ssh":
        ensure  => $directory_ensure,
        owner   => $name,
        group   => $name,
        mode    => '0700',
        require => File["/home/${username}"],
    }
    file { "/home/${username}/.ssh/authorized_keys":
        ensure  => $file_ensure,
        owner   => $name,
        group   => $name,
        mode    => '0600',
        content => template('nubis_users/authorized_keys.erb'),
        require => [ User[$username], File["/home/${username}/.ssh"] ],
    }

    # ensure subdirs are purged if ensure is set to absent
    if $ensure == 'absent' {
        File["home/${username}"] {
            force => true
        }
    }

}
