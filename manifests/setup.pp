$commonPack = [ "sudo", "screen", "puppet", "vim", "git" ]
$minecraftPack = [ "openjdk-6-jre" ]

package { commonPack:    ensure => installed }
package { minecraftPack: ensure => installed }
