# Class: minecraft_dota
#
# Installs a Minecraft Dota server
#
# Parameters:
#   [*configUrl*] - Git repository storing the configuration
#   [*configName*] - Name of the configuration to store on the server
#   [*userName*] - Account that the server will run under
#   [*groupName*] - Group that will have access to administrate the server
#
# Actions:
#
# Requires:
#
# Sample Usage:
#   class { 'minecraft_dota':
#     configUrl  => 'git://github.com/barroncraft/minecraft-dota-config.git',
#     configName => 'barron-minecraft-dota',
#     userName   => 'minecraft'
#     groupName  => 'mc-editors'
#   }
#
class minecraft_dota(
  $configUrl = 'git://github.com/barroncraft/minecraft-dota-config.git',
  $configName = 'barron-minecraft-dota',
  $userName = 'minecraft',
  $groupName = 'mc-editors'
) {
  $serverDir = "/home/${userName}"
  $paths = [
    '/bin',
    '/sbin',
    '/usr/bin',
    '/usr/sbin',
    '/usr/local/bin',
    '/usr/local/sbin'
  ]

  # Packages
  case $::operatingsystem {
    centos, redhat: {
      $javaPackage = 'java-1.7.0-openjdk'
      $gitPackage = 'git'
      $vimPackage = 'vim-enhanced'
      $rubyDevPackage = 'ruby-devel'
    }
    debian: {
      $javaPackage = 'openjdk-7-jre-headless'
      $gitPackage = 'git-core'
      $vimPackage = 'vim'
      $rubyDevPackage = 'ruby-dev'
    }
    ubuntu: {
      $javaPackage = 'openjdk-7-jre-headless'
      $gitPackage = 'git'
      $vimPackage = 'vim'
      $rubyDevPackage = 'ruby-dev'
    }
    default: {
      fail('Unsuported operating system.')
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

  # Service & Cron
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
    user    => $userName,
    minute  => '*/1',
    require => File['minecraftResetScript'],
  }

  # Scripts
  file { 'minecraftInit':
    ensure  => link,
    path    => '/etc/init.d/minecraft',
    target  => "${serverDir}/bin/minecraft.sh",
    owner   => $userName,
    group   => $groupName,
    mode    => '0755',
    require => File['minecraftScript'],
  }

  file { 'minecraftScript':
    ensure => present,
    path   => "${serverDir}/bin/minecraft.sh",
    source => 'puppet:///modules/minecraft_dota/minecraft.sh',
    owner  => $userName,
    group  => $groupName,
    mode   => '0774',
  }

  file { 'minecraftResetScript':
    ensure => present,
    path   => "${serverDir}/bin/checkreset.sh",
    source => 'puppet:///modules/minecraft_dota/checkreset.sh',
    owner  => $userName,
    group  => $groupName,
    mode   => '0774',
  }

  # Direcories
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
    owner   => $userName,
    group   => $groupName,
    mode    => '0774',
  }

  file { "${serverDir}/server":
    ensure => link,
    target => "configs/${configName}",
    owner  => $userName,
    group  => $userName,
    mode   => '0744',
  }

  # Users & Groups
  user { $userName:
    ensure => 'present',
    shell  => '/bin/bash',
    home   => $serverDir,
  }

  file { "${serverDir}/.bashrc":
    ensure  => 'present',
    content => 'PATH=$PATH:~/bin',
    owner   => $userName,
    group   => $groupName,
    mode    => '0644',
  }

  group { $groupName:
    ensure => 'present',
  }

  # Configuration
  exec { 'createConfig':
    command => "git clone ${configUrl} ${configName}",
    cwd     => "${serverDir}/configs",
    creates => "${serverDir}/configs/${configName}",
    path    => $paths,
    user    => $userName,
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
    user    => $userName,
    require => [
      Exec['createConfig'],
      Package['rake'],
      Package['bukin'],
    ],
  }
}
