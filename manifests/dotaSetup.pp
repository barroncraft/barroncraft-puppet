#################
# Configuration #
#################

$serverDir = "/home/minecraft"
$configUrl = "git://github.com/barroncraft/minecraft-dota-config.git"
$configName = "barron-minecraft-dota"
$paths = ["/bin", "/sbin", "/usr/bin", "/usr/sbin"]

#########################
# Minecraft Dota Config #
#########################

## Packages ##
package { [ "sudo", 
            "screen", 
            "puppet", 
            "vim", 
            "git-core", 
            "wget", 
            "less", 
            "rsync",
            "zip",
            "gzip",
            "openjdk-6-jre" ]: 
    ensure => installed, 
}

## Service & Cron ##

service { "minecraft":
    enable  => true,
    require => File["minecraftInit"],
}

cron { "resetDotaCron":
    command => "${serverDir}/bin/checkreset.sh",
    user    => "minecraft",
    minute  => "*/1",
    require => File["minecraftResetScript"],
}

##  Scripts ##

file { "minecraftInit":
    path   => "/etc/init.d/minecraft",
    ensure => link,
    target => "${serverDir}/bin/minecraft.sh",
    mode   => 755,
    require => File["minecraftScript"],
}

file { "minecraftScript":
    path   => "${serverDir}/bin/minecraft.sh",
    ensure => present,
    source => "file:///etc/puppet/modules/minecraft/bin/minecraft.sh",
    owner   => "minecraft",
    group   => "mc-editors",
    mode   => 774,
}

file { "minecraftResetScript":
    path   => "${serverDir}/bin/checkreset.sh",
    ensure => present,
    source => "file:///etc/puppet/modules/minecraft/bin/checkreset.sh",
    owner   => "minecraft",
    group   => "mc-editors",
    mode   => 774,
}

## Direcories ##
file { [ "${serverDir}",
         "${serverDir}/backups", 
         "${serverDir}/backups/worlds", 
         "${serverDir}/backups/worlds/dota",
         "${serverDir}/backups/server", 
         "${serverDir}/bin", 
         "${serverDir}/configs", 
         "${serverDir}/configs/default", 
         "${serverDir}/logs" ]:
    ensure  => "directory",
    owner   => "minecraft",
    group   => "mc-editors",
    mode    => 774,
}

file { "${serverDir}/server":
    ensure => link,
    target => "configs/${configName}",
    owner  => "minecraft",
    group  => "mc-editors",
    mode   => 744,
}

## Users & Groups ##

user { "minecraft":
    ensure => "present",
    shell  => "/bin/bash",
    home   => $serverDir,
}

file { "${serverDir}/.bashrc":
    content => 'PATH=$PATH:~/bin',
    ensure  => "present",
    owner   => "minecraft",
    group   => "mc-editors",
    mode    => 644,
}

group { "mc-editors":
    ensure => "present",
}

## Configuration ##

exec { "createConfig":
    command => "git clone ${configUrl} ${configName}",
    cwd     => "${serverDir}/configs",
    creates => "${serverDir}/configs/${configName}",
    path    => $paths,
    user    => "minecraft",
    require => [
        Package["git-core"],
        File["${serverDir}/configs"]
   ],
}

exec { "createDotaBackup":
    command => "cp -r configs/${configName}/worlds/dota backups/worlds/dota/original",
    cwd     => "${serverDir}",
    creates => "${serverDir}/backups/worlds/dota/original",
    path    => $paths,
    user    => "minecraft",
    require => [
        Exec["createConfig"],
        File["${serverDir}/backups/worlds/dota"]
    ],
}

