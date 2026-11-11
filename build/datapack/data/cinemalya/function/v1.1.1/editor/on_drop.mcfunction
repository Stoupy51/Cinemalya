
#> cinemalya:v1.1.1/editor/on_drop
#
# @executed	at @s
#
# @within	cinemalya:v1.1.1/editor/player [ at @s ]
#
# @description		The drop really happens (there is no key event), so the item is handed back before exporting.
# 				It goes back in the hand when that is free, otherwise the player picks it up again.
#

scoreboard players reset @s cinemalya.drop
tag @s add cinemalya.dropper
execute as @e[type=item,distance=..4] if items entity @s contents *[custom_data~{cinemalya:{editor:true}}] run function cinemalya:v1.1.1/editor/take_back
tag @s remove cinemalya.dropper
function cinemalya:v1.1.1/editor/export/main

