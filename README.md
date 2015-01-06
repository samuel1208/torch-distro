torch-distro
============

This is a packaging of torch that installs everything to the same folder (into a subdirectory install/).
It's useful, and is better than installing torch system-wide.

Uses git submodules, so always on the master packages.    

__install__
-------    
--- 
```
./clean_old.sh
./install.sh
```
The gfx maybe should install by yourself

__config for zbsstudio__
----------    
---
*  add the luajit interpreter    
add following code into the user.lua    

```
path.lua = "your_path/luajit" 
path.lua = "/home/samuel/project/3rdparty/torch-distro/install/bin/luajit" 

editor.tabwidth=4
editor.usetabs=true
editor.nomousezoom = true

-- allow automatically open files during debuggig
editor.autoactive = true

-- close auto-complete
acandtip.nodywords = false
```

*  config the envrioment variable    
Adding following code into the /opt/zbsstudio/lualibs/mobdebug/mobdebug.lua     

```
package.path = package.path .. ';my_path/?/init.lua'
package.cpath = package.cpath .. ';my_path/?.so'
```
    

__install path__
-------    
---
*  installs torch into the current folder torch-distro/install. 
*  If you want to install in another location, change install.sh line 5. 
*  Tested on Ubuntu 14.04, CentOS/RHEL 6.3 and OSX

