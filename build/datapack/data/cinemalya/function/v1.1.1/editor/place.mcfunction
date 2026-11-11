
#> cinemalya:v1.1.1/editor/place
#
# @executed	at @s
#
# @within	cinemalya:v1.1.1/editor/on_use
#
# @description		Record the player's eyes and rotation as the next keyframe. Sneaking lowers the eyes, so
# 				the eye anchor is read off the number display rather than computed from the feet.
#

execute if score #keyframes cinemalya.data matches 128.. run return run title @s actionbar {text:"The path is full (128 keyframes)",color:"red"}
scoreboard players add #keyframes cinemalya.data 1
execute store result storage cinemalya:editor label.n int 1 run scoreboard players get #keyframes cinemalya.data
execute anchored eyes positioned ^ ^ ^ summon text_display run function cinemalya:v1.1.1/editor/label
data modify storage cinemalya:editor new.rot set from entity @s Rotation
data modify storage cinemalya:editor keyframes append from storage cinemalya:editor new
execute if score #keyframes cinemalya.data matches 2.. run function cinemalya:v1.1.1/editor/trail/add
title @s actionbar [{text:"Keyframe ",color:"gold"},{score:{name:"#keyframes",objective:"cinemalya.data"},color:"yellow"},{text:" placed",color:"gold"}]
playsound minecraft:ui.button.click master @s ~ ~ ~ 0.5 1.6

