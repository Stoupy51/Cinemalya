
#> cinemalya:v1.1.2/editor/remove_last
#
# @executed	as & at the player who left clicked,from the editor item's enchantment
#
# @within	enchantment cinemalya:editor_left_click
#

execute unless entity @s[tag=cinemalya.editor] run return 0
execute unless items entity @s weapon.mainhand *[custom_data~{cinemalya:{editor:true}}] run return 0
execute if score #keyframes cinemalya.data matches ..0 run return run title @s actionbar {text:"No keyframe to remove",color:"red"}
execute as @e[type=text_display,tag=cinemalya.keyframe] if score @s cinemalya.data = #keyframes cinemalya.data run kill @s
data remove storage cinemalya:editor keyframes[-1]
execute if score #keyframes cinemalya.data matches 2.. run data remove storage cinemalya:editor trail[-1]
scoreboard players remove #keyframes cinemalya.data 1
title @s actionbar [{text:"Keyframe removed, ",color:"gold"},{score:{name:"#keyframes",objective:"cinemalya.data"},color:"yellow"},{text:" left",color:"gold"}]
playsound minecraft:ui.button.click master @s ~ ~ ~ 0.5 0.8

