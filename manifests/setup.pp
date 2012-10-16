#################
# Configuration #
#################

$serverDir = "/home/minecraft"

####################
# Minecraft Config #
####################

## Packages ##
package { [ "sudo", 
            "screen", 
            "puppet", 
            "vim", 
            "git-core", 
            "wget", 
            "less", 
            "rsync",
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
         "${serverDir}/backups/server", 
         "${serverDir}/bin", 
         "${serverDir}/configs", 
         "${serverDir}/configs/default", 
         "${serverDir}/logs", 
         "${serverDir}/worlds" ]:
    ensure  => "directory",
    owner   => "minecraft",
    group   => "mc-editors",
    mode    => 774,
}

file { "${serverDir}/server":
    ensure => link,
    target => "${serverDir}/configs/default",
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

group { "mc-editors":
    ensure => "present",
}
