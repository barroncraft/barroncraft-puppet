$pluginsPath = "/home/minecraft/server/plugins"
$pluginsList = 
    [ "ChestBank"               
    , "CommandBook"             
    , "CommandHelper"           
    , "DeathControl"            
    , "MessageChangerLite"      
    , "MineQuery"               
    , "NoCheatPlus"             
    , "PermissionsEx"           
    , "Permissions"             
    , "SimpleClans"             
    , "SimpleClansExtensions"   
    , "Vault"                   
    , "WorldBorder"             
    , "WorldGuard"              
    , "WorldEdit" ]              

bukkitPlugin { $pluginsList: }

define bukkitPlugin($pluginName = $title) {
    exec { "wget http://bukget.org/api/plugin/${pluginName}/latest/download -O ${pluginName}.jar":
        creates => "${pluginName}.jar",
        cwd     => $pluginsPath,
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        user    => "minecraft",
    }
}

