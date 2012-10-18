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

cron { "minecraftToDisk":
    command => "${serverDir}/bin/minecraft.sh to-disk > /dev/null",
    user    => "minecraft",
    minute  => "*/30",
    require => File["minecraftScript"],
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

## Direcories ##
file { [ "${serverDir}",
         "${serverDir}/backups", 
         "${serverDir}/backups/worlds", 
         "${serverDir}/backups/server", 
         "${serverDir}/bin", 
         "${serverDir}/server", 
         "${serverDir}/logs", 
         "${serverDir}/worlds" ]:
    ensure  => "directory",
    owner   => "minecraft",
    group   => "mc-editors",
    mode    => 774,
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
