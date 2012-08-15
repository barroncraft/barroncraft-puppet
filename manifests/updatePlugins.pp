$latest = "latest"
$pluginsPath = "/home/minecraft/server/plugins"

bukkitPlugin { "ChestBank":              } 
bukkitPlugin { "CommandBook":            } 
bukkitPlugin { "CommandHelper":          } 
bukkitPlugin { "DeathControl":           } 
bukkitPlugin { "MessageChangerLite":     } 
bukkitPlugin { "MineQuery":              } 
bukkitPlugin { "NoCheatPlus":            } 
bukkitPlugin { "PermissionsEx":          } 
bukkitPlugin { "Permissions":            } 
bukkitPlugin { "SimpleClans":            } 
bukkitPlugin { "SimpleClansExtensions":  } 
bukkitPlugin { "Vault":                  } 
bukkitPlugin { "WorldBorder":            } 
bukkitPlugin { "WorldGuard":             } 
bukkitPlugin { "WorldEdit":              } 

define bukkitPlugin($pluginName = $title, $version = $latest) {
    exec { "DownloadPlugin":
        command => "wget http://bukget.org/api/plugin/${pluginName}/${version}/download -O ${pluginName}.jar",
        creates => "${pluginName}.jar",
        cwd     => $pluginsPath,
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        user    => "minecraft",
    }
}

