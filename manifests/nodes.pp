# Default node configuration

user { 'minecraft':
    shell => '/bin/false',
    uid => '104',
    ensure => 'present',
    gid => '65534',
    home => '/home/minecraft'
}

group { 'mc-editors':
    ensure => 'present',
    gid => '1001'
}

