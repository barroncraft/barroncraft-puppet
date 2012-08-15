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

define bukkitPlugin() {
    exec { "wget --content-disposition http://bukget.org/api/plugin/${title}/latest/download": 
        cwd     => $pluginsPath,
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        user    => "minecraft",
    }
}

