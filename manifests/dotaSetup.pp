#################
# Configuration #
#################

$serverDir = '/home/minecraft'
$configUrl = 'git://github.com/barroncraft/minecraft-dota-config.git'
$configName = 'barron-minecraft-dota'
$paths = [
    '/bin',
    '/sbin',
    '/usr/bin',
    '/usr/sbin',
    '/usr/local/bin',
    '/usr/local/sbin'
]

#########################
# Minecraft Dota Config #
#########################

## Packages ##
case $operatingsystem {
    centos, redhat: {
        $javaPackage = 'java-1.7.0-openjdk'
        $gitPackage = 'git'
        $vimPackage = 'vim-enhanced'
        $rubyDevPackage = 'ruby-devel'
    }
    debian: {
        $javaPackage = 'openjdk-6-jre'
        $gitPackage = 'git-core'
        $vimPackage = 'vim'
        $rubyDevPackage = 'ruby-dev'
    }
    ubuntu: {
        $javaPackage = 'openjdk-7-jre'
        $gitPackage = 'git'
        $vimPackage = 'vim'
        $rubyDevPackage = 'ruby-dev'
    }
    default: {
        fail('Unsuported operating system. Email contact@barroncraft.com if you need help.')
    }
}

package { [
    'sudo',
    'screen',
    $vimPackage,
    $gitPackage,
    'make',
    'gcc',
    $rubyDevPackage,
    'htop',
    'wget',
    'less',
    'rsync',
    'zip',
    'gzip',
    $javaPackage
]:
    ensure => installed,
}

package { 'rake':
    ensure   => installed,
    provider => 'gem',
}

package { 'bukin':
    ensure   => installed,
    provider => 'gem',
    require  => [
        Package['make'],
        Package['gcc'],
        Package[$rubyDevPackage],
    ],
}

## Service & Cron ##

service { 'minecraft':
    ensure  => 'running',
    enable  => true,
    require => [
        File['minecraftInit'],
        Exec['setupDota'],
    ],
}

cron { 'resetDotaCron':
    command => "${serverDir}/bin/checkreset.sh",
    user    => 'minecraft',
    minute  => '*/1',
    require => File['minecraftResetScript'],
}

##  Scripts ##

file { 'minecraftInit':
    ensure  => link,
    path    => '/etc/init.d/minecraft',
    target  => "${serverDir}/bin/minecraft.sh",
    mode    => '0755',
    require => File['minecraftScript'],
}

file { 'minecraftScript':
    ensure => present,
    path   => "${serverDir}/bin/minecraft.sh",
    source => 'file:///etc/puppet/modules/minecraft/bin/minecraft.sh',
    owner  => 'minecraft',
    group  => 'mc-editors',
    mode   => '0774',
}

file { 'minecraftResetScript':
    ensure => present,
    path   => "${serverDir}/bin/checkreset.sh",
    source => 'file:///etc/puppet/modules/minecraft/bin/checkreset.sh',
    owner  => 'minecraft',
    group  => 'mc-editors',
    mode   => '0774',
}

## Direcories ##
file { [
    $serverDir,
    "${serverDir}/backups",
    "${serverDir}/backups/worlds",
    "${serverDir}/backups/worlds/dota",
    "${serverDir}/backups/server",
    "${serverDir}/bin",
    "${serverDir}/configs",
    "${serverDir}/configs/default",
    "${serverDir}/logs"
]:
    ensure  => 'directory',
    owner   => 'minecraft',
    group   => 'mc-editors',
    mode    => '0774',
}

file { "${serverDir}/server":
    ensure => link,
    target => "configs/${configName}",
    owner  => 'minecraft',
    group  => 'mc-editors',
    mode   => '0744',
}

## Users & Groups ##

user { 'minecraft':
    ensure => 'present',
    shell  => '/bin/bash',
    home   => $serverDir,
}

file { "${serverDir}/.bashrc":
    ensure  => 'present',
    content => 'PATH=$PATH:~/bin',
    owner   => 'minecraft',
    group   => 'mc-editors',
    mode    => '0644',
}

group { 'mc-editors':
    ensure => 'present',
}

## Configuration ##

exec { 'createConfig':
    command => "git clone ${configUrl} ${configName}",
    cwd     => "${serverDir}/configs",
    creates => "${serverDir}/configs/${configName}",
    path    => $paths,
    user    => 'minecraft',
    require => [
        Package[$gitPackage],
        File["${serverDir}/configs"]
    ],
}

exec { 'setupDota':
    command => 'rake build',
    cwd     => "${serverDir}/server/",
    creates => "${serverDir}/server/backups/",
    path    => $paths,
    user    => 'minecraft',
    require => [
        Exec['createConfig'],
        Package['rake'],
        Package['bukin'],
    ],
}
