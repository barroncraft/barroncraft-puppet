#################
# Configuration #
#################

$serverDomain = "barroncraft.com"
$serverDir    = "/home/minecraft"

#################
# Common Config #
#################

$commonPack = [ "sudo", "screen", "puppet", "vim", "git", "figlet", "wget", "less" ]
package { $commonPack: 
    ensure => installed 
}

host { "self":
    ensure       => present,
    name         => $fqdn,
    host_aliases => [ $hostname, "${hostname}.${serverDomain}" ],
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

$minecraftPack = [ "openjdk-6-jre" ]
package { $minecraftPack: 
    ensure => installed 
}

## Init Script ##

file { "minecraftInit":
    path   => "/etc/init.d/minecraft",
    ensure => link,
    target => "${serverDir}/bin/minecraft.sh"
}

file { "minecraftScript":
    path => "${serverDir}/bin/minecraft.sh",
    ensure => present,
    source => "modules/minecraft/bin/minecraft.sh",
    mode => 764,
}

## Direcories ##
$minecraftDirs = [ 
    "${serverDir}",
    "${serverDir}/backups", 
    "${serverDir}/bin", 
    "${serverDir}/server", 
    "${serverDir}/logs", 
    "${serverDir}/worlds" ]

file { $minecraftDirs: 
    ensure  => "directory",
    owner   => "minecraft",
    group   => "mc-editors",
    mode    => 774,
}

## Users & Groups ##

user { "minecraftUser":
    name => "minecraft",
    ensure => "present",
    home => "/home/minecraft"
}

group { "minecraftEditors":
    name   => "mc-editors",
    ensure => "present",
}
