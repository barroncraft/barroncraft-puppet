$pluginsPath = "/home/minecraft/server/plugins"
$pluginsList = 
    [ "chestbank"               
    , "commandbook"             
    , "commandhelper"           
    , "deathcontrol"            
    , "messagechangerlite"      
    , "minequery"               
    , "nocheatplus"             
    , "permissionsex"           
    , "simpleclans"             
    , "simpleclansextensions"   
    , "vault"                   
    , "worldborder"             
    , "worldguard"              
    , "worldedit" ]              

bukkitPlugin { $pluginsList: }

define bukkitPlugin() {
    exec { "wget --content-disposition http://bukget.org/api/plugin/${title}/latest/download": 
        cwd     => $pluginsPath,
        path    => [ "/bin", "/sbin", "/usr/bin", "/usr/sbin" ],
        user    => "minecraft",
        require => Package[ "wget" ],
    }
    
}

package { "wget": ensure => installed }
