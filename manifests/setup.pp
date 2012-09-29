#################
# Configuration #
#################

$serverDir = "/home/minecraft"

#################
# Common Config #
#################

package { [ "sudo", 
            "screen", 
            "puppet", 
            "vim", 
            "git", 
            "wget", 
            "less" 
            "sysvconfig"]: 
    ensure => installed, 
}

host { "self":
    ensure       => present,
    name         => $fqdn,
    host_aliases => [ $hostname ],
    ip           => $ipaddress,
}

file { "motd":
    ensure  => file,
    path    => "/etc/motd",
    mode    => "0644",
    content => "Minecraft node ${hostname}",
}

####################
# Minecraft Config #
####################

## Packages ##
package { [ "openjdk-6-jre" ]: 
    ensure => installed 
}

##  Scripts ##

file { "minecraftInit":
    path   => "/etc/init.d/minecraft",
    ensure => link,
    target => "${serverDir}/bin/minecraft.sh",
    mode   => 744,
}

file { "minecraftScript":
    path   => "${serverDir}/bin/minecraft.sh",
    ensure => present,
    source => "file:///etc/puppet/modules/minecraft/bin/minecraft.sh",
    owner   => "minecraft",
    group   => "mc-editors",
    mode   => 764,
}

file { "minecraftResetScript":
    path   => "${serverDir}/bin/checkreset.sh",
    ensure => present,
    source => "file:///etc/puppet/modules/minecraft/bin/checkreset.sh",
    owner   => "minecraft",
    group   => "mc-editors",
    mode   => 764,
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
