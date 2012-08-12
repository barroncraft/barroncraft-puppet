$homeDir      = "/home/minecraft/"
$resourcesDir = "${homeDir}resources/"
$serverDir    = "${homeDir}server/" 
$pluginsDir   = "${serverDir}plugins/"

mcServer { "Spigot":                version => "1.3.1" }
mcPlugin { "ChestBank":             version => "1.0", } 
mcPlugin { "CommandBook":           version => "1.0", } 
mcPlugin { "CommandHelper":         version => "1.0", } 
mcPlugin { "DeathControl":          version => "1.0", } 
mcPlugin { "MessageChangerLite":    version => "1.0", } 
mcPlugin { "MineQuery":             version => "1.0", } 
mcPlugin { "NoCheatPlus":           version => "1.0", } 
mcPlugin { "PermissionsEx":         version => "1.0", } 
mcPlugin { "Permissions":           version => "1.0", } 
mcPlugin { "SimpleClans":           version => "1.0", } 
mcPlugin { "SimpleClansExtensions": version => "1.0", } 
mcPlugin { "Vault":                 version => "1.0", } 
mcPlugin { "WorldBorder":           version => "1.0", } 
mcPlugin { "WorldGuard":            version => "1.0", } 
mcPlugin { "WorldEdit":             version => "1.0", } 

define mcServer ($version) {
    mcFile { "minecraftserver.jar":
        targetDir => $serverDir,
        version   => $version.
        name      => $title.
    }
}

define mcPlugin ($version) {
    mcFile { "${title}":
        targetDir => $pluginsDir,
        version   => $version,
    }
}

define mcFile ($targetDir, $version, $name = $title) {
    file { "${targetDir}${title}.jar" :
        ensure => link,
        target => "${resources}${name}/${name}-${version}.jar"
    }	
}

