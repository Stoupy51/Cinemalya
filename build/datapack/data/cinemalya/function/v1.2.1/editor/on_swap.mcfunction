
#> cinemalya:v1.2.1/editor/on_swap
#
# @executed	at @s
#
# @within	cinemalya:v1.2.1/editor/player [ at @s ]
#
# @description		The swap key is the teleport toggle, so the hands are swapped back through a display holding one of them.
#

summon item_display ~ ~ ~ {Tags:["cinemalya.swap"]}
item replace entity @e[type=item_display,tag=cinemalya.swap,distance=..1,limit=1] contents from entity @s weapon.mainhand
item replace entity @s weapon.mainhand from entity @s weapon.offhand
item replace entity @s weapon.offhand from entity @e[type=item_display,tag=cinemalya.swap,distance=..1,limit=1] contents
kill @e[type=item_display,tag=cinemalya.swap,distance=..1]
function cinemalya:v1.2.1/editor/toggle_teleport

