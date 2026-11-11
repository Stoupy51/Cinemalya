
#> cinemalya:v1.1.2/editor/take_back
#
# @executed	as @e[type=item,distance=..4]
#
# @within	cinemalya:v1.1.2/editor/on_drop [ as @e[type=item,distance=..4] ]
#

execute unless items entity @p[tag=cinemalya.dropper] weapon.mainhand * run return run function cinemalya:v1.1.2/editor/to_hand
data modify entity @s PickupDelay set value 0s

