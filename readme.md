Mod made by CWz aka ChaosWormz
<br>
License MIT

<p>The mod automatically grants interact to player who entered the specified keyword in chat.</p>

The commands:
<br>/setkeyword [new keyword]
<br>Required privs: server 
<br>Description: set a new keyword that will take effect after next restart.
<p>/getkeyword
<br>Description: Used to get the current keyword. this command is restricted to basic_privs and server</p>
<p>/send_spawn
<br>Description: Used to send all player who do not have interact back to spawn.
<br>Required privs: basic_privs </p>
<p>/yesinteract
<br>Description: manually grant a player interact and do what the keyword does.
<br>Required privs: basic_privs </p>

A keyword can be manually set by adding interact_keyword = keyword to minetest.conf
<h4>For the keyword to work the "nointeract" priv must be granted by default</h4>

CREDITS:

ChaosWormz
cheapie

