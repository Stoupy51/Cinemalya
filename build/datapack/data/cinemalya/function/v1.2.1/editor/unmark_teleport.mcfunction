
#> cinemalya:v1.2.1/editor/unmark_teleport
#
# @executed	at @s
#
# @within	cinemalya:v1.2.1/editor/toggle_teleport
#

data remove storage cinemalya:editor keyframes[-1].tp
function cinemalya:v1.2.1/editor/trail/add
execute as @e[type=text_display,tag=cinemalya.keyframe] if score @s cinemalya.data = #keyframes cinemalya.data run function cinemalya:v1.2.1/editor/label_text with storage cinemalya:editor label
title @s actionbar [{text:"Keyframe ",color:"gold"},{score:{name:"#keyframes",objective:"cinemalya.data"},color:"yellow"},{text:" is flown to again",color:"gold"}]
playsound minecraft:ui.button.click master @s ~ ~ ~ 0.5 0.8

