# @template cinemalya_test:room
# @dummy ~ ~ ~
# @timeout 400
await score #cinemalya.loaded load.status matches 1

forceload add -8 -8 24 8
tp @s 1.5 200 0.5 0 0
gamemode survival @s
function #cinemalya:v1/launch_path {with:{mode:"ride",protect:true,duration:40,waypoints:[{args:[1.5,201.6,0.5,0,0]},{args:[9.5,201.6,0.5,0,0]}]}}

# The player sits on the camera in their own gamemode, shielded from damage
await delay 5
execute as @e[type=item_display,tag=cinemalya.cinematic] on passengers run assert entity @s[type=minecraft:player,gamemode=survival]
assert entity @s[nbt={active_effects:[{id:"minecraft:resistance"}]}]

# Sneaking cannot get them off for good
dummy @s sneak true
await delay 3
execute as @e[type=item_display,tag=cinemalya.cinematic] on passengers run assert entity @s[type=minecraft:player]
dummy @s sneak false

# The end sets them down, still in survival and no longer shielded
await not entity @e[type=item_display,tag=cinemalya.cinematic]
assert entity @s[gamemode=survival]
assert not data entity @s RootVehicle
assert not entity @s[nbt={active_effects:[{id:"minecraft:resistance"}]}]
forceload remove -8 -8 24 8
