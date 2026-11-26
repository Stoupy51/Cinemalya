
#> cinemalya:v1.2.1/editor/toggle_teleport
#
# @executed	at @s
#
# @within	cinemalya:v1.2.1/editor/on_swap
#
# @description		Mark the newest keyframe as reached by teleport, or unmark it. A teleport has no line leading to it.
#

execute if score #keyframes cinemalya.data matches ..1 run return run title @s actionbar {text:"A teleport needs a keyframe to leave from",color:"red"}
execute store result storage cinemalya:editor label.n int 1 run scoreboard players get #keyframes cinemalya.data
execute store success score #was_teleport cinemalya.data if data storage cinemalya:editor keyframes[-1].tp
execute if score #was_teleport cinemalya.data matches 1 run return run function cinemalya:v1.2.1/editor/unmark_teleport
data modify storage cinemalya:editor keyframes[-1].tp set value true
data remove storage cinemalya:editor trail[-1]
execute as @e[type=text_display,tag=cinemalya.keyframe] if score @s cinemalya.data = #keyframes cinemalya.data run function cinemalya:v1.2.1/editor/label_teleport with storage cinemalya:editor label
title @s actionbar [{text:"Keyframe ",color:"gold"},{score:{name:"#keyframes",objective:"cinemalya.data"},color:"yellow"},{text:" is reached by teleport",color:"aqua"}]
playsound minecraft:entity.enderman.teleport master @s ~ ~ ~ 0.4 1.4

